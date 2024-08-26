from datetime import datetime
from app.models import Feedback, User
from app.db import db

def get_feedbacks():
    """Retrieve all feedback."""
    return Feedback.query.all()

def get_feedback_by_id(feedback_id):
    """Retrieve a feedback entry by ID."""
    return Feedback.query.get_or_404(feedback_id)

def create_feedback(user_id, rating, message):
    feedback = Feedback(
        user_id=user_id,
        rating=int(rating),
        message=message,
        created_at=datetime.utcnow()
    )

    try:
        db.session.add(feedback)
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        raise RuntimeError('An error occurred while creating feedback.') from e

def update_feedback(feedback_id, rating=None, message=None):
    """Update an existing feedback entry."""
    feedback = Feedback.query.get_or_404(feedback_id)
    
    if rating is not None:
        feedback.rating = int(rating)
    if message is not None:
        feedback.message = message
    feedback.updated_at = datetime.utcnow()

    try:
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        raise RuntimeError('An error occurred while updating feedback.') from e

def delete_feedback(feedback_id):
    """Delete a feedback entry by ID."""
    feedback = Feedback.query.get_or_404(feedback_id)

    try:
        db.session.delete(feedback)
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        raise RuntimeError('An error occurred while deleting feedback.') from e

def get_feedback_by_user(user_id):
    """Retrieve all feedback entries for a specific user."""
    return Feedback.query.filter_by(user_id=user_id).all()
