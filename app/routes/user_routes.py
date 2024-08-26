from datetime import date, datetime
from flask import Blueprint, flash, render_template, redirect, request, url_for
from flask_login import current_user, login_required
from app.db import db
from app.forms import ReservationForm
from app.models import Branch, CustomerReservation, ReservationStatus  # Updated model imports
from app.services.feedback_services import create_feedback
from app.services.reservation_services import get_reservation_by_id, get_reservations, get_user_reservations, take_user_reservations

user_routes_bp = Blueprint("user_routes", __name__, url_prefix="/User")

@user_routes_bp.route("/")
def index():
    return redirect(url_for("auth_routes_bp.login"))

# User Notifications
@user_routes_bp.route("/Notification")
@login_required
def notification():
    return render_template("/customer/notification.html")

@user_routes_bp.route("/create/reserve", methods=['GET', 'POST'])
@login_required
def reservation_create():
    form = ReservationForm()

    if request.method == 'POST' and form.validate_on_submit():
        reservation_date = form.reservation_date.data
        reservation_time = form.reservation_time.data
        branch_id = form.branch_id.data
        number_of_guests = int(form.number_of_guests.data)
        user_id = current_user.user_id  # Get the current logged-in user's ID

        # Convert reservation_date to a date object if it's a datetime object
        if isinstance(reservation_date, datetime):
            reservation_date = reservation_date.date()

        # Check if reservation date is in the past
        if reservation_date < date.today():
            flash('The reservation date cannot be in the past.', 'danger')
            return redirect(url_for('user_routes.reservation_create'))

        # Create a new reservation
        reservation = CustomerReservation(
            branch_id=branch_id,
            user_id=user_id,  # Assign the current user's ID
            number_of_guests=number_of_guests,
            status=ReservationStatus.PENDING,
            reservation_date=reservation_date,
            reservation_time=reservation_time
        )

        try:
            # Check availability before adding
            branch = Branch.query.get_or_404(branch_id)
            if branch.capacity < number_of_guests:
                flash('The number of guests exceeds the branch capacity.', 'danger')
                return redirect(url_for('user_routes.reservation_create'))

            # Add reservation to the database
            db.session.add(reservation)
            branch.capacity -= number_of_guests  # Reduce capacity
            db.session.commit()
            flash('Reservation successfully created!', 'success')
            return redirect(url_for('user_routes.reservation_create'))
        except Exception as e:
            db.session.rollback()
            flash('An error occurred while creating the reservation. Please try again.', 'danger')
            print(f"Error: {e}")

    # Populate the SelectField with available branches
    branches = Branch.query.all()
    form.branch_id.choices = [(branch.branch_id, f"{branch.name} (location: {branch.location})") for branch in branches]
    return render_template('customer/reserve_form.html', form=form, branches=branches)

# Reservation Status
@user_routes_bp.route("/Reservation/Status")
@login_required
def reservation_status():
    user_id = current_user.user_id
    reservations = take_user_reservations(user_id)
    print(reservations)
    return render_template("/customer/reservation_status.html", reservations=reservations)

@user_routes_bp.route('/cancel_reservation', methods=['POST'])
@login_required
def cancel_reservation():
    reservation_id = request.form.get('reservation_id')
    cancellation_reason = request.form.get('cancellation_reason')

    print(f"Received reservation_id: {reservation_id}")  # Debug statement
    print(f"Received cancellation_reason: {cancellation_reason}")  # Debug statement

    try:
        reservation_id = int(reservation_id)
    except ValueError:
        flash('Invalid reservation ID', 'error')
        return redirect(url_for('user_routes.reservation_status'))

    reservation = get_reservation_by_id(reservation_id)
    if reservation:
        reservation.status = ReservationStatus.CANCELLED.value
        reservation.status_comment = cancellation_reason
        reservation.updated_by = current_user.user_id
        db.session.commit()
        flash('Reservation cancelled successfully', 'success')
    else:
        flash('Reservation not found', 'error')

    return redirect(url_for('user_routes.reservation_status'))


# Customer Feedback
@user_routes_bp.route("/Feedbacks")
@login_required
def customer_feedback():
    return render_template("/customer/feedbacks.html")


# User Logs
@user_routes_bp.route("/Logs")
@login_required
def user_logs():
    return render_template("/customer/user_logs.html")

@user_routes_bp.route("/WriteFeedbacks", methods=['POST'])
@login_required
def write_feedbacks():
    rating = request.form.get('rating')
    message = request.form.get('message')
    
    print(rating)
    print(message)

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
        flash('An error occurred while creating feedback. Please try again.', 'danger')
        print(f"Error: {e}")

    return redirect(url_for('user_routes.notification'))
