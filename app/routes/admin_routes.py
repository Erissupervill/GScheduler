from datetime import datetime, timedelta
import os
from flask import Blueprint, current_app, flash, jsonify, render_template, redirect, request, url_for
from flask_login import current_user, login_required
import numpy as np
import pandas as pd
from app.forms import FeedbackForm, RegistrationForm
from app.ml_model import get_historical_data, get_reservation_predictions,  train_model
from app.models import User
from app.services.admin_services import (
    check_email, count_by_role, count_total_users, create_new_user, delete_feedback, fetch_all_users, update_user, delete_user
)
from app.services.feedback_services import  get_feedback_by_id, get_feedbacks, update_feedback

from app.services.logging_services import get_logs
from app.services.reservation_services import actual_data_ml, get_reservations
from app.utils.decorators import role_required

admin_routes_bp = Blueprint("admin_routes", __name__, url_prefix="/Admin")

@admin_routes_bp.route("/")
def index():
    return redirect(url_for("auth_routes_bp.login"))


@admin_routes_bp.route('/api/reservation_predictions')
@login_required
def reservation_predictions():
    """API endpoint to get reservation predictions."""
    try:
        project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../'))
        csv_file_path = os.path.join(project_root, 'customer_reservation.csv')
        
        # Get historical data and train model
        df = get_historical_data(csv_file_path)
        if df.empty:
            raise ValueError("Historical data could not be loaded or is empty.")
        
        model, dates, = train_model(df)
        
        # Get the last 5 days, today, and tomorrow
        end_date = datetime.today()
        start_date = end_date - timedelta(days=6)
        date_range = [start_date + timedelta(days=i) for i in range(7)]
        
        # Convert dates to string format for labels
        labels = [date.strftime('%Y-%m-%d') for date in date_range]
        
        # Fetch actual reservations data for the last 7 days
        actual_reservations = get_reservations()
        actual_data = []
        for date in date_range:
            # Filter reservations for the current date
            daily_reservations = [res for res in actual_reservations if res.reservation_date.strftime('%Y-%m-%d') == date.strftime('%Y-%m-%d')]
            
            # Sum the number of guests for the filtered reservations
            daily_sum = sum(res.number_of_guests for res in daily_reservations)
            
            actual_data.append(daily_sum)
        # print(actual_data)
        
        # Ensure predictions cover the last 7 days, today, and tomorrow
        future_dates = [(end_date + timedelta(days=i)).strftime('%Y-%m-%d') for i in range(1, 3)]  # Tomorrow and the day after
        dates = labels + future_dates
        
        # Get the last date's ordinal for future predictions
        last_date_ordinal = datetime.today().toordinal()
        future_dates_ordinal = [last_date_ordinal + i for i in range(1, 3)]
        
        # Predict future reservations
        future_predictions = model.predict(np.array(future_dates_ordinal).reshape(-1, 1)).tolist()
        
        print(future_predictions)
        
        # Convert predictions and actual_data to native Python types
        actual_data = [int(val) for val in actual_data]  # Convert int64 to int
        combined_predictions = [0] * len(labels) + future_predictions
        combined_predictions = [float(val) for val in combined_predictions]  # Convert np.float64 to float
        
        # Return JSON response
        return jsonify({
            'labels': dates,
            'actual': actual_data + [0] * len(future_dates),  # Zeroes for future days
            'predicted': combined_predictions
        })
    except Exception as e:
        current_app.logger.error('Error in reservation_predictions: %s', e)
        return jsonify({'error': 'An error occurred while fetching predictions'}), 500


@admin_routes_bp.route("/Dashboard")
@login_required
@role_required(1)
def Dashboard():
    """Render the admin dashboard with user statistics and prediction."""
    try:
        stats = count_all_user_stats()
        
        # Render the dashboard template with the required context
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
        if users:
            return render_template("admin/users_list.html", users=users)
        flash("No users found", "warning")
        return render_template("admin/users_list.html", users=[])
    except Exception as e:
        current_app.logger.error('Error occurred in UserList: %s', e)
        flash("An error occurred while fetching user data", "danger")
        return redirect(url_for("admin_routes.Dashboard"))

@admin_routes_bp.route("/Logs/User")
@login_required
@role_required(1)
def UserLogs():
    """Render the user logs page."""
    try:
        logs = get_logs()
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
            user_data = {
                'first_name': request.form.get('first_name'),
                'last_name': request.form.get('last_name'),
                'email': request.form.get('email'),
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
@role_required(1)
def feedback_list():
    """Render the feedback list page."""
    try:
        feedbacks = get_feedbacks()
        if feedbacks:
            return render_template('admin/feedback_list.html', feedbacks=feedbacks)
        flash("No feedbacks found", "warning")
        return render_template('admin/feedback_list.html', feedbacks=[])
    except Exception as e:
        current_app.logger.error('Error occurred in feedback_list: %s', e)
        flash("An error occurred while fetching feedbacks", "danger")
        return redirect(url_for('admin_routes.Dashboard'))

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