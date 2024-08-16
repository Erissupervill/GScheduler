import os

class Config:
    # Secret Key for session management and CSRF protection
    SECRET_KEY = os.environ.get("SECRET_KEY", "your-default-secret-key")
    
    # Database configuration
    SQLALCHEMY_DATABASE_URI = os.environ.get("DATABASE_URL")
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # Session configuration
    SESSION_COOKIE_NAME = os.environ.get("SESSION_COOKIE_NAME", 'session_cookie_name')
    SESSION_COOKIE_SECURE = os.environ.get("SESSION_COOKIE_SECURE", 'True') == 'True'  # Requires HTTPS if True
    SESSION_COOKIE_HTTPONLY = os.environ.get("SESSION_COOKIE_HTTPONLY", 'True') == 'True'
    PERMANENT_SESSION_LIFETIME = int(os.environ.get("PERMANENT_SESSION_LIFETIME", 3600))  # in seconds

    # Caching configuration
    CACHE_TYPE = os.environ.get("CACHE_TYPE", 'simple')  # options: 'simple', 'filesystem', 'redis', etc.
    CACHE_DEFAULT_TIMEOUT = int(os.environ.get("CACHE_DEFAULT_TIMEOUT", 300))  # in seconds

    # Logging configuration
    LOGGING_LEVEL = os.environ.get("LOGGING_LEVEL", 'DEBUG')  # options: 'DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL'
    LOGGING_FILE = os.environ.get("LOGGING_FILE", 'app.log')
    
    # Security configuration
    # SECURITY_PASSWORD_SALT = os.environ.get("SECURITY_PASSWORD_SALT", 'your-password-salt')
    CSRF_ENABLED = os.environ.get("CSRF_ENABLED", 'True') == 'True'
