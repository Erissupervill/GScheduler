from flask import Flask, flash, redirect, render_template, url_for
from sqlalchemy import null
from .config import get_config_class
from .db import db
from .routes import register_routes
from flask_bcrypt import Bcrypt
from flask_login import LoginManager, current_user
from flask_wtf import CSRFProtect
from .services.auth_services import load_user
import os

bcrypt = Bcrypt()
login_manager = LoginManager()
csrf = CSRFProtect()

def create_app():
    app = Flask(__name__)

    # Determine the appropriate configuration
    config_class = get_config_class()
    print(f"Using configuration: {config_class.__name__}")
    app.config.from_object(config_class)

    # Initialize extensions
    db.init_app(app)
    bcrypt.init_app(app)
    login_manager.init_app(app)
    csrf.init_app(app)
    
    @app.context_processor
    def inject_user():
        if current_user.is_authenticated:
            role_name = current_user.role.roleName if current_user.role else 'No Role Assigned'
            return {'role_name': role_name}
        return {'role_name': 'test'}

    # Configure login view
    login_manager.login_view = "auth_routes.login"

    # Set up the user_loader callback
    login_manager.user_loader(load_user)

    # Register blueprints/routes
    register_routes(app)

    # Error handler for 404 errors
    @app.errorhandler(404)
    def page_not_found(error):
        return render_template('page_not_found.html', error=error), 404

    return app
