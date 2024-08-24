from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()

class Branch(db.Model):
    __tablename__ = 'branch'
    branch_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    branch_name = db.Column(db.String(100), nullable=False)
    capacity = db.Column(db.Integer, nullable=False)

    # Relationships
    reservations = db.relationship('GuestReservation', back_populates='branch')

class GuestReservation(db.Model):
    __tablename__ = 'guest_reservation'
    reservation_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    branch_id = db.Column(db.Integer, db.ForeignKey('branch.branch_id'), nullable=False)
    guest_count = db.Column(db.Integer, nullable=False)
    status = db.Column(db.Enum('Pending', 'Confirmed', 'Completed', 'Cancelled'), nullable=False, default='Pending')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    branch = db.relationship('Branch', back_populates='reservations')

class UserRole(db.Model):
    __tablename__ = 'userrole'
    role_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    role_name = db.Column(db.Enum('Admin', 'Staff', 'Customer'), nullable=False, unique=True)

    # Relationships
    users = db.relationship('User', back_populates='role')

class User(db.Model):
    __tablename__ = 'usertable'
    user_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    first_name = db.Column(db.String(50), nullable=False)
    last_name = db.Column(db.String(50), nullable=False)
    username = db.Column(db.String(50), nullable=False, unique=True)
    password_hash = db.Column(db.String(255), nullable=False)
    email_address = db.Column(db.String(155), nullable=False, unique=True)
    phone_number = db.Column(db.String(155), nullable=False)
    role_id = db.Column(db.Integer, db.ForeignKey('userrole.role_id'), nullable=False)
    last_login = db.Column(db.DateTime)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    role = db.relationship('UserRole', back_populates='users')

class Log(db.Model):
    __tablename__ = 'logs'
    log_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    action = db.Column(db.String(50), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('usertable.user_id'), nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
    description = db.Column(db.Text)

    # Relationships
    user = db.relationship('User', back_populates='logs')

class OTPLog(db.Model):
    __tablename__ = 'otplogs'
    otp_log_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('usertable.user_id'), nullable=False)
    otp_code = db.Column(db.String(10), nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
    status = db.Column(db.Enum('Generated', 'Sent', 'Verified', 'Failed'), default='Generated')
    description = db.Column(db.Text)

    # Relationships
    user = db.relationship('User', back_populates='otplogs')

User.logs = db.relationship('Log', back_populates='user')
User.otplogs = db.relationship('OTPLog', back_populates='user')
