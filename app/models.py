# app/models.py
from flask_login import UserMixin
from app.db import db
import datetime 

class User(db.Model, UserMixin):
    __tablename__ = "usertable"
    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(150), nullable=False, unique=True)
    email_address = db.Column(db.String(150), nullable=False, unique=True)
    password_hash = db.Column(db.String(150), nullable=False)
    phone_number = db.Column(db.String(255), nullable=False)
    role_id = db.Column(db.Integer, db.ForeignKey('userrole.roleID'), nullable=False)
    last_login = db.Column(db.DateTime, nullable=True)
    logs = db.relationship('Logs', backref='user', lazy=True, cascade="all, delete-orphan")

    # Define relationships with back_populates
    reservations = db.relationship('Reservation', foreign_keys='Reservation.customer_id', back_populates='customer')
    updated_reservations = db.relationship('Reservation', foreign_keys='Reservation.updated_by', back_populates='updated_by_user')

    def get_id(self):
        return str(self.user_id)

    def update_last_login(self):
        self.last_login = datetime.datetime.now()
        db.session.commit()


class UserRole(db.Model):
    __tablename__ = "userrole"
    roleID = db.Column(db.Integer, primary_key=True)
    roleName = db.Column(db.String(150), nullable=False)
    users = db.relationship('User', backref='role', lazy=True)

class Reservation(db.Model):
    __tablename__ = 'reservation'
    reservation_id = db.Column(db.Integer, primary_key=True)
    customer_id = db.Column(db.Integer, db.ForeignKey('usertable.user_id'))
    reservation_date_time = db.Column(db.DateTime)
    table_id = db.Column(db.Integer, db.ForeignKey('restauranttable.table_id'))
    status = db.Column(db.String(50))
    updated_by = db.Column(db.Integer, db.ForeignKey('usertable.user_id'))

    # Define relationships with back_populates
    table = db.relationship('RestaurantTable', foreign_keys=[table_id], back_populates='reservations')
    updated_by_user = db.relationship('User', foreign_keys=[updated_by], back_populates='updated_reservations')
    customer = db.relationship('User', foreign_keys=[customer_id], back_populates='reservations')




class RestaurantTable(db.Model):
    __tablename__ = 'restauranttable'
    table_id = db.Column(db.Integer, primary_key=True)
    capacity = db.Column(db.Integer)
    location = db.Column(db.String(100))
    availability_status = db.Column(db.String(50))

    # Define the relationship
    reservations = db.relationship('Reservation', back_populates='table')

            
class Logs(db.Model):
    LogID = db.Column(db.Integer, primary_key=True)
    action = db.Column(db.String(150), nullable=False, unique=True)
    UserID = db.Column(db.Integer, db.ForeignKey('usertable.user_id'), nullable=False, unique=True)
    Timestamp = db.Column(db.DateTime, nullable=False, unique=True)
    Description = db.Column(db.String(150), nullable=False, unique=True)