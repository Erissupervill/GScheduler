from datetime import datetime, timedelta
import os
from app import bcrypt
from flask import Blueprint, current_app, flash, jsonify, render_template, redirect, request, url_for
from flask_login import current_user, login_required
import numpy as np
import pandas as pd
from app.db import db
from app.forms import BranchForm, FeedbackForm, ProfileForm, RegistrationForm
from app.services.admin_services import (
    check_email, count_by_role, count_total_users, create_new_user, delete_feedback, fetch_all_users, update_user, delete_user
)
from app.services.api_services import get_booking_summaries
from app.services.branch_services import create_new_branch, delete_branch, update_branch
from app.services.feedback_services import  get_feedback_by_id, get_feedbacks, update_feedback

from app.services.logging_services import get_logs
from app.services.reservation_services import actual_data_ml, get_branch, get_reservations
from app.utils.decorators import otp_required, role_required

admin_routes_bp = Blueprint("admin_routes", __name__, url_prefix="/Admin")

@admin_routes_bp.route("/")
def index():
    return redirect(url_for("auth_routes_bp.login"))

# @admin_routes_bp.route("/test/")
# def get_summaries():
    
#     print(daily_summaries)
#     return render_template('/admin/daily_test.html')

@admin_routes_bp.route("/Profile", methods=['GET', 'POST'])
@login_required
@otp_required
@role_required(1)
def Profile():
    form = ProfileForm()
    
    if form.validate_on_submit():
        try:
            # Update profile fields
            current_user.first_name = form.first_name.data
            current_user.last_name = form.last_name.data
            current_user.email_address = form.email_address.data
            current_user.phone_number = form.phone_number.data

            # Check if password is provided and update it
            if form.password.data:
                current_user.password_hash = bcrypt.generate_password_hash(form.password.data)

            db.session.commit()
            flash('Profile updated successfully', 'success')
            return redirect(url_for('admin_routes.Profile'))
        except Exception as e:
            db.session.rollback()
            flash("An error occurred while updating the profile", 'danger')
            current_app.logger.error('Error updating profile: %s', e)

    # Pre-fill the form with current user data
    elif request.method == 'GET':
        form.first_name.data = current_user.first_name
        form.last_name.data = current_user.last_name
        form.email_address.data = current_user.email_address
        form.phone_number.data = current_user.phone_number

    return render_template("profile.html", form=form, title="User Profile")


@admin_routes_bp.route("/Dashboard")
@login_required 
@otp_required
@role_required(1)
def Dashboard():
    """Render the admin dashboard with user statistics and prediction."""
    try:
        stats = count_all_user_stats()
        summaries = get_booking_summaries()
        
        daily_summaries = summaries['daily']
        weekly_summaries = summaries['weekly']
        monthly_summaries = summaries['monthly']
        
        # Render the dashboard template with the required context
        return render_template("admin/dashboard.html", 
                               title="Dashboard", 
                               stats=stats,
                               daily_summaries=daily_summaries,
                               weekly_summaries=weekly_summaries,
                               monthly_summaries=monthly_summaries)
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
@otp_required
@role_required(1)
def UserList():
    """Render the list of users."""
    try:
        users = fetch_all_users()
        if users:
            return render_template("admin/users_list.html", users=users, title="Users")
        flash("No users found", "warning")
        return render_template("admin/users_list.html", users=[], title="Users")
    except Exception as e:
        current_app.logger.error('Error occurred in UserList: %s', e)
        flash("An error occurred while fetching user data", "danger")
        return redirect(url_for("admin_routes.Dashboard"))

@admin_routes_bp.route("/Logs/User")
@login_required 
@otp_required
@role_required(1)
def UserLogs():
    """Render the user logs page."""
    try:
        logs = get_logs()
        if logs:
            return render_template('/admin/user_logs.html', items=logs,title="Logs")
        flash("No logs found", "warning")
        return render_template('/admin/user_logs.html', items=[], title="Logs")
    except Exception as e:
        current_app.logger.error('Error occurred in UserLogs: %s', e)
        flash("An error occurred while fetching logs", "danger")
        return redirect(url_for("admin_routes.Dashboard"))

def fetch_user_logs():
    """Retrieve user logs."""
    return []  # Placeholder for actual log retrieval function

