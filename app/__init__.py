# app/__init__.py
from flask import Flask
from .config import Config
from .db import init_db, db
from .routes import register_routes
from flask_bcrypt import Bcrypt
from flask_login import LoginManager
from flask_wtf import CSRFProtect
from .services.auth_services import load_user  # Import the load_user function

bcrypt = Bcrypt()
login_manager = LoginManager()
csrf = CSRFProtect()

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    # Initialize extensions
    db.init_app(app)  # Initialize db with app
    bcrypt.init_app(app)
    login_manager.init_app(app)
    csrf.init_app(app)

    # Configure login view
    login_manager.login_view = "auth_routes.login"

    # Set up the user_loader callback
    login_manager.user_loader(load_user)

    # Register blueprints/routes
    register_routes(app)

    return app
