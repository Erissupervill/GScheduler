from datetime import datetime
from app.db import db
from enum import Enum

class ReservationStatus(Enum):
    PENDING = 'Pending'
    CONFIRMED = 'Confirmed'
    COMPLETED = 'Completed'
    CANCELLED = 'Cancelled'
    REJECTED = 'Rejected'

class OTPStatus(Enum):
    GENERATED = 'Generated'
    SENT = 'Sent'
    VERIFIED = 'Verified'
    FAILED = 'Failed'

class Branch(db.Model):
    __tablename__ = 'branch'
    branch_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)
    location = db.Column(db.String(100), nullable=False)
    capacity = db.Column(db.Integer, nullable=False)
    reservations = db.relationship('CustomerReservation', back_populates='branch')


class CustomerReservation(db.Model):
    __tablename__ = 'customer_reservation'
    
    reservation_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('usertable.user_id'), nullable=False)
    branch_id = db.Column(db.Integer, db.ForeignKey('branch.branch_id'), nullable=False)
    status_comment = db.Column(db.String)
    number_of_guests = db.Column(db.Integer, nullable=False)  # Updated field name
    status = db.Column(db.Enum('Pending','Confirmed','Completed','Cancelled','Rejected'), nullable=False, default=ReservationStatus.PENDING)
    reservation_date = db.Column(db.Date, nullable=False)  # Updated field name
    reservation_time = db.Column(db.Time, nullable=False)  # Updated field name
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    branch = db.relationship('Branch', back_populates='reservations')
    customer = db.relationship('User', back_populates='reservations')


class UserRole(db.Model):
    __tablename__ = 'userrole'
    role_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    role_name = db.Column(db.Enum('Admin', 'Staff', 'User'), nullable=False, unique=True)

    # Relationships
    users = db.relationship('User', back_populates='role')

class User(db.Model):
    __tablename__ = 'usertable'
    user_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    first_name = db.Column(db.String(50),)
    last_name = db.Column(db.String(50),)
    username = db.Column(db.String(50), nullable=False, unique=True)
    password_hash = db.Column(db.String(255), nullable=False)
    email_address = db.Column(db.String(155), nullable=False, unique=True)
    phone_number = db.Column(db.String(155), nullable=False)
    role_id = db.Column(db.Integer, db.ForeignKey('userrole.role_id'), nullable=False)
    last_login = db.Column(db.DateTime)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    role = db.relationship('UserRole', back_populates='users')
    reservations = db.relationship('CustomerReservation', back_populates='customer')
    logs = db.relationship('Log', back_populates='user')
    otplogs = db.relationship('OTPLog', back_populates='user')
    
    def update_last_login(self):
        self.last_login = datetime.utcnow()
        db.session.commit()
    
    def update_last_login(self):
        self.last_login = datetime.utcnow()
        db.session.commit()
    
    # Required methods for Flask-Login
    def is_active(self):
        # Return True if the user is active
        return True
    
    def is_authenticated(self):
        # Return True if the user is authenticated
        return True
    
    def is_anonymous(self):
        # Return True if the user is anonymous
        return False
    
    def get_id(self):
        # Return the user ID
        return str(self.user_id)

class Log(db.Model):
    __tablename__ = 'logs'
    log_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    action = db.Column(db.String(50), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('usertable.user_id'), nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
    description = db.Column(db.Text)
    user = db.relationship('User', back_populates='logs')

class OTPLog(db.Model):
    __tablename__ = 'otplogs'
    otp_log_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('usertable.user_id'), nullable=False)
    otp_code = db.Column(db.String(10), nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
    status = db.Column(db.Enum(OTPStatus), default=OTPStatus.GENERATED)
    description = db.Column(db.Text)
    user = db.relationship('User', back_populates='otplogs')
