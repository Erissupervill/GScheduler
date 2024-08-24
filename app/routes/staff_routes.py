from flask import Blueprint, flash, render_template, redirect, request, url_for
from flask_login import current_user, login_required

from app import db
from app.models import Reservation
from app.services.reservation_services import get_reservations

staff_routes_bp = Blueprint("staff_routes", __name__, url_prefix="/Staff")


@staff_routes_bp.route("/")
def index():
    return redirect(url_for("auth_routes_bp.login"))  # Ensure correct function

# staff
@staff_routes_bp.route("/Dashboard")
@login_required
def Dashboard():
    return render_template("/staff/dashboard.html",title="Dashboard")


@staff_routes_bp.route("/Reservation")
@login_required
def ReservationRoute():
    reservations = get_reservations()
    return render_template("/staff/Reservation.html", reservations=reservations)


@staff_routes_bp.route("/Reservation/Pending")
@login_required
def PendingReservation():
    return render_template("/staff/pending_reservation.html", title="Pending Reservation")

@staff_routes_bp.route('/update/reservation/<int:reservation_id>', methods=['POST'])
@login_required
def update_reservation(reservation_id):
    reservation = Reservation.query.get_or_404(reservation_id)

    if request.method == 'POST':
        action = request.form.get('action')

        if action == 'accept':
            reservation.status = 'Confirmed'
        elif action == 'reject':
            reservation.status = 'Rejected'

        reservation.updated_by = current_user.user_id

        try:
            db.session.commit()
            flash('Reservation updated successfully!', 'success')
        except Exception as e:
            db.session.rollback()
            flash('Error updating reservation. Please try again.', 'error')

    return redirect(url_for('staff_routes.pending_reservations'))


@staff_routes_bp.route('/pending-reservations')
@login_required
def pending_reservations():
    reservations = Reservation.query.filter_by(status='Pending').all()
    return render_template('staff/pending_reservation.html', reservations=reservations)


@staff_routes_bp.route("/Reservation/Accepted")
@login_required
def AcceptedReservation():
    reservations = Reservation.query.filter_by(status='Confirmed').all()
    return render_template("/staff/accepted_reservation.html",reservations=reservations, title="Accepted Reservation")


@staff_routes_bp.route("/Reservation/Cancelled")
@login_required
def CancelledReservation():
    reservations = Reservation.query.filter_by(status='Rejected').all()
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
