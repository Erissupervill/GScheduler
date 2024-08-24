import datetime
from app import db
from app.models import Reservation  # Import your Reservation model

from sqlalchemy.orm import joinedload

def get_reservations():
    reservation = Reservation.query.options(joinedload(Reservation.customer)).all()
    return reservation

def count_by_status(status):
    status = Reservation.query.filter_by(status=status).count()
    return status


def get_confirmed_reservation():
    reservation = Reservation.query.filter_by(status='Confirmed').all()
    return reservation

def get_pending_reservation():
    reservation = Reservation.query.filter_by(status='Pending').all()
    return reservation

def get_rejected_reservation():
    reservation = Reservation.query.filter_by(status='Rejected').all()
    return reservation


def get_cancelled_reservation():
    reservation = Reservation.query.filter_by(status='Cancelled').all()
    return reservation
    
