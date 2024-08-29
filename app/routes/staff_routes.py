from flask import Blueprint, current_app, flash, jsonify, redirect, render_template, request, url_for
from flask_login import current_user, login_required
from app.models import ReservationStatus
from app.services.reservation_services import (
    count_by_status, get_branch, 
    get_reservation_by_id, get_reservations, 
    get_reservations_by_status
)
from app.utils.decorators import role_required
from app.db import db

staff_routes_bp = Blueprint("staff_routes", __name__, url_prefix="/Staff")

@staff_routes_bp.route("/")
@login_required
def index():
    """Redirect to the login page."""
    return redirect(url_for("auth_routes.login"))

@staff_routes_bp.route("/Dashboard")
@login_required
@role_required(2)
def dashboard():
    """Render the dashboard with reservation counts and branch capacities."""
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
        current_app.logger.error(f"Error occurred while fetching dashboard data: {e}")
        flash('An error has occurred while fetching data', 'danger')
        return redirect(url_for('staff_routes.index'))

@staff_routes_bp.route("/Reservation")
@login_required
@role_required(2)
def reservation_all():
    """Render a page with all reservations."""
    try:
        reservations = get_reservations()
        return render_template("staff/reservation.html", reservations=reservations)
    except Exception as e:
        current_app.logger.error(f"Error occurred while fetching all reservations: {e}")
        flash('An error has occurred while fetching reservations', 'danger')
        return redirect(url_for('staff_routes.index'))

@staff_routes_bp.route('/update/reservation/<int:id>', methods=['POST'])
@login_required
@role_required(2)
def update_reservation(id):
    """Update reservation status based on the action provided."""
    try:
        reservation = get_reservation_by_id(id)
        if not reservation:
            flash('Reservation not found', 'danger')
            return redirect(url_for('staff_routes.pending_reservations'))

        action = request.form.get('action')
        if not action:
            flash('Action not specified', 'danger')
            return redirect(url_for('staff_routes.pending_reservations'))

        if action == 'accept':
            branch = reservation.branch
            current_guests = sum(r.number_of_guests for r in branch.reservations if r.status == ReservationStatus.CONFIRMED)
            if (current_guests + reservation.number_of_guests) > branch.capacity:
                flash('Cannot confirm reservation. Exceeds branch capacity.', 'danger')
                return redirect(url_for('staff_routes.pending_reservations'))

            reservation.status = ReservationStatus.CONFIRMED

        elif action == 'reject':
            return redirect(url_for('staff_routes.reject_reservation_form', id=id))

        reservation.updated_by = current_user.user_id
        db.session.commit()
        flash('Reservation updated successfully!', 'success')

    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f'Error updating reservation {id}: {e}')
        flash(f'Error updating reservation: {e}', 'error')

    return redirect(url_for('staff_routes.pending_reservations'))

@staff_routes_bp.route('/reject_reservation_form/<int:id>')
@login_required
@role_required(2)
def reject_reservation_form(id):
    """Render a form for rejecting a reservation."""
    try:
        reservation = get_reservation_by_id(id)
        if not reservation:
            flash('Reservation not found', 'error')
            return redirect(url_for('staff_routes.pending_reservations'))
        return render_template('staff/reject_reservation.html', reservation=reservation)
    except Exception as e:
        current_app.logger.error(f'Error retrieving reservation form for rejection {id}: {e}')
        flash('An error occurred while retrieving the reservation form', 'danger')
        return redirect(url_for('staff_routes.pending_reservations'))

@staff_routes_bp.route('/reject_reservation', methods=['POST'])
@login_required
@role_required(2)
def reject_reservation():
    """Reject a reservation with a provided reason."""
    try:
        id = int(request.form.get('reservation_id'))
        rejection_reason = request.form.get('rejection_reason')
        reservation = get_reservation_by_id(id)
        if reservation:
            reservation.status = ReservationStatus.REJECTED
            reservation.status_comment = rejection_reason
            reservation.updated_by = current_user.user_id
            db.session.commit()
            flash('Reservation rejected successfully', 'success')
        else:
            flash('Reservation not found', 'error')

    except ValueError:
        flash('Invalid reservation ID', 'error')
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f'Error rejecting reservation {id}: {e}')
        flash('Error rejecting reservation', 'error')

    return redirect(url_for('staff_routes.pending_reservations'))

