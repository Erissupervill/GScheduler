from flask import Blueprint, redirect, render_template, url_for

from app.services.feedback_services import get_feedback_good



routes_bp = Blueprint('routes', __name__)

@routes_bp.route("/")
def index():
    reviews = get_feedback_good()
    return render_template("frontpage.html",reviews=reviews)


def page_not_found(error):
    print(error)
    return render_template("page_not_found.html"), 404


# Register blueprints
def register_routes(app):
    from .staff_routes import staff_routes_bp
    from .admin_routes import admin_routes_bp
    from .auth_routes import auth_routes_bp
    from .user_routes import user_routes_bp
    from .api_routes import api_routes_bp
    
    app.register_blueprint(api_routes_bp)
    app.register_blueprint(routes_bp)
    app.register_blueprint(admin_routes_bp)
    app.register_blueprint(staff_routes_bp)
    app.register_blueprint(auth_routes_bp)
    app.register_blueprint(user_routes_bp)