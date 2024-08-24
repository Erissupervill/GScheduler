import datetime
from app import db
from app.models import Reservation  # Import your Reservation model

from sqlalchemy.orm import joinedload

def get_reservations():
    reservation = Reservation.query.options(joinedload(Reservation.customer)).all()
    return reservation

        

    
