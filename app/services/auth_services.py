# app/services/auth_services.py
from app.models import User
from flask_login import login_user

def load_user(id):
    """Retrieve all user by ID"""
    return User.query.get(int(id))

def authenticate_user(email_address, password, bcrypt):
    """Authenticate user if correct data from database."""
    user = User.query.filter_by(email_address=email_address).first()
    if user and bcrypt.check_password_hash(user.password_hash, password):
        # Update the last login time
        user.update_last_login()
        login_user(user, remember=True)
        return user
    return None
