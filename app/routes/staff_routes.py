from flask import Blueprint, flash, jsonify, render_template, redirect, request, url_for
from flask_login import current_user, login_required
from app.db import db
from app.models import ReservationStatus, User
from app.services.reservation_services import (
    count_by_status, get_branch, get_cancelled_reservation, 
    get_completed_reservation, get_confirmed_reservation, get_guest_reservation, 
    get_pending_reservation, get_rejected_reservation, 
    get_reservation_by_id, get_reservations, 
    update_reservation_status
)
from app.utils.decorators import role_required

staff_routes_bp = Blueprint("staff_routes", __name__, url_prefix="/Staff")

@staff_routes_bp.route("/")
def index():
    return redirect(url_for("auth_routes_bp.login"))

@staff_routes_bp.route("/Dashboard")
@login_required
def dashboard():
    try:
        # Fetch counts for different reservation statuses
        counts = {
            'confirmed': count_by_status(ReservationStatus.CONFIRMED),
            'pending': count_by_status(ReservationStatus.PENDING),
            'rejected': count_by_status(ReservationStatus.REJECTED),
            'cancelled': count_by_status(ReservationStatus.CANCELLED),
        }
        
        # Fetch all branches and calculate available capacity
        branches = get_branch()
        branch_capacities = {branch.name: branch.available_capacity() for branch in branches}

        return render_template("staff/dashboard.html",
                               title="Dashboard",
                               reservations=counts,
                               branch_capacities=branch_capacities,
                               branches=branches)
    except Exception as e:
        print(f"Error occurred: {e}")
        return "An error has occurred while fetching data"

@staff_routes_bp.route("/Reservation")
@login_required
def reservation_all():
    reservations = get_reservations()
    return render_template("staff/reservation.html", reservations=reservations)


@staff_routes_bp.route('/update/reservation/<int:reservation_id>', methods=['POST'])
@login_required
def update_reservation(reservation_id):
    try:
        reservation = get_reservation_by_id(reservation_id)
        if not reservation:
            flash('Reservation not found', 'error')
            return redirect(url_for('staff_routes.pending_reservations'))

        action = request.form.get('action')
        if not action:
            flash('Action not specified', 'error')
            return redirect(url_for('staff_routes.pending_reservations'))

        if action == 'accept':
            branch = reservation.branch
            current_guests = sum(r.number_of_guests for r in branch.reservations if r.status == ReservationStatus.CONFIRMED)
            if (current_guests + reservation.number_of_guests) > branch.capacity:
                flash('Cannot confirm reservation. Exceeds branch capacity.', 'danger')
                return redirect(url_for('staff_routes.pending_reservations'))

            reservation.status = ReservationStatus.CONFIRMED

        elif action == 'reject':
            return redirect(url_for('staff_routes.reject_reservation_form', reservation_id=reservation_id))

        reservation.updated_by = current_user.user_id
        db.session.commit()
        flash('Reservation updated successfully!', 'success')

    except Exception as e:
        db.session.rollback()
        print(e)
        flash(f'Error updating reservation: {e}', 'error')

    return redirect(url_for('staff_routes.pending_reservations'))


@staff_routes_bp.route('/reject_reservation_form/<int:reservation_id>')
@login_required
def reject_reservation_form(reservation_id):
    reservation = get_reservation_by_id(reservation_id)
    print(reservation)
    if not reservation:
        flash('Reservation not found', 'error')
        return redirect(url_for('staff_routes.pending_reservations'))
    return render_template('staff/reject_reservation.html', reservation=reservation)

@staff_routes_bp.route('/reject_reservation', methods=['POST'])
@login_required
def reject_reservation():
    reservation_id = request.form.get('reservation_id')
    rejection_reason = request.form.get('rejection_reason')

    print(f"Received reservation_id: {reservation_id}")  # Debug statement
    print(f"Received rejection_reason: {rejection_reason}")  # Debug statement

    try:
        reservation_id = int(reservation_id)
    except ValueError:
        flash('Invalid reservation ID', 'error')
        return redirect(url_for('staff_routes.pending_reservations'))

    reservation = get_reservation_by_id(reservation_id)
    if reservation:
        reservation.status = ReservationStatus.REJECTED
        reservation.status_comment = rejection_reason
        reservation.updated_by = current_user.user_id  # Ensure you use the correct field
        db.session.commit()
        flash('Reservation rejected successfully', 'success')
    else:
        flash('Reservation not found', 'error')

    return redirect(url_for('staff_routes.pending_reservations'))



@staff_routes_bp.route('/pending-reservations')
@login_required
def pending_reservations():
    reservations = get_pending_reservation()
    return render_template('staff/pending_reservation.html', reservations=reservations)

@staff_routes_bp.route("/Reservation/Accepted")
@login_required
def accepted_reservation():
    reservations = get_confirmed_reservation()
    return render_template("staff/accepted_reservation.html", reservations=reservations, title="Accepted Reservation")

@staff_routes_bp.route('/complete/reservation/<int:reservation_id>', methods=['POST'])
@login_required
@role_required('Staff')
def complete_reservation(reservation_id):
    try:
        reservation = get_reservation_by_id(reservation_id)
        if reservation:
            reservation.status = ReservationStatus.COMPLETED
            reservation.updated_by = current_user.id
            db.session.commit()
            flash('Reservation status updated to Completed!', 'success')
        else:
            flash('Reservation not found.', 'warning')
    except Exception as e:
        db.session.rollback()
        flash('Error updating reservation status. Please try again.', 'error')

    return redirect(url_for('staff_routes.accepted_reservation'))

@staff_routes_bp.route("/Reservation/Completed")
@login_required
def completed_reservation():
    reservations = get_completed_reservation()
    return render_template("staff/completed_reservation.html", reservations=reservations, title="Completed Reservation")

@staff_routes_bp.route("/Reservation/Rejected")
@login_required
def rejected_reservation():
    reservations = get_rejected_reservation()
    return render_template("staff/rejected_reservation.html", reservations=reservations, title="Rejected Reservation")




@staff_routes_bp.route("/Reservation/Cancelled")
@login_required
def cancelled_reservation():
    reservations = get_cancelled_reservation()
    return render_template("staff/cancelled_reservation.html", reservations=reservations, title="Cancelled Reservation")

@staff_routes_bp.route('/reservation/view/<int:reservation_id>', methods=['GET'])
@login_required
def view_reservation_modal(reservation_id):
    reservation = get_reservation_by_id(reservation_id)
    if reservation:
        return jsonify({
            'customer': {'username': reservation.customer.username},
            'branch': {'location': reservation.branch.location, 'name': reservation.branch.name},
            'reservation_date': reservation.reservation_date.strftime('%Y-%m-%d'),
            'reservation_time': reservation.reservation_time.strftime('%H:%M'),
            'number_of_guests': reservation.number_of_guests,
            'status_comment': reservation.status_comment,
            'status': reservation.status,
            'created_at': reservation.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': reservation.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_by': reservation.updated_by
        })
    else:
        return jsonify({'error': 'Reservation not found'}), 404

@staff_routes_bp.route("/Feedbacks")
@login_required
def staff_feedback():
    return render_template("staff/feedbacks.html", title="Feedbacks")

@staff_routes_bp.route("/Logs/Audit")
@login_required
def audit_logs():
    return render_template("staff/audit.html", title="Audit Logs")

@staff_routes_bp.route("/Logs/User")
@login_required
def user_logs():
    return render_template("staff/user_logs.html", title="User Logs")
