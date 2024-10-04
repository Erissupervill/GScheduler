from datetime import datetime, timedelta
import pandas as pd
from sqlalchemy import func
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
        return db.session.query(CustomerReservation).filter_by(user_id=user_id, status=ReservationStatus.PENDING).all()
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
        
        reservation = reservation = db.session.query(CustomerReservation).filter_by(reservation_id = reservation_id).first()
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

def get_reservation_data_ml():
    """Fetch reservation data from the database."""
    try:
        reservations = db.session.query(
            func.date(CustomerReservation.reservation_date).label('date'),
            func.count(CustomerReservation.id).label('reservation_count')
        ).group_by(func.date(CustomerReservation.reservation_date)).order_by(func.date(CustomerReservation.reservation_date)).all()
        return reservations
    except Exception as e:
        current_app.logger.error(f'Error fetching reservation data: {e}')
        return []

def actual_data_ml():
    """Fetch actual reservation data aggregated by month."""
    try:
        # Define the start and end dates for the query
        end_date = datetime.strptime("2024-06-07", "%Y-%m-%d").date()
        start_date = datetime.strptime("2024-01-31", "%Y-%m-%d").date()

        # Query the database for reservations within the specified date range
        actual_data = (db.session.query(
                func.date_format(CustomerReservation.reservation_date, '%Y-%m').label('month'),
                func.sum(CustomerReservation.number_of_guests).label('total_guests')
            )
            .filter(CustomerReservation.reservation_date.between(start_date, end_date))
            .group_by(func.date_format(CustomerReservation.reservation_date, '%Y-%m'))
            .order_by(func.date_format(CustomerReservation.reservation_date, '%Y-%m'))
            .all())
        
        # Format the data for JSON response
        formatted_data = [{'month': row.month, 'total_guests': row.total_guests} for row in actual_data]
        
        return formatted_data
    except Exception as e:
        current_app.logger.error(f'Error fetching actual reservation data: {e}')
        return []
