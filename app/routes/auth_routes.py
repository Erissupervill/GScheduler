from datetime import datetime, timedelta
import random
import string
from flask import Blueprint, app, current_app, render_template, redirect, request, session, url_for, flash
from flask_login import current_user, login_user, logout_user, login_required
from flask_mail import Message
from app import bcrypt, mail
from app.db import db
from app.forms import RegistrationForm, LoginForm
from app.models import User
from app.services.auth_services import authenticate_user

auth_routes_bp = Blueprint('auth_routes', __name__, url_prefix='/')

OTP_EXPIRATION_MINUTES = 5


def base_on_user_role():
    if current_user.role_id == 1:
        return redirect(url_for('admin_routes.Dashboard'))
    elif current_user.role_id == 2:
        return redirect(url_for('staff_routes.dashboard'))
    elif current_user.role_id == 3:
        return redirect(url_for('user_routes.notification'))
    else:
        flash('Current user has no role, kindly contact us.', 'danger')
        return redirect(url_for('auth_routes.login'))

@auth_routes_bp.route('/register', methods=['GET', 'POST'])
def user_register():
    if current_user.is_authenticated:
        return base_on_user_role()

    form = RegistrationForm()
    if form.validate_on_submit():
        first_name = form.first_name.data
        last_name = form.last_name.data
        email = form.email.data
        phone_num = form.phone_number.data
        password = form.password.data
        role_id = 3
        
        if User.query.filter_by(email_address=email).first():
            flash('Email already exists', 'danger')
            return redirect(url_for('auth_routes.user_register'))
        
        hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
        user = User(first_name=first_name, last_name=last_name, email_address=email, password_hash=hashed_password, phone_number=phone_num, role_id=role_id)
        try:
            db.session.add(user)
            db.session.commit()
            flash('User successfully created', 'success')
            return redirect(url_for('auth_routes.login'))
        except Exception as e:
            db.session.rollback()  # Rollback in case of error
            flash('An error occurred while creating the user.', 'danger')
            # print(e)
    else:
        flash(form.errors)
        # print(form.errors)
        
    return render_template('auth/customer_register.html', form=form, title="Register")


@auth_routes_bp.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        email_address = form.email_address.data
        password = form.password.data
        user = authenticate_user(email_address, password, bcrypt)

        if user:
            # Generate OTP
            otp = ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))
            session['otp'] = otp  # Store the OTP in the session
            session['email'] = email_address  # Store the email in the session
            session['otp_expiry'] = (datetime.utcnow() + timedelta(minutes=OTP_EXPIRATION_MINUTES)).isoformat()  # Set OTP expiration

            # Send OTP via email
            msg = Message('Your OTP Code', sender=current_app.config['MAIL_USERNAME'], recipients=[email_address])
            msg.body = f'Your OTP code is: {otp}'
            
            try:
                mail.send(msg)  # Send the email with OTP
                flash('OTP sent to your email. Please check your inbox.', 'info')
            except Exception as e:
                flash('An error occurred while sending the OTP. Please try again later.', 'danger')
                return redirect(url_for('auth_routes.login'))

            # Redirect to OTP verification page
            return redirect(url_for('auth_routes.verify_otp'))

        else:
            flash('Login unsuccessful. Please check username and password', 'danger')
            return redirect(url_for('auth_routes.login'))

    return render_template('auth/login.html', form=form, title="Login")



@auth_routes_bp.route('/verify-otp', methods=['GET', 'POST'])
def verify_otp():
    if request.method == 'POST':
        entered_otp = request.form.get('otp')
        stored_otp = session.get('otp')
        otp_expiry_str = session.get('otp_expiry')  # Retrieve the expiry as a string

        current_app.logger.info(f'Stored OTP: {stored_otp}, OTP Expiry String: {otp_expiry_str}')  # Log for debugging

        if not stored_otp:
            flash('No OTP found. Please request a new one.', 'danger')
            return redirect(url_for('auth_routes.verify_otp'))

        # Check if otp_expiry_str is not None and is a string
        if otp_expiry_str is None:
            flash('OTP expiry time not found. Please request a new OTP.', 'danger')
            return redirect(url_for('auth_routes.verify_otp'))

        # Ensure the value is a string before conversion
        try:
            otp_expiry = datetime.fromisoformat(otp_expiry_str)
        except ValueError as e:
            flash('Invalid OTP expiry format. Please request a new OTP.', 'danger')
            current_app.logger.error(f'Error converting otp_expiry: {e}')
            return redirect(url_for('auth_routes.verify_otp'))

        # Check if OTP has expired
        if datetime.utcnow() > otp_expiry:
            flash('OTP expired. Please request a new OTP.', 'danger')
            return redirect(url_for('auth_routes.verify_otp'))

        # Verify OTP
        if entered_otp == stored_otp:
            user = User.query.filter_by(email_address=session.get('email')).first()
            if user:
                login_user(user)
                session['otp_verified'] = True
                session.pop('otp', None)  # Clear OTP from session
                session.pop('otp_expiry', None)  # Clear OTP expiry from session
                flash('Login Successful', 'success')
                return base_on_user_role()  # Redirect based on user role
            else:
                flash('User not found. Please try again.', 'danger')
                return redirect(url_for('auth_routes.login'))
        else:
            flash('Invalid OTP. Please try again.', 'danger')
            return redirect(url_for('auth_routes.verify_otp'))

    return render_template('auth/verify_otp.html', title="Verify OTP")


@auth_routes_bp.route('/resend-otp', methods=['POST'])
def resend_otp():
    if not session.get('email'):
        flash('Session expired. Please log in again.', 'danger')
        return redirect(url_for('auth_routes.login'))

    # Generate and resend OTP
    otp = ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))
    session['otp'] = otp

    # Store otp_expiry as an ISO formatted string
    session['otp_expiry'] = (datetime.utcnow() + timedelta(minutes=OTP_EXPIRATION_MINUTES)).isoformat()

    # Log OTP for debugging purposes (remove in production)
    current_app.logger.info(f'Generated OTP: {otp}')

    # Send OTP via email
    msg = Message('Your OTP Code', sender=current_app.config['MAIL_USERNAME'], recipients=[session['email']])
    msg.body = f'Your OTP code is: {otp}'

    try:
        mail.send(msg)
        flash('OTP resent. Please check your email.', 'info')
    except Exception as e:
        current_app.logger.error(f'Error sending OTP: {e}')
        flash('An error occurred while resending the OTP. Please try again later.', 'danger')

    return redirect(url_for('auth_routes.verify_otp'))

@auth_routes_bp.route('/logout')
@login_required
def logout():
    logout_user()
    flash('Logged out Successfully', 'info')
    return redirect(url_for('auth_routes.login'))
