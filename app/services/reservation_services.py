from datetime import date, datetime
from sqlalchemy import and_
from app.models import Branch, CustomerReservation, ReservationStatus, User
from app.db import db
from sqlalchemy.orm import joinedload

def get_reservations():
    reservations = CustomerReservation.query.all()
    return reservations

def count_by_status(status):
    return CustomerReservation.query.filter_by(status=status).count()

def get_by_status():
    return CustomerReservation.query.filter_by(status="CANCELLED").all()

def get_completed_reservation():
    return CustomerReservation.query.options(joinedload(CustomerReservation.customer), joinedload(CustomerReservation.updater)).filter_by(status=ReservationStatus.COMPLETED).all()

def get_confirmed_reservation():
    return CustomerReservation.query.filter_by(status=ReservationStatus.CONFIRMED).all()

def get_pending_reservation():
    return CustomerReservation.query.filter_by(status=ReservationStatus.PENDING).all()

def get_rejected_reservation():
    return CustomerReservation.query.filter_by(status=ReservationStatus.REJECTED).all()

def get_cancelled_reservation():
    return CustomerReservation.query.filter_by(status=ReservationStatus.CANCELLED).all()

def take_user_reservations(user_id):
    reservations = CustomerReservation.query.filter(
        and_(
            CustomerReservation.status!=ReservationStatus.CANCELLED,
            CustomerReservation.status!=ReservationStatus.REJECTED,
            CustomerReservation.user_id==user_id
            )).all()
    print(f"Query Result: {reservations}")
    
    return reservations

def get_branch():
    get_branch = Branch.query.all()
    return get_branch

def get_guest_reservation(reservation_id):
    return CustomerReservation.query.get_or_404(reservation_id)

def create_reservation(user_id, branch_id, number_of_guests, reservation_date, reservation_time):
    if isinstance(reservation_date, datetime):
        reservation_date = reservation_date.date()

    if reservation_date < date.today():
        raise ValueError('The reservation date cannot be in the past.')

    branch = Branch.query.get_or_404(branch_id)
    if branch.capacity < number_of_guests:
        raise ValueError('The number of guests exceeds the branch capacity.')

    reservation = CustomerReservation(
        branch_id=branch_id,
        user_id=user_id,
        number_of_guests=number_of_guests,
        status=ReservationStatus.PENDING,
        reservation_date=reservation_date,
        reservation_time=reservation_time
    )

    try:
        db.session.add(reservation)
        branch.capacity -= number_of_guests
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        raise RuntimeError('An error occurred while creating the reservation.') from e

def get_user_reservations(user_id):
    return CustomerReservation.query.filter_by(user_id=user_id).all()

def update_reservation_status(reservation_id, new_status):
    reservation = CustomerReservation.query.get_or_404(reservation_id)
    
    if new_status not in [status for status in ReservationStatus]:
        raise ValueError('Invalid status.')

    reservation.status = new_status
    reservation.updated_at = datetime.utcnow()
    
    try:
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        raise RuntimeError('An error occurred while updating the reservation status.') from e
    
    
def get_reservation_by_id(reservation_id):
    reservation = CustomerReservation.query.get_or_404(reservation_id)
    if reservation:
        reservation.updated_by_user = User.query.get(reservation.updated_by)
        print(reservation.updated_by_user)
    return reservation
