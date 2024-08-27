from flask import Blueprint, current_app, flash, render_template, redirect, request, url_for
from flask_login import current_user, login_required
from app.forms import FeedbackForm, RegistrationForm
from app.models import User
from app.services.admin_services import (
    check_email, count_by_role, count_total_users, create_new_user, fetch_all_users, update_user, delete_user
)
from app.services.feedback_services import get_feedback_by_id, get_feedbacks, update_feedback, delete_feedback
from app.utils.decorators import role_required

admin_routes_bp = Blueprint("admin_routes", __name__, url_prefix="/Admin")

@admin_routes_bp.route("/")
def index():
    return redirect(url_for("auth_routes_bp.login"))

@admin_routes_bp.route("/Dashboard")
@login_required
@role_required(1)
def Dashboard():
    """Render the admin dashboard with user statistics."""
    try:
        stats = count_all_user_stats()
        return render_template("admin/dashboard.html", title="Admin Dashboard", stats=stats)
    except Exception as e:
        current_app.logger.error('An error occurred while fetching user data: %s', e)
        flash("An error occurred while fetching user data", "danger")
        return redirect(url_for('admin_routes.Dashboard'))

def count_all_user_stats():
    """Fetch user statistics for the dashboard."""
    total_user = count_total_users()
    admin = count_by_role(1)
    staff = count_by_role(2)
    user = count_by_role(3)
    return {
        'all': total_user,
        'admin': admin,
        'staff': staff,
        'user': user
    }

@admin_routes_bp.route("/Users")
@login_required
@role_required(1)
def UserList():
    """Render the list of users."""
    try:
        users = fetch_all_users()
        print(users)
        if users:
            return render_template("admin/users_list.html", users=users)
        flash("No users found", "warning")
        return render_template("admin/users_list.html", users=[])
    except Exception as e:
        current_app.logger.error('Error occurred in UserList: %s', e)
        flash("An error occurred while fetching user data", "danger")
        return redirect(url_for("admin_routes.Dashboard"))

  # Fixed to use SQLAlchemy query

@admin_routes_bp.route("/Logs/User")
@login_required
@role_required(1)
def UserLogs():
    """Render the user logs page."""
    try:
        logs = fetch_user_logs()
        if logs:
            return render_template('/admin/user_logs.html', items=logs)
        flash("No logs found", "warning")
        return render_template('/admin/user_logs.html', items=[])
    except Exception as e:
        current_app.logger.error('Error occurred in UserLogs: %s', e)
        flash("An error occurred while fetching logs", "danger")
        return redirect(url_for("admin_routes.Dashboard"))

def fetch_user_logs():
    """Retrieve user logs."""
    return []  # Placeholder for actual log retrieval function

@admin_routes_bp.route('/handle_user_action/<int:id>', methods=['POST'])
@login_required
@role_required(1)
def handle_user_action(id):
    """Handle user actions like update or delete."""
    try:
        action = request.form.get('action')
        if action == 'update':
            # Gather form data
            user_data = {
                'first_name': request.form.get('first_name'),
                'last_name': request.form.get('last_name'),
                'username': request.form.get('username'),
                'email_address': request.form.get('email_address'),
                'phone_number': request.form.get('phone_number'),
                'password': request.form.get('password')
            }
            
            # Update user
            update_user(id, user_data)
            flash('User updated successfully', 'success')
            current_app.logger.info(f'User with ID {id} updated successfully')

        elif action == 'delete':
            # Delete user
            delete_user(id)
            flash('User deleted successfully', 'success')
            current_app.logger.info(f'User with ID {id} deleted successfully')

        else:
            flash('Unknown action', 'error')
            current_app.logger.error(f'Unknown action "{action}" attempted for user with ID {id}')

    except Exception as e:
        current_app.logger.error(f'Error occurred in handle_user_action: {e}')
        flash("An error occurred while handling the user action", "danger")
    
    return redirect(url_for('admin_routes.UserList'))


@admin_routes_bp.route("/Create/User", methods=['GET', 'POST'])
@login_required
@role_required(1)
def CreateUser():
    """Render the user creation form and handle form submissions."""
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

            create_new_user(data)
            flash('User successfully created', 'success')
            return redirect(url_for('admin_routes.CreateUser'))
        except ValueError as e:
            flash(str(e), 'danger')
        except Exception as e:
            flash("An error occurred while creating the user", 'danger')
            current_app.logger.error('Error creating user: %s', e)
    
    return render_template("admin/create_user.html", form=form)

@admin_routes_bp.route("/Feedbacks")
@login_required
@role_required(1)
def Feedbacks():
    """Render the feedbacks page."""
    feedbacks = get_feedbacks()
    return render_template("admin/feedbacks.html", feedbacks=feedbacks)

@admin_routes_bp.route("/Logs/Audit")
@login_required
@role_required(1)
def AuditLogs():
    """Render the admin audit logs page."""
    return render_template("/admin/audit.html", title="Admin Audit Logs")

@admin_routes_bp.route("/Feedbacks/<int:id>", methods=['GET', 'POST'])
@login_required
@role_required(1)
def feedback_detail(id):
    """Render feedback detail and handle updates or deletions."""
    feedback = get_feedback_by_id(id)
    if feedback is None:
        flash('Feedback not found', 'danger')
        return redirect(url_for('admin_routes.Feedbacks'))
    
    form = FeedbackForm(request.form)
    
    if request.method == 'POST':
        if form.validate_on_submit():
            action = request.form.get('action')
            if action == 'update':
                try:
                    data = {
                        'rating': int(form.rating.data),  # Ensure it's an integer
                        'message': str(form.message.data),  # Ensure it's a string
                        'updated_by': str(current_user.user_id)  # Ensure it's an integer
                        }
                    print(type(data))
                    update_feedback(id, data)
                    
                    flash('Feedback updated successfully', 'success')
                except ValueError as e:
                    flash(str(e), 'danger')
                except Exception as e:
                    current_app.logger.error('Error updating feedback: %s', e)
                    flash('An error occurred while updating the feedback', 'danger')
            elif action == 'delete':
                try:
                    delete_feedback(id)
                    flash('Feedback deleted successfully', 'success')
                except ValueError as e:
                    flash(str(e), 'danger')
                except Exception as e:
                    current_app.logger.error('Error deleting feedback: %s', e)
                    flash('An error occurred while deleting the feedback', 'danger')
            else:
                flash('Unknown action', 'danger')
        else:
            flash('Form validation failed', 'danger')
        
        return redirect(url_for('admin_routes.Feedbacks'))
    
    form.rating.data = feedback.rating
    form.message.data = feedback.message

    return render_template("admin/feedback_detail.html", feedback=feedback, form=form)
