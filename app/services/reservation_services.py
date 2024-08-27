from app.db import db
from app.models import Branch, CustomerReservation, ReservationStatus
from flask import current_app

def get_branch():
    """Retrieve a branch by its ID."""
    try:
        return db.session.query(Branch).all()
    except Exception as e:
        current_app.logger.error(f"Error while retrieving branch with ID=: {e}")
        raise
    
def get_branch_by_id(id):
    """Retrieve a reservation by its ID."""
    try:
        return db.session.query(Branch).get(id)
    except Exception as e:
        current_app.logger.error(f"Error while retrieving reservation with ID={id}: {e}")
        raise

def get_reservation_by_id(id):
    """Retrieve a reservation by its ID."""
    try:
        reservation = db.session.query(CustomerReservation).filter_by(id = id).first()
        if reservation is None:
            print(reservation)
            print(f"Error while retrieving reservation with ID={id}:")
            current_app.logger.error(f"Error while retrieving reservation with ID={id}:")
        return reservation
    except Exception as e:
        current_app.logger.error(f"Error while retrieving reservation with ID={id}: {e}")
        raise

def get_reservations():
    """Retrieve all reservations."""
    try:
        return db.session.query(CustomerReservation).all()
    except Exception as e:
        current_app.logger.error(f"Error while retrieving all reservations: {e}")
        raise

def get_user_reservations(user_id):
    """Retrieve reservations for a specific user."""
    try:
        return db.session.query(CustomerReservation).filter_by(user_id=user_id).all()
    except Exception as e:
        current_app.logger.error(f"Error while retrieving reservations for user ID={user_id}: {e}")
        raise

def take_user_reservations(user_id):
    """Retrieve and filter reservations for a specific user."""
    try:
        return db.session.query(CustomerReservation).filter_by(user_id=user_id).all()
    except Exception as e:
        current_app.logger.error(f"Error while taking reservations for user ID={user_id}: {e}")
        raise

def count_by_status(status):
    """Count the number of reservations by status."""
    try:
        count = db.session.query(CustomerReservation).filter_by(status=status).count()
        return count
    except Exception as e:
        current_app.logger.error(f"Error while counting reservations with status={status}: {e}")
        raise

def get_reservations_by_status(status):
    """Retrieve reservations by status."""
    try:
        return db.session.query(CustomerReservation).filter_by(status=status).all()
    except Exception as e:
        current_app.logger.error(f"Error while retrieving reservations with status={status}: {e}")
        raise

def create_reservation(branch_id, user_id, number_of_guests, status, reservation_date, reservation_time):
    """Create a new reservation."""
    try:
        reservation = CustomerReservation(
            branch_id=branch_id,
            user_id=user_id,
            number_of_guests=number_of_guests,
            status=status,
            reservation_date=reservation_date,
            reservation_time=reservation_time
        )
        db.session.add(reservation)
        db.session.commit()
        return reservation
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error while creating reservation: {e}")
        raise

def cancel_reservation(reservation_id, cancellation_reason, updated_by):
    """Cancel a reservation by its ID."""
    try:
        
        reservation = get_reservation_by_id(reservation_id)
        print(reservation, "TWES")
        if reservation:
            reservation.status = ReservationStatus.CANCELLED
            reservation.status_comment = cancellation_reason
            reservation.updated_by = updated_by
            db.session.commit()
        else:
            raise ValueError("Reservation not found")
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error while canceling reservation with ID={reservation_id}: {e}")
        raise
