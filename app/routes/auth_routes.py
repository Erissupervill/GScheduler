# app/routes.py
from flask import Blueprint, render_template, redirect, url_for, flash
from flask_login import current_user, logout_user
from app import db, bcrypt
from app.forms import RegistrationForm, LoginForm
from app.models import User
from app.services.auth_services import authenticate_user

auth_routes_bp = Blueprint('auth_routes', __name__, url_prefix='/')

def base_on_user_role():
    if current_user.role_id == 1:
        return redirect(url_for('admin_routes.Dashboard'))
    elif current_user.role_id == 2:
        return redirect(url_for('staff_routes.Dashboard'))
    elif current_user.role_id == 3:
        return redirect(url_for('user_routes.Dashboard'))
    else:
        flash('Current user has no role, kindly contact us.', 'danger')
        return redirect(url_for('auth_routes.login'))

@auth_routes_bp.route('/register', methods=['GET', 'POST'])
def user_register():
    if current_user.is_authenticated:
        return base_on_user_role()

    form = RegistrationForm()
    if form.validate_on_submit():
        username = form.username.data
        email = form.email.data
        phone_num = form.phone_number.data
        password = form.password.data
        role_id = 3
        
        if User.query.filter_by(email_address=email).first():
            flash('Email already exists', 'danger')
            return redirect(url_for('auth_routes.user_register'))
        
        hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
        user = User(username=username, email_address=email, password_hash=hashed_password, phone_number=phone_num, role_id=role_id)
        try:
            db.session.add(user)
            db.session.commit()
            flash('User successfully created', 'success')
            return redirect(url_for('auth_routes.login'))
        except Exception as e:
            db.session.rollback()  # Rollback in case of error
            flash('An error occurred while creating the user.', 'danger')
            print(e)
    else:
        print(form.errors)
        
    return render_template('auth/customer_register.html', form=form, title="Register")

@auth_routes_bp.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return base_on_user_role()

    form = LoginForm()
    if form.validate_on_submit():
        username = form.username.data
        password = form.password.data
        user = authenticate_user(username, password, bcrypt)
        if user:
            flash('Login Successful', 'success')
            return base_on_user_role()
        else:
            flash('Login unsuccessful. Please check username and password', 'danger')
            return redirect(url_for('auth_routes.login'))
            
    return render_template('auth/login.html', form=form, title="Login")

@auth_routes_bp.route('/logout')
def logout():
    logout_user()
    flash('Logged out Successfully', 'info')
    return redirect(url_for('auth_routes.login'))
