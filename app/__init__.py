# app/__init__.py
from flask import Flask, render_template
from app.config import get_config_class
from app.logging_config import setup_logging
from app.middleware_logging import register_logging
from app.ml_model import train_model
from .db import init_db
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
    # Load configuration
    config_class = get_config_class()
    app.config.from_object(config_class)
    
    # Initialize logger
    setup_logging(app)

    # Initialize extensions
    init_db(app)
    bcrypt.init_app(app)
    login_manager.init_app(app)
    csrf.init_app(app)

    # Set up context processor
    @app.context_processor
    def inject_user():
        if current_user.is_authenticated:
            role_name = current_user.role.role_name if current_user.role else 'No Role Assigned'
            return {'role_name': role_name}
        return {'role_name': 'Customer'}

    # Configure login view
    login_manager.login_view = "auth_routes.login"

    # Set up user_loader callback
    login_manager.user_loader(load_user)

    # Register blueprints/routes
    register_routes(app)

    # Error handler for 404 errors
    @app.errorhandler(404)
    def page_not_found(error):
        return render_template('page_not_found.html', error=error), 404
    
    # Inititialize Logging to database
    register_logging(app)
    
    # # Initialize machine learning model
    # with app.app_context():
    #     # Run the model training function
    #     train_model()

    return app
