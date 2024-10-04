from datetime import date, datetime
from flask import Blueprint, current_app, flash, jsonify, render_template, redirect, request, url_for
from flask_login import current_user, login_required
from app.forms import ReservationForm
from app.models import Branch, Notification, ReservationStatus
from app.services.feedback_services import create_feedback
from app.services.notification_services import create_notification, delete_user_notifications, get_user_notifications
from app.services.reservation_services import (
    get_branch,
    get_branch_by_id,
    take_user_reservations,
    create_reservation,
    cancel_reservation
)



from app.db import db
from app.utils.decorators import otp_required

user_routes_bp = Blueprint("user_routes", __name__, url_prefix="/User")

@user_routes_bp.route("/")
def index():
    return redirect(url_for("auth_routes.login"))

# User Notifications
@user_routes_bp.route("/Notification")
@login_required 
@otp_required
def notification():
       # Fetch notifications for the current user
    user_id = current_user.user_id  # or however you identify the logged-in user
    notifications = get_user_notifications(user_id)
    
    return render_template('customer/notification.html', notifications=notifications )

@user_routes_bp.route('/remove_notification/<int:id>', methods=['POST'])
def remove_notification(id):
    try:
        delete_user_notifications(id)
        flash('Notification removed successfully.', 'success')
    except Exception as e:
        flash('Error while removing notification', 'danger')
        current_app.logger.error(f"Error while removing notification with ID={id}: {e}")
    
    return redirect(url_for('user_routes.notification'))

@user_routes_bp.route("/create/reserve", methods=['GET', 'POST'])
@login_required 
@otp_required
def reservation_create():
    form = ReservationForm()

    if request.method == 'POST' and form.validate_on_submit():
        reservation_date = form.reservation_date.data
        reservation_time = form.reservation_time.data
        branch_id = form.branch_id.data
        number_of_guests = int(form.number_of_guests.data)
        user_id = current_user.user_id

        if isinstance(reservation_date, datetime):
            reservation_date = reservation_date.date()

        if reservation_date < date.today():
            flash('The reservation date cannot be in the past.', 'danger')
            return redirect(url_for('user_routes.reservation_create'))

        try:
            branch = get_branch_by_id(branch_id)
            if branch.capacity < number_of_guests:
                flash('The number of guests exceeds the branch capacity.', 'danger')
                return redirect(url_for('user_routes.reservation_create'))

            create_reservation(
                branch_id=branch_id,
                user_id=user_id,
                number_of_guests=number_of_guests,
                status=ReservationStatus.PENDING,
                reservation_date=reservation_date,
                reservation_time=reservation_time
            )
            branch.capacity -= number_of_guests
            db.session.commit()
            flash('Reservation successfully created!', 'success')
            return redirect(url_for('user_routes.reservation_create'))
        except Exception as e:
            current_app.logger.error(f"Error: {e}")
            flash('An error occurred while creating the reservation. Please try again.', 'danger')

    branches = Branch.query.all()
    form.branch_id.choices = [(branch.branch_id, f"{branch.location} {branch.name}") for branch in branches]
    return render_template('customer/reserve_form.html', form=form, branches=branches)


@user_routes_bp.route("/api/branches")
@login_required 
@otp_required
def api_branches():
    branches = Branch.query.all()
    branch_list = [
        {"id": branch.id,"branch_id": branch.branch_id, "name": branch.name, "location": branch.location, "capacity": branch.capacity}
        for branch in branches
    ]
    return jsonify(branch_list)


# Reservation Status
@user_routes_bp.route("/Reservation/Status")
@login_required 
@otp_required
def reservation_status():
    user_id = current_user.user_id
    try:
        reservations = take_user_reservations(user_id)
        return render_template("/customer/reservation_status.html", reservations=reservations)
    except Exception as e:
        current_app.logger.error(f"Error while fetching reservations for user ID={user_id}: {e}")
        flash('An error occurred while fetching your reservations.', 'danger')
        return redirect(url_for('user_routes.index'))

@user_routes_bp.route('/cancel_reservation', methods=['POST'])
@login_required 
@otp_required
def cancel_reservation_route():
    reservation_id = request.form.get('reservation_id')
    cancellation_reason = request.form.get('cancellation_reason')
    try:
        reservation_id = str(reservation_id)
        cancel_reservation(
            reservation_id=reservation_id,
            cancellation_reason=cancellation_reason,
            updated_by=current_user.user_id
        )
        

        create_notification(
            user_id=current_user.user_id,
            reservation_id = reservation_id,
            message=f"Your reservation with ID {reservation_id} has been cancelled. Reason: {cancellation_reason}",
            notification_date=datetime.utcnow().date(),
            notification_time=datetime.utcnow().time()
        )
        flash('Reservation cancelled successfully', 'success')
    except ValueError as ve:
        flash(str(ve), 'error')
        current_app.logger.error(f"Invalid input: {ve}")
    except Exception as e:
        current_app.logger.error(f"Error while canceling reservation ID={reservation_id}: {e}")
        flash('An error occurred while canceling the reservation.', 'danger')

    return redirect(url_for('user_routes.reservation_status'))

# Customer Feedback
@user_routes_bp.route("/Feedbacks")
@login_required 
@otp_required
def customer_feedback():
    return render_template("/customer/feedbacks.html")

# User Logs
@user_routes_bp.route("/Logs")
@login_required 
@otp_required
def user_logs():
    return render_template("/customer/user_logs.html")

@user_routes_bp.route("/WriteFeedbacks", methods=['POST'])
@login_required 
@otp_required
def write_feedbacks():
    rating = request.form.get('rating')
    message = request.form.get('message')

    if not rating or not message:
        flash('All fields are required.', 'danger')
        return redirect(url_for('user_routes.notification'))

    try:
        create_feedback(
            user_id=current_user.user_id,
            rating=int(rating),
            message=message
        )
        flash('Feedback created successfully', 'success')
    except Exception as e:
        current_app.logger.error(f"Error while creating feedback: {e}")
        flash('An error occurred while creating feedback. Please try again.', 'danger')

    return redirect(url_for('user_routes.notification'))
