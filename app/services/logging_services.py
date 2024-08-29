from flask import current_app, request
from user_agents import parse
from app.db import db
from app.models import Log, User

def log_action(user_id, action, description=None):
    """Log an action performed by a user."""
    user_agent = request.headers.get('User-Agent')
    browser_info = parse(user_agent)

    new_log = Log(
        user_id=user_id,
        action=action,
        description=description,
        browser=f"{browser_info.browser.family} {browser_info.browser.version_string}"
    )

    try:
        db.session.add(new_log)
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error logging action: {e}")
        raise

    
def get_logs():
    try:
        logs = db.session.query(Log,User).join(User, Log.user_id == User.user_id).all()  # Using the Model's query property
        return logs
    except Exception as e:
        current_app.logger.error(f"Error while retrieving logs: {e}")
        raise
