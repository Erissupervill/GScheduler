from flask import Blueprint, flash, jsonify, render_template, redirect, request, url_for
from flask_login import current_user, login_required

from app.db import db
from app.models import ReservationStatus
from app.services.reservation_services import count_by_status, get_cancelled_reservation, get_confirmed_reservation, get_guest_reservation, get_pending_reservation, get_rejected_reservation, get_reservations

staff_routes_bp = Blueprint("staff_routes", __name__, url_prefix="/Staff")


@staff_routes_bp.route("/")
def index():
    return redirect(url_for("auth_routes_bp.login"))  # Ensure correct function

# staff
@staff_routes_bp.route("/Dashboard")
@login_required
def Dashboard():
    try:
        confirmed = count_by_status("Confirmed")
        pending = count_by_status("Pending")
        rejected = count_by_status("Rejected")
        cancelled = count_by_status("Cancelled")
        reservations = {
                'confirmed': confirmed,
                'pending': pending,
                'rejected': rejected,
                'cancelled': cancelled
            }
        
        
        return render_template("/staff/dashboard.html",
                            title="Dashboard",
                            reservations = reservations)
    except Exception as e:
        print(f"Error Occurred: {e}")
        return "An error has occurred while fetching user data"


@staff_routes_bp.route("/Reservation")
@login_required
def ReservationAll():
    reservations = get_reservations()
    return render_template("/staff/Reservation.html", reservations=reservations)


@staff_routes_bp.route("/Reservation/Pending")
@login_required
def PendingReservation():
    return render_template("/staff/pending_reservation.html", title="Pending Reservation")

@staff_routes_bp.route('/update/reservation/<int:reservation_id>', methods=['POST'])
@login_required
def update_reservation(reservation_id):
    reservation = get_guest_reservation(reservation_id)

    if request.method == 'POST':
        action = request.form.get('action')

        if action == 'accept':
            reservation.status = ReservationStatus.CONFIRMED
        elif action == 'reject':
            reservation.status = ReservationStatus.REJECTED

        reservation.updated_by = current_user.user_id

        try:
            db.session.commit()
            flash('Reservation updated successfully!', 'success')
        except Exception as e:
            db.session.rollback()
            flash('Error updating reservation. Please try again.', 'error')

    return redirect(url_for('staff_routes.pending_reservations'))

@staff_routes_bp.route("/Reservation/Accepted")
@login_required
def AcceptedReservation():
    reservations = get_confirmed_reservation()
    return render_template("/staff/accepted_reservation.html",reservations=reservations, title="Accepted Reservation")

@staff_routes_bp.route('/pending-reservations')
@login_required
def pending_reservations():
    reservations = get_pending_reservation()
    return render_template('staff/pending_reservation.html', reservations=reservations)

@staff_routes_bp.route("/Reservation/Rejected")
@login_required
def RejectedReservation():
    
    reservations = get_rejected_reservation()
    return render_template("/staff/rejected_reservation.html",reservations=reservations, title="Rejected Reservation")

@staff_routes_bp.route("/Reservation/Cancelled")
@login_required
def CancelledReservation():
    reservations = get_cancelled_reservation()
    return render_template("/staff/cancelled_reservation.html",reservations=reservations, title="Cancelled Reservation")


@staff_routes_bp.route("/Feedbacks")
@login_required
def staffFeedback():
    return render_template("/staff/feedbacks.html", title="Feedbacks")


@staff_routes_bp.route("/Logs/Audit")
@login_required
def AuditLogs():
    return render_template("/staff/audit.html", title="Audit Logs")


@staff_routes_bp.route("/Logs/User")
@login_required
def UserLogs():
    return render_template("/staff/user_logs.html", title="User Logs")
