# config.py
import os

import os

class Config:
    # Flask settings
    SECRET_KEY = os.environ.get("SECRET_KEY", "your-default-secret-key")
    SQLALCHEMY_DATABASE_URI = os.environ.get("DATABASE_URL")
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SESSION_COOKIE_NAME = os.environ.get("SESSION_COOKIE_NAME", 'session_cookie_name')
    SESSION_COOKIE_SECURE = os.environ.get("SESSION_COOKIE_SECURE", 'True') == 'True'
    SESSION_COOKIE_HTTPONLY = os.environ.get("SESSION_COOKIE_HTTPONLY", 'True') == 'True'
    PERMANENT_SESSION_LIFETIME = int(os.environ.get("PERMANENT_SESSION_LIFETIME", 3600))
    CACHE_TYPE = os.environ.get("CACHE_TYPE", 'simple')
    CACHE_DEFAULT_TIMEOUT = int(os.environ.get("CACHE_DEFAULT_TIMEOUT", 300))
    LOGGING_LEVEL = os.environ.get("LOGGING_LEVEL", 'DEBUG')
    LOGGING_FILE = os.environ.get("LOGGING_FILE", 'app.log')
    CSRF_ENABLED = os.environ.get("CSRF_ENABLED", 'True') == 'True'
    
    # Email settings
    MAIL_SERVER = os.environ.get('MAIL_SERVER')
    MAIL_PORT = int(os.environ.get('MAIL_PORT'))
    MAIL_USERNAME = os.environ.get('MAIL_USERNAME')
    MAIL_PASSWORD = os.environ.get('MAIL_PASSWORD')
    MAIL_USE_TLS = os.environ.get('MAIL_USE_TLS') == 'True'
    MAIL_USE_SSL = os.environ.get('MAIL_USE_SSL') == 'True'

    # Firebase settings for future use
    # FIREBASE_API_KEY = os.environ.get("FIREBASE_API_KEY")
    # FIREBASE_AUTH_DOMAIN = os.environ.get("FIREBASE_AUTH_DOMAIN")
    # FIREBASE_PROJECT_ID = os.environ.get("FIREBASE_PROJECT_ID")
    # FIREBASE_STORAGE_BUCKET = os.environ.get("FIREBASE_STORAGE_BUCKET")
    # FIREBASE_MESSAGING_SENDER_ID = os.environ.get("FIREBASE_MESSAGING_SENDER_ID")
    # FIREBASE_APP_ID = os.environ.get("FIREBASE_APP_ID")

    

class DevelopmentConfig(Config):
    DEBUG = True
    ENV = 'development'
    BASE_DIR = os.path.abspath(os.path.dirname(__file__))
    SQLALCHEMY_DATABASE_URI = f'sqlite:///{os.path.join(BASE_DIR, "my_database.db")}'

class ProductionConfig(Config):
    DEBUG = True
    ENV = 'production'
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL', 'mysql+mysqldb://root:@localhost/gscheduler')

def get_config_class():
    print("Flask is running in environment:",os.getenv('FLASK_ENV'))
    if os.getenv('FLASK_ENV') == 'development':
        return DevelopmentConfig
    return ProductionConfig
