
from app.models import Notification
from app.db import db
from flask import current_app


def get_user_notifications(user_id):
    return Notification.query.filter_by(user_id=user_id).all()

def create_notification(user_id,reservation_id,message,notification_date,notification_time):
    try:
        notification = Notification(user_id=user_id,
                                    reservation_id=reservation_id,
                                    message=message,
                                    notification_date=notification_date,
                                    notification_time=notification_time)
        db.session.add(notification)
        db.session.commit()
    except Exception as e:
        current_app.logger.error((f"Error while creating notification: {e}"))
    

def delete_user_notifications(notification_id):
    notification = Notification.query.get(notification_id)
    if not notification:
        raise ValueError(f"Notification with ID={notification_id} not found.")
    try:
        db.session.delete(notification)
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error while retrieving reservation with ID={notification_id}: {e}")
        raise
    