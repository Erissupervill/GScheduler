from datetime import datetime, timedelta
from flask import current_app
from sqlalchemy import func, extract
from app.db import db
from app.models import CustomerReservation, User, Feedback
from app import bcrypt

def update_user(user_id, data):
    """Update user details based on provided data."""
    user = User.query.get(user_id)
    if not user:
        raise ValueError("User not found")
    
    if 'first_name' in data and data['first_name']:
        user.first_name = data['first_name']
    if 'last_name' in data and data['last_name']:
        user.last_name = data['last_name']
    if 'username' in data and data['username']:
        user.username = data['username']
    if 'email_address' in data and data['email_address']:
        user.email_address = data['email_address']
    if 'phone_number' in data and data['phone_number']:
        user.phone_number = data['phone_number']
    if 'password' in data and data['password']:
        if not data['password'].strip():  # Ensure password is not just whitespace
            raise ValueError("Password must be non-empty.")
        user.password_hash = bcrypt.generate_password_hash(data['password']).decode('utf-8')
    
    db.session.commit()
    return user



def delete_user(user_id):
    """Delete a user by ID."""
    user = User.query.get(user_id)
    if not user:
        raise ValueError("User not found")
    
    db.session.delete(user)
    db.session.commit()

def create_new_user(data):
    """Create a new user."""
    if check_email(data['email']):
        raise ValueError("Email already exists")

    hashed_password = bcrypt.generate_password_hash(data['password']).decode('utf-8')
    user = User(
        username=data['username'],
        email_address=data['email'],
        phone_number=data['phone_number'],
        password_hash=hashed_password,
        role_id=data['role_id']
    )
    db.session.add(user)
    db.session.commit()
    return user



def delete_feedback(feedback_id):
    """Delete feedback by ID."""
    feedback = Feedback.query.get(feedback_id)
    if not feedback:
        raise ValueError("Feedback not found")
    
    db.session.delete(feedback)
    db.session.commit()

def check_email(email):
    """Check if the email already exists in the database."""
    return User.query.filter_by(email_address=email).first() is not None

def count_by_role(role_id):
    """Count the number of users by role."""
    try:
        return User.query.filter_by(role_id=role_id).count()
    except Exception as e:
        current_app.logger.error('An error occurred while counting users by role: %s', e)
        db.session.rollback()
        raise RuntimeError('An error occurred while counting users by role.') from e
    
def count_total_users():
    """Count the total number of users."""
    try:
        return User.query.count()
    except Exception as e:
        current_app.logger.error('An error occurred while counting total users: %s', e)
        db.session.rollback()
        raise RuntimeError('An error occurred while counting total users.') from e

def fetch_all_users():
    """Retrieve all users."""
    return User.query.all()

def get_booking_summaries():
    today = datetime.now().date()
    week_start = today - timedelta(days=today.weekday())
    month_start = today.replace(day=1)
    
    daily_summary = db.session.query(
        func.date(CustomerReservation.reservation_date).label('date'),
        func.count(CustomerReservation.id).label('total_bookings'),
        func.avg(CustomerReservation.number_of_guests).label('avg_group_size'),
        func.sum(CustomerReservation.status == 'Cancelled').label('total_cancellations')  # Adjusted
    ).group_by(func.date(CustomerReservation.reservation_date)).all()

    weekly_summary = db.session.query(
        extract('week', CustomerReservation.reservation_date).label('week'),
        func.year(CustomerReservation.reservation_date).label('year'),
        func.count(CustomerReservation.id).label('total_bookings'),
        func.avg(CustomerReservation.number_of_guests).label('avg_group_size'),
        func.sum(CustomerReservation.status == 'Cancelled').label('total_cancellations')  # Adjusted
    ).filter(CustomerReservation.reservation_date >= week_start).group_by(extract('week', CustomerReservation.reservation_date), func.year(CustomerReservation.reservation_date)).all()

    monthly_summary = db.session.query(
        extract('month', CustomerReservation.reservation_date).label('month'),
        func.year(CustomerReservation.reservation_date).label('year'),
        func.count(CustomerReservation.id).label('total_bookings'),
        func.avg(CustomerReservation.number_of_guests).label('avg_group_size'),
        func.sum(CustomerReservation.status == 'Cancelled').label('total_cancellations')  # Adjusted
    ).filter(CustomerReservation.reservation_date >= month_start).group_by(extract('month', CustomerReservation.reservation_date), func.year(CustomerReservation.reservation_date)).all()

    return {
        'daily': daily_summary,
        'weekly': weekly_summary,
        'monthly': monthly_summary
    }