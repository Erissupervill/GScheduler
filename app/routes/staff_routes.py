from flask import Blueprint, render_template, redirect, url_for
from flask_login import login_required

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
def Reservation():
    return render_template("/staff/reservation.html",title="Reservation")


@staff_routes_bp.route("/Reservation/Pending")
@login_required
def PendingReservation():
    return render_template("/staff/pending_reservation.html", title="Pending Reservation")


@staff_routes_bp.route("/Reservation/Accepted")
@login_required
def AcceptedReservation():
    return render_template("/staff/accepted_reservation.html", title="Accepted Reservation")


@staff_routes_bp.route("/Reservation/Cancelled")
@login_required
def CancelledReservation():
    return render_template("/staff/cancelled_reservation.html", title="Cancelled Reservation")


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
