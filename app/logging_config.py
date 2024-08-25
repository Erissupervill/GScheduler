# app/logging_config.py

import logging
from logging.handlers import RotatingFileHandler

def setup_logging(app):
    # Set up logging
    if not app.debug:
        # Create a file handler for the log file
        file_handler = RotatingFileHandler('app.log', maxBytes=10240, backupCount=10)
        file_handler.setLevel(logging.INFO)

        # Create a formatter and set it for the handler
        formatter = logging.Formatter('%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]')
        file_handler.setFormatter(formatter)

        # Add the handler to the app's logger
        app.logger.addHandler(file_handler)
        app.logger.setLevel(logging.INFO)
