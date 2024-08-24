from flask import Blueprint, flash, render_template, redirect, request, url_for
from flask_login import current_user, login_required

from app import db
from app.forms import ReservationForm
from app.models import Reservation, RestaurantTable
from app.services.reservation_services import get_reservations

user_routes_bp = Blueprint("user_routes", __name__, url_prefix="/User")


@user_routes_bp.route("/")
def index():
    return redirect(url_for("auth_routes_bp.login"))  # Ensure correct function


# user
@user_routes_bp.route("/Dashboard")
@login_required
def Dashboard():
    return render_template("/customer/dashboard.html")

@user_routes_bp.route("/create/reserve", methods=['GET', 'POST'])
@login_required
def ReservationCreate():
    form = ReservationForm()
    print(form.table_id)
    if request.method == 'POST' and form.validate_on_submit():
        reservation_date_time = form.reservation_date_time.data
        table_id = form.table_id.data

        # Create a new reservation
        reservation = Reservation(
            customer_id=current_user.user_id,
            reservation_date_time=reservation_date_time,
            table_id=table_id,
            status='Pending'
        )
        print(reservation)

        try:
            db.session.add(reservation)
            db.session.commit()
            flash('Reservation successfully created!', 'success')
            return redirect(url_for('user_routes_bp.ReservationCreate'))
        except Exception as e:
            db.session.rollback()
            flash('Error creating reservation. Please try again.', 'error')

    # Populate the SelectField with available tables
    tables = RestaurantTable.query.filter_by(availability_status='Available').all()
    form.table_id.choices = [(table.table_id, f"{table.location} (Capacity: {table.capacity})") for table in tables]

    return render_template('Customer/reserve_form.html', form=form, tables=tables)





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
