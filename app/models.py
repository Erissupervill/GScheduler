from datetime import datetime
from sqlalchemy import Date, DateTime, ForeignKey, Integer, String, Text, Time
from sqlalchemy.orm import relationship
from app.db import db

class ReservationStatus:
    PENDING = 'Pending'
    CONFIRMED = 'Confirmed'
    COMPLETED = 'Completed'
    CANCELLED = 'Cancelled'
    REJECTED = 'Rejected'

class OTPStatus:
    GENERATED = 'Generated'
    SENT = 'Sent'
    VERIFIED = 'Verified'
    FAILED = 'Failed'

class Branch(db.Model):
    __tablename__ = 'branch'
    branch_id = db.Column(Integer, primary_key=True, autoincrement=True)
    name = db.Column(String(100), nullable=False)
    location = db.Column(String(100), nullable=False)
    capacity = db.Column(Integer, nullable=False)
    reservations = relationship('CustomerReservation', back_populates='branch')
    
    def available_capacity(self):
        # Calculate the total number of guests for confirmed reservations
        confirmed_guests = sum(r.number_of_guests for r in self.reservations if r.status == ReservationStatus.CONFIRMED)
        return self.capacity - confirmed_guests

class CustomerReservation(db.Model):
    __tablename__ = 'customer_reservation'
    
    reservation_id = db.Column(Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(Integer, ForeignKey('usertable.user_id'), nullable=False)
    branch_id = db.Column(Integer, ForeignKey('branch.branch_id'), nullable=False)
    status_comment = db.Column(String)
    number_of_guests = db.Column(Integer, nullable=False)
    status = db.Column(String, nullable=False, default=ReservationStatus.PENDING)
    reservation_date = db.Column(Date, nullable=False)
    reservation_time = db.Column(Time, nullable=False)
    created_at = db.Column(DateTime, default=datetime.utcnow)
    updated_at = db.Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    updated_by = db.Column(Integer, ForeignKey('usertable.user_id'))
    
    branch = relationship('Branch', back_populates='reservations')
    customer = relationship('User', foreign_keys=[user_id], back_populates='reservations')
    updater = relationship('User', foreign_keys=[updated_by], back_populates='updates')

class User(db.Model):
    __tablename__ = 'usertable'
    user_id = db.Column(Integer, primary_key=True, autoincrement=True)
    first_name = db.Column(String(50))
    last_name = db.Column(String(50))
    username = db.Column(String(50), nullable=False, unique=True)
    password_hash = db.Column(String(255), nullable=False)
    email_address = db.Column(String(155), nullable=False, unique=True)
    phone_number = db.Column(String(155), nullable=False)
    role_id = db.Column(Integer, ForeignKey('userrole.role_id'), nullable=False)
    last_login = db.Column(DateTime)
    created_at = db.Column(DateTime, default=datetime.utcnow)
    updated_at = db.Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    role = relationship('UserRole', back_populates='users')
    
    reservations = relationship('CustomerReservation', foreign_keys='CustomerReservation.user_id', back_populates='customer')
    updates = relationship('CustomerReservation', foreign_keys='CustomerReservation.updated_by', back_populates='updater')
    logs = relationship('Log', foreign_keys='Log.user_id', back_populates='user')
    otplogs = relationship('OTPLog', foreign_keys='OTPLog.user_id', back_populates='user')
    feedbacks = relationship('Feedback', foreign_keys='Feedback.user_id', back_populates='user')
    updated_feedbacks = relationship('Feedback', foreign_keys='Feedback.updated_by', back_populates='updater')
    
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
    log_id = db.Column(Integer, primary_key=True, autoincrement=True)
    action = db.Column(String(50), nullable=False)
    user_id = db.Column(Integer, ForeignKey('usertable.user_id'), nullable=False)
    timestamp = db.Column(DateTime, default=datetime.utcnow)
    description = db.Column(Text)
    user = relationship('User', foreign_keys=[user_id], back_populates='logs')

class OTPLog(db.Model):
    __tablename__ = 'otplogs'
    otp_log_id = db.Column(Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(Integer, ForeignKey('usertable.user_id'), nullable=False)
    otp_code = db.Column(String(10), nullable=False)
    timestamp = db.Column(DateTime, default=datetime.utcnow)
    status = db.Column(String, default=OTPStatus.GENERATED)
    description = db.Column(Text)
    user = relationship('User', foreign_keys=[user_id], back_populates='otplogs')

class UserRole(db.Model):
    __tablename__ = 'userrole'
    role_id = db.Column(Integer, primary_key=True, autoincrement=True)
    role_name = db.Column(String, nullable=False, unique=True)

    # Relationships
    users = relationship('User', back_populates='role')

class Feedback(db.Model):
    __tablename__ = 'feedback'
    
    feedback_id = db.Column(Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(Integer, ForeignKey('usertable.user_id'), nullable=False)
    rating = db.Column(Integer, nullable=False)
    message = db.Column(Text, nullable=False)
    created_at = db.Column(DateTime, default=datetime.utcnow)
    updated_at = db.Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    updated_by = db.Column(Integer, ForeignKey('usertable.user_id'))
    
    user = relationship('User', foreign_keys=[user_id], back_populates='feedbacks')
    updater = relationship('User', foreign_keys=[updated_by], back_populates='updated_feedbacks')