@admin_routes_bp.route('/handle_user_action/<int:id>', methods=['POST'])
@login_required 
@otp_required
@role_required(1)
def handle_user_action(id):
    """Handle user actions like update or delete."""
    try:
        action = request.form.get('action')
        if action == 'update':
            user_data = {
                'first_name': request.form.get('first_name'),
                'last_name': request.form.get('last_name'),
                'email': request.form.get('email'),
                'phone_number':request.form.get('phone_number'),
                'password':request.form.get('password'),
                'role': request.form.get('role')
            }
            update_user(id, user_data)
            flash('User updated successfully.', 'success')
        elif action == 'delete':
            delete_user(id)
            flash('User deleted successfully.', 'success')
        return redirect(url_for('admin_routes.UserList'))
    except Exception as e:
        current_app.logger.error('Error occurred in handle_user_action: %s', e)
        flash("An error occurred while handling the user action", "danger")
        return redirect(url_for('admin_routes.UserList'))

@admin_routes_bp.route('/feedbacks')
@login_required 
@otp_required
@role_required(1)
def feedback_list():
    """Render the feedback list page."""
    try:
        feedbacks = get_feedbacks()
        if feedbacks:
            return render_template('admin/feedback_list.html', feedbacks=feedbacks, title="Feedbacks")
        flash("No feedbacks found", "warning")
        return render_template('admin/feedback_list.html', feedbacks=[], title="Feedbacks")
    except Exception as e:
        current_app.logger.error('Error occurred in feedback_list: %s', e)
        flash("An error occurred while fetching feedbacks", "danger")
        return redirect(url_for('admin_routes.Dashboard'))

@admin_routes_bp.route("/Create/User", methods=['GET', 'POST'])
@login_required 
@otp_required
@role_required(1)
def CreateUser():
    """Render the user creation form and handle form submissions."""
    form = RegistrationForm()
    
    if form.validate_on_submit():
        try:
            data = {
                'first_name': form.first_name.data,
                'last_name': form.last_name.data,
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
    
    return render_template("admin/create_user.html", form=form, title="Create User")

@admin_routes_bp.route("/Feedbacks")
@login_required 
@otp_required
@role_required(1)
def Feedbacks():
    """Render the feedbacks page."""
    feedbacks = get_feedbacks()
    return render_template("admin/feedbacks.html", feedbacks=feedbacks, title="Feedbacks")

@admin_routes_bp.route("/Logs/Audit")
@login_required 
@otp_required
@role_required(1)
def AuditLogs():
    """Render the admin audit logs page."""
    return render_template("/admin/audit.html", title="Audit Logs")

@admin_routes_bp.route("/Feedbacks/<int:id>", methods=['GET', 'POST'])
@login_required 
@otp_required
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

    return render_template("admin/feedback_detail.html", feedback=feedback, form=form, title="Feedbacks")



@admin_routes_bp.route("/BranchList")
@login_required 
@otp_required
@role_required(1)
def branch_list():
    branches = get_branch()
    return render_template("admin/branch_list.html", branches = branches ,title="Branches")

@admin_routes_bp.route("/CreateBranch", methods=['GET', 'POST'])
@login_required 
@otp_required
@role_required(1)
def CreateBranch():
    """Render the user creation form and handle form submissions."""
    form = BranchForm()
    
    if form.validate_on_submit():
        try:
            data = {
                'name': form.name.data,
                'location': form.location.data,
                'capacity': form.capacity.data,
            }
            create_new_branch(data)
            flash('Branch successfully created', 'success')
            return redirect(url_for('admin_routes.CreateBranch'))
        except ValueError as e:
            flash(str(e), 'danger')
        except Exception as e:
            flash("An error occurred while creating the Branch", 'danger')
            current_app.logger.error('Error creating Branch: %s', e)
    
    return render_template("admin/create_branch.html", form=form, title="Create Branch")



@admin_routes_bp.route('/handle_branch_action/<int:id>', methods=['POST'])
@login_required 
@otp_required
@role_required(1)
def handle_branch_action(id):
    """Handle user actions like update or delete."""
    try:
        action = request.form.get('action')
        if action == 'update':
            branch_data = {
                'name': request.form.get('branch_name'),
                'location': request.form.get('branch_location'),
                'capacity': request.form.get('branch_capacity'),
            }
            import json
            print(json.dumps(branch_data) + " Abot Hhangggang dito")

            update_branch(id, branch_data)
            flash('Branch updated successfully.', 'success')
        elif action == 'delete':
            delete_branch(id)
            flash('Branch deleted successfully.', 'success')
        return redirect(url_for('admin_routes.branch_list'))
    except Exception as e:
        current_app.logger.error('Error occurred in handle_branch_action: %s', e)
        flash("An error occurred while handling the branch action", "danger")
        return redirect(url_for('admin_routes.branch_list'))