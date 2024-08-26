from flask import Blueprint, current_app, flash, logging, render_template, redirect, request, url_for
from flask_login import current_user, login_required
from app.db import db
from app import bcrypt
from app.forms import FeedbackForm, RegistrationForm
from app.models import User
from app.services.admin_services import check_email, count_by_role, count_total_users, create_user, load_user, logs_list, users_list
from app.services.feedback_services import get_feedback_by_id, get_feedbacks
from app.utils.decorators import role_required  # Import the custom decorator

admin_routes_bp = Blueprint("admin_routes", __name__, url_prefix="/Admin")

@admin_routes_bp.route("/")
def index():
    return redirect(url_for("auth_routes_bp.login"))

# Admin Dashboard
@admin_routes_bp.route("/Dashboard")
@login_required
@role_required(1)  # Admin role
def Dashboard():
    try:
        total_user = count_total_users()
        admin = count_by_role(1)
        staff = count_by_role(2)
        user = count_by_role(3)
        stats = {
            'all': total_user,
            'admin': admin,
            'staff': staff,
            'user': user
        }

        return render_template("/admin/dashboard.html",
                               title="Admin Dashboard",
                               stats=stats)
    except Exception as e:
        # Log the exception and provide a fallback response
        current_app.logger.error(f"An error occurred while fetching user data: {e}")
        flash("An error occurred while fetching user data", "danger")
        # Redirect to a safe page, such as the dashboard or home page
        return redirect(url_for('admin_routes.Dashboard'))
       
  

# User List
@admin_routes_bp.route("/Users")
@login_required
@role_required(1)  # Admin role
def UserList():
    try:
        get_all_user = users_list()
        if get_all_user:
            return render_template("admin/users_list.html", users=get_all_user)
        else:
            flash("No users found", "warning")
            return render_template("admin/users_list.html", users=[])
    except Exception as e:
        logging.error(f"Error occurred in UserList: {e}")
        flash("An error occurred while fetching user data", "danger")
        return redirect(url_for("admin_routes.Dashboard"))

# User Logs
@admin_routes_bp.route("/Logs/User")
@login_required
@role_required(1)  # Admin role
def UserLogs():
    try:
        get_all_logs = logs_list()
        if get_all_logs:
            return render_template('/admin/user_logs.html', items=get_all_logs)
        else:
            flash("No logs found", "warning")
            return render_template('/admin/user_logs.html', items=[])
    except Exception as e:
        logging.error(f"Error occurred in UserLogs: {e}")
        flash("An error occurred while fetching logs", "danger")
        return redirect(url_for("admin_routes.Dashboard"))

@admin_routes_bp.route('/handle_user_action/<int:user_id>', methods=['POST'])
@login_required
@role_required(1)  # Admin role
def handle_user_action(user_id):
    try:
        user = load_user(user_id)
        if not user:
            flash('User not found', 'error')
            current_app.logger.error(f"User with ID {user_id} not found")
            return redirect(url_for('admin_routes.UserList'))

        action = request.form.get('action')

        if action == 'update':
            first_name = request.form.get('first_name')
            last_name = request.form.get('last_name')
            username = request.form.get('username')
            email_address = request.form.get('email_address')
            phone_number = request.form.get('phone_number')
            password = request.form.get('password')
            
            if first_name:
                user.first_name = first_name
            if last_name:
                user.last_name = last_name
            if username:
                user.username = username
            if email_address:
                user.email_address = email_address
            if phone_number:
                user.phone_number = phone_number
            if password:
                user.password_hash = bcrypt.generate_password_hash(password).decode('utf-8')

            db.session.commit()
            flash('User updated successfully', 'success')
            current_app.logger.info(f"User with ID {user_id} updated successfully")
        elif action == 'delete':
            db.session.delete(user)
            db.session.commit()
            flash('User deleted successfully', 'success')
            current_app.logger.info(f"User with ID {user_id} deleted successfully")
        else:
            flash('Unknown action', 'error')
            current_app.logger.error(f"Unknown action '{action}' attempted for user with ID {user_id}")
        
    except Exception as e:
        current_app.logger.error(f"Error occurred in handle_user_action: {e}")
        flash("An error occurred while handling the user action", "danger")
    
    return redirect(url_for('admin_routes.UserList'))

# Create User
@admin_routes_bp.route("/Create/User", methods=['GET', 'POST'])
@login_required
@role_required(1)  # Admin role
def CreateUser():
    form = RegistrationForm()
    
    if form.validate_on_submit():
        try:
            data = {
                'username': form.username.data,
                'email': form.email.data,
                'phone_number': form.phone_number.data,
                'password': form.password.data,
                'role_id': form.role.data
            }

            if check_email(data['email']):
                flash('Email already exists', 'danger')
                return redirect(url_for('admin_routes.CreateUser'))

            hashed_password = bcrypt.generate_password_hash(data['password']).decode('utf-8')
            user = create_user(data['username'], data['email'], hashed_password, data['phone_number'], data['role_id'])
            if user:   
                flash('User successfully created', 'success')
                return redirect(url_for('admin_routes.CreateUser'))
            else:
                flash('Cannot create user', 'danger')
        except Exception as e:
            flash("An error occurred while creating the user:", 'danger')
            print(e)
    
    return render_template("admin/create_user.html", form=form)

# Feedbacks
@admin_routes_bp.route("/Feedbacks")
@login_required
@role_required(1)  # Admin role
def Feedbacks():
    feedbacks = get_feedbacks()
    return render_template("admin/feedbacks.html", feedbacks=feedbacks)

# Audit Logs
@admin_routes_bp.route("/Logs/Audit")
@login_required
@role_required(1)  # Admin role
def AuditLogs():
    return render_template("/admin/audit.html", title="Admin Audit Logs")



@admin_routes_bp.route("/Feedbacks/<int:feedback_id>", methods=['GET', 'POST'])
@login_required
@role_required(1)  # Admin role
def feedback_detail(feedback_id):
    feedback = get_feedback_by_id(feedback_id)
    
    if feedback is None:
        flash('Feedback not found', 'danger')
        return redirect(url_for('admin_routes.Feedbacks'))
    
    form = FeedbackForm(request.form)
    
    if request.method == 'POST':
        if form.validate_on_submit():
            action = request.form.get('action')
            if action == 'update':
                feedback.rating = form.rating.data
                feedback.message = form.message.data
                feedback.updated_by = current_user.user_id
                try:
                    db.session.commit()
                    flash('Feedback updated successfully', 'success')
                except Exception as e:
                    db.session.rollback()
                    current_app.logger.error(f"Error updating feedback: {e}")
                    flash('An error occurred while updating the feedback', 'danger')
            elif action == 'delete':
                try:
                    db.session.delete(feedback)
                    db.session.commit()
                    flash('Feedback deleted successfully', 'success')
                except Exception as e:
                    db.session.rollback()
                    current_app.logger.error(f"Error deleting feedback: {e}")
                    flash('An error occurred while deleting the feedback', 'danger')
            else:
                flash('Unknown action', 'danger')
        else:
            print(request.form)
            flash('Form validation failed', 'danger')
        
        return redirect(url_for('admin_routes.Feedbacks'))
    
    # Populate form with current feedback details
    form.rating.data = feedback.rating
    form.message.data = feedback.message

    return render_template("admin/feedback_detail.html", feedback=feedback, form=form)
