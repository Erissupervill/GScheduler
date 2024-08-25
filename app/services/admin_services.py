# app/services/admin_services.py

from app.db import db
from app.models import User
from app import bcrypt
from sqlalchemy.exc import SQLAlchemyError

def count_by_role(role_id):
    """
    Count the number of users by role.
    
    :param role_id: Role ID to count users for
    :return: Count of users with the specified role
    """
    try:
        return User.query.filter_by(role_id=role_id).count()
    except SQLAlchemyError as e:
        db.session.rollback()
        raise RuntimeError('An error occurred while counting users by role.') from e

def count_total_users():
    """
    Count the total number of users.
    
    :return: Total number of users
    """
    try:
        return User.query.count()
    except SQLAlchemyError as e:
        db.session.rollback()
        raise RuntimeError('An error occurred while counting total users.') from e

def create_user(username, email, password_hash, phone_number, role_id):
    """
    Create a new user.
    
    :param username: Username of the new user
    :param email: Email address of the new user
    :param password_hash: Password hash of the new user
    :param phone_number: Phone number of the new user
    :param role_id: Role ID of the new user
    :return: Created user object or None if creation failed
    """
    user = User(
        username=username,
        email_address=email,
        password_hash=password_hash,
        phone_number=phone_number,
        role_id=role_id
    )
    try:
        db.session.add(user)
        db.session.commit()
        return user
    except SQLAlchemyError as e:
        db.session.rollback()
        raise RuntimeError('An error occurred while creating the user.') from e

def load_user(user_id):
    """
    Load a user by ID.
    
    :param user_id: ID of the user to load
    :return: User object if found, else None
    """
    try:
        return User.query.get(user_id)
    except SQLAlchemyError as e:
        db.session.rollback()
        raise RuntimeError('An error occurred while loading the user.') from e

def logs_list():
    """
    Get a list of all user logs.
    
    :return: List of user logs
    """
    # Implement log retrieval logic based on your logging system
    pass

def users_list():
    """
    Get a list of all users.
    
    :return: List of user objects
    """
    try:
        return User.query.all()
    except SQLAlchemyError as e:
        db.session.rollback()
        raise RuntimeError('An error occurred while fetching the users.') from e

def check_email(email):
    """
    Check if an email is already used.
    
    :param email: Email address to check
    :return: True if email exists, else False
    """
    try:
        return User.query.filter_by(email_address=email).first() is not None
    except SQLAlchemyError as e:
        db.session.rollback()
        raise RuntimeError('An error occurred while checking the email.') from e
