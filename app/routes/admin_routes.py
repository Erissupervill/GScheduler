from flask import Blueprint, flash, render_template, redirect, request, url_for
from flask_login import current_user, login_required
from app import db,bcrypt
from app.forms import RegistrationForm
from app.models import User
from app.services.admin_services import check_email, count_by_role, count_total_users, create_user, load_user, logs_list, users_list

admin_routes_bp = Blueprint("admin_routes", __name__, url_prefix="/Admin")

@admin_routes_bp.route("/")
def index():
    return redirect(url_for("auth_routes_bp.login"))  # Ensure correct function

# Admin
@admin_routes_bp.route("/Dashboard")
@login_required
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
                            title="Dashboard",
                            stats = stats)
    except Exception as e:
        print(f"Error Occurred: {e}")
        return "An error has occurred while fetching user data"

# User Action

@admin_routes_bp.route("/Users")
def UserList():
    try:    
        get_all_user = users_list()
        
        if get_all_user:
            return render_template("admin/users_list.html", users=get_all_user)
        else:
            return "No users found"
    except Exception as e:
        print(f"Error occurred: {e}")
        return "An error occurred while fetching user data"
    
@admin_routes_bp.route("/Create/User",methods=['GET','POST'])
def CreateUser():
  
    form = RegistrationForm()
        
    if form.validate_on_submit():
        data = {
            'username': form.username.data,
            'email': form.email.data,
            'phone_number': form.phone_number.data,
            'password': form.password.data,
            'role_id': form.role.data
        }

        
        if check_email(data['email']):
            flash('Email already exists', 'danger')
            return redirect(url_for('auth_routes.user_register'))
        hashed_password = bcrypt.generate_password_hash(data['password']).decode('utf-8')
        user = create_user(data['username'], data['email'], hashed_password, data['phone_number'], data['role_id'])
        if user:   
            flash('User successfully created', 'success')
            return redirect(url_for('admin_routes.CreateUser'))
        else:
            flash('Cannot create user', 'danger')
            return redirect(url_for('admin_routes.CreateUser'))
        # else:
        #     flash('Email already exists', 'danger')
        #     return redirect(url_for('admin_routes.CreateUser'))
    return render_template("admin/create_user.html",form=form)



@admin_routes_bp.route("/Logs/Audit")
@login_required
def AuditLogs():
    return render_template("/admin/audit.html", title="Audit Logs")

@admin_routes_bp.route("/Logs/User")
@login_required
def UserLogs():
    try:
        get_all_logs = logs_list()
        if get_all_logs:
            return render_template('/admin/user_logs.html', items = get_all_logs)
        else:
            return render_template('/admin/user_logs.html', note = "No Data Found")
    except Exception as e:
        print(f"Error occurred: {e}")
        return "An error occurred while fetching user data"
    
@admin_routes_bp.route('/handle_user_action/<int:user_id>', methods=['POST'])
def handle_user_action(user_id):
    user = load_user(user_id)
    if not user:
        flash('User not found', 'error')
        return redirect(url_for('admin_routes.UserLogs'))  # Redirect to the user list page

    action = request.form.get('action')

    if action == 'update':
        # Handle the update logic here
        flash('User updated successfully', 'success')
    elif action == 'delete':
        # Handle the delete logic here
        db.session.delete(user)
        db.session.commit()
        flash('User deleted successfully', 'success')
    else:
        flash('Unknown action', 'error')

    return redirect(url_for('admin_routes.UserList'))
