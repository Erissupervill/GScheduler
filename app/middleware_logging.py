from flask import current_app, request
from app.models import Log
from app.db import db
from user_agents import parse
from flask_login import current_user
ACTION_DESCRIPTIONS = {
    # Static Files
    '/static/<path:filename>': 'Serve Static Files',

    # General Routes
    '/': 'Homepage',

    # Admin Routes
    '/Admin/': 'Admin Dashboard Index Page',
    '/Admin/api/reservation_predictions': 'View Reservation Predictions',
    '/Admin/Dashboard': 'View Admin Dashboard',
    '/Admin/Users': 'View User List',
    '/Admin/Logs/User': 'View User Logs',
    '/Admin/handle_user_action/<int:id>': 'Handle User Action by ID',
    '/Admin/feedbacks': 'View Feedback List',
    '/Admin/Create/User': 'Create New User',
    '/Admin/Feedbacks': 'View Feedbacks',
    '/Admin/Logs/Audit': 'View Audit Logs',
    '/Admin/Feedbacks/<int:id>': 'View Feedback Details by ID',

    # Staff Routes
    '/Staff/': 'Staff Dashboard Index Page',
    '/Staff/Dashboard': 'View Staff Dashboard',
    '/Staff/Reservation': 'View All Reservations',
    '/Staff/update/reservation/<int:id>': 'Update Reservation by ID',
    '/Staff/reject_reservation_form/<int:id>': 'Form to Reject Reservation by ID',
    '/Staff/reject_reservation': 'Reject Reservation',
    '/Staff/pending-reservations': 'View Pending Reservations',
    '/Staff/Reservation/Accepted': 'View Accepted Reservations',
    '/Staff/complete/reservation/<int:id>': 'Complete Reservation by ID',
    '/Staff/Reservation/Completed': 'View Completed Reservations',
    '/Staff/Reservation/Rejected': 'View Rejected Reservations',
    '/Staff/Reservation/Cancelled': 'View Cancelled Reservations',
    '/Staff/reservation/view/<int:reservation_id>': 'View Reservation Details',

    # Auth Routes
    '/register': 'User Registration',
    '/login': 'User Login',
    '/logout': 'User Logout',

    # User Routes
    '/User/': 'User Dashboard Index Page',
    '/User/Notification': 'View User Notifications',
    '/User/remove_notification/<int:id>': 'Remove User Notification by ID',
    '/User/create/reserve': 'Create Reservation',
    '/User/api/branches': 'Get Branch Information',
    '/User/Reservation/Status': 'Check Reservation Status',
    '/User/cancel_reservation': 'Cancel Reservation',
    '/User/Feedbacks': 'View User Feedbacks',
    '/User/WriteFeedbacks': 'Submit User Feedback',
    '/User/Logs': 'View User Logs',
}



def log_request_action():
    """Log an action before and after each request."""
    if current_user.is_authenticated:
        # Filter out static file requests
        if request.path.startswith('/static/') or \
           any(request.path.endswith(ext) for ext in ['.css', '.js', '.png', '.jpg', '.jpeg', '.gif']):
            return  # Skip logging for static files

        # Get a user-friendly description for the action
        action_description = ACTION_DESCRIPTIONS.get(request.path, 'Unknown Action')
        
        # If it's a POST request, check for specific actions
        if request.method == 'POST':
            action = request.form.get('action')
            if action:
                action_description = f"{action.capitalize()} Action"
        
        user_agent = request.headers.get('User-Agent')
        browser_info = parse(user_agent)

        # Create a new log entry
        new_log = Log(
            user_id=current_user.user_id,
            action=action_description,
            description=f"User {current_user.first_name} {current_user.last_name} accessed {request.path} with action: {action_description}",
            browser=f"{browser_info.browser.family} {browser_info.browser.version_string}",
        )
        try:
            db.session.add(new_log)
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            current_app.logger.error(f"Error logging action: {e}")

# Register the middleware in your Flask app
def register_logging(app):
    app.before_request(log_request_action)
