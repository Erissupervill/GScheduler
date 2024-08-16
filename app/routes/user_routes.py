from flask import Blueprint, render_template, redirect, url_for
from flask_login import login_required

user_routes_bp = Blueprint("user_routes", __name__, url_prefix="/User")


@user_routes_bp.route("/")
def index():
    return redirect(url_for("auth_routes_bp.login"))  # Ensure correct function


# user
@user_routes_bp.route("/Dashboard")
@login_required
def Dashboard():
    return render_template("/customer/dashboard.html")


@user_routes_bp.route("/Reservation")
@login_required
def Reservation():
    return render_template("/customer/Reservation.html")


@user_routes_bp.route("/Reservation/Status")
@login_required
def ReservationStatus():
    return render_template("/Customer/reservation_status.html")


@user_routes_bp.route("/Feedbacks")
@login_required
def CustomerFeedback():
    return render_template("/customer/feedbacks.html")


@user_routes_bp.route("/WriteFeedbacks")
@login_required
def WriteFeedbacks():
    return render_template("/customer/write_feedbacks.html")


@user_routes_bp.route("/Logs")
@login_required
def UserLogs():
    return render_template("/customer/user_logs.html")
