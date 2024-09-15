# app/utils/decorators.py

from functools import wraps
from flask import redirect, url_for, flash
from flask_login import current_user

def role_required(required_role):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if not current_user.is_authenticated:
                flash('Please log in to access this page.', 'warning')
                return redirect(url_for('auth_routes.login'))
            if current_user.role_id != required_role:
                flash('You do not have permission to access this page.', 'danger')
                return redirect(url_for('auth_routes.login'))
            return f(*args, **kwargs)
        return decorated_function
    return decorator

def otp_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not session.get('otp_verified', False):
            flash('Please verify your OTP first.', 'danger')
            return redirect(url_for('auth_routes.verify_otp'))
        return f(*args, **kwargs)
    return decorated_function
