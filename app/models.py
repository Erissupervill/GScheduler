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
    role_id = db.Column(db.String(255), nullable=False)
    last_login = db.Column(db.DateTime, nullable=True)  # Use DateTime type
    logs = db.relationship('Logs', backref='user', lazy=True, cascade="all, delete-orphan")

    def get_id(self):
        return str(self.user_id)

    def update_last_login(self):
        self.last_login = datetime.datetime.now()
        db.session.commit()
        
class Logs(db.Model):
    LogID = db.Column(db.Integer, primary_key=True)
    action = db.Column(db.String(150), nullable=False, unique=True)
    UserID = db.Column(db.Integer, db.ForeignKey('usertable.user_id'), nullable=False, unique=True)
    Timestamp = db.Column(db.DateTime, nullable=False, unique=True)
    Description = db.Column(db.String(150), nullable=False, unique=True)