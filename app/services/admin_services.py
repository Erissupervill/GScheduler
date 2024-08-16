from app import db
from app.models import User,Logs

def load_user(user_id):
    return User.query.get(int(user_id))

def users_list():
    all_users = User.query.all()
    return all_users

def logs_list():
    all_logs = Logs.query.all()
    return all_logs

# count all users
def count_total_users():
    total_users = User.query.count()
    
    return total_users

# count users by role id or role
def count_by_role(role_id):
    total_users = User.query.filter_by(role_id=role_id).count()
    
    return total_users

def check_email(email):
    check_email = User.query.filter_by(email_address=email).first()
    return check_email

def create_user(username, email, password_hash, phone_number, role_id):
    user = User(username=username, email_address=email, password_hash=password_hash, phone_number=phone_number, role_id=role_id)    
    db.session.add(user)
    db.session.commit()
    return user
    