@staff_routes_bp.route('/pending-reservations')
@login_required
@role_required(2)
def pending_reservations():
    """Render a page with all pending reservations."""
    try:
        reservations = get_reservations_by_status(ReservationStatus.PENDING)
        return render_template('staff/pending_reservation.html', reservations=reservations)
    except Exception as e:
        current_app.logger.error(f'Error fetching pending reservations: {e}')
        flash('An error occurred while fetching pending reservations', 'danger')
        return redirect(url_for('staff_routes.index'))

@staff_routes_bp.route("/Reservation/Accepted")
@login_required
@role_required(2)
def accepted_reservation():
    """Render a page with all accepted reservations."""
    try:
        reservations = get_reservations_by_status(ReservationStatus.CONFIRMED)
        return render_template("staff/accepted_reservation.html", reservations=reservations, title="Accepted Reservation")
    except Exception as e:
        current_app.logger.error(f'Error fetching accepted reservations: {e}')
        flash('An error occurred while fetching accepted reservations', 'danger')
        return redirect(url_for('staff_routes.index'))

@staff_routes_bp.route('/complete/reservation/<int:id>', methods=['POST'])
@login_required
@role_required(2)
def complete_reservation(id):
    """Mark a reservation as completed."""
    try:
        reservation = get_reservation_by_id(id)
        if reservation:
            reservation.status = ReservationStatus.COMPLETED
            reservation.updated_by = current_user.user_id
            db.session.commit()
            flash('Reservation status updated to Completed!', 'success')
        else:
            flash('Reservation not found.', 'danger')
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f'Error completing reservation {id}: {e}', exc_info=True)
        flash('Error updating reservation status. Please try again.', 'danger')

    return redirect(url_for('staff_routes.accepted_reservation'))

@staff_routes_bp.route("/Reservation/Completed")
@login_required
@role_required(2)
def completed_reservation():
    """Render a page with all completed reservations."""
    try:
        reservations = get_reservations_by_status(ReservationStatus.COMPLETED)
        return render_template("staff/completed_reservation.html", reservations=reservations, title="Completed Reservation")
    except Exception as e:
        current_app.logger.error(f'Error fetching completed reservations: {e}')
        flash('An error occurred while fetching completed reservations', 'danger')
        return redirect(url_for('staff_routes.index'))

@staff_routes_bp.route("/Reservation/Rejected")
@login_required
@role_required(2)
def rejected_reservation():
    """Render a page with all rejected reservations."""
    try:
        reservations = get_reservations_by_status(ReservationStatus.REJECTED)
        return render_template("staff/rejected_reservation.html", reservations=reservations, title="Rejected Reservation")
    except Exception as e:
        current_app.logger.error(f'Error fetching rejected reservations: {e}')
        flash('An error occurred while fetching rejected reservations', 'danger')
        return redirect(url_for('staff_routes.index'))

@staff_routes_bp.route("/Reservation/Cancelled")
@login_required
@role_required(2)
def cancelled_reservation():
    """Render a page with all cancelled reservations."""
    try:
        reservations = get_reservations_by_status(ReservationStatus.CANCELLED)
        return render_template("staff/cancelled_reservation.html", reservations=reservations, title="Cancelled Reservation")
    except Exception as e:
        current_app.logger.error(f'Error fetching cancelled reservations: {e}')
        flash('An error occurred while fetching cancelled reservations', 'danger')
        return redirect(url_for('staff_routes.index'))

@staff_routes_bp.route('/reservation/view/<int:reservation_id>', methods=['GET'])
@login_required
def view_reservation_modal(reservation_id):
    """Return reservation details as JSON for modal view."""
    try:
        reservation = get_reservation_by_id(reservation_id)
        if reservation:
            return jsonify({
                'customer': {'username': reservation.customer.username},
                'branch': {'location': reservation.branch.location, 'name': reservation.branch.name},
                'reservation_date': reservation.reservation_date.strftime('%Y-%m-%d'),
                'reservation_time': reservation.reservation_time.strftime('%H:%M'),
                'number_of_guests': reservation.number_of_guests,
                'status': reservation.status.value,
                'status_comment': reservation.status_comment
            })
        else:
            flash('Reservation not found', 'error')
            return jsonify({'error': 'Reservation not found'}), 404
    except Exception as e:
        current_app.logger.error(f'Error fetching reservation details for modal view {reservation_id}: {e}')
        flash('An error occurred while fetching reservation details', 'danger')
        return jsonify({'error': 'An error occurred'}), 500
