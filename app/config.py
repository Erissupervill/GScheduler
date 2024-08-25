# config.py
import os

class Config:
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

class DevelopmentConfig(Config):
    debug = True
    ENV = 'development'
    BASE_DIR = os.path.abspath(os.path.dirname(__file__))
    SQLALCHEMY_DATABASE_URI = f'sqlite:///{os.path.join(BASE_DIR, "my_database.db")}'

class ProductionConfig(Config):
    debug = True
    ENV = 'production'
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL', 'mysql+mysqldb://root:@localhost/gscheduler')

def get_config_class():
    print(os.getenv('FLASK_ENV'))
    if os.getenv('FLASK_ENV') == 'development':
        return DevelopmentConfig
    return ProductionConfig
