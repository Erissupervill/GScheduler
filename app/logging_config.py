#logging_config.py

import logging
from logging import StreamHandler, FileHandler

def setup_logging(app):
    # Configure logging format
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

    # Set up console handler
    console_handler = StreamHandler()
    console_handler.setLevel(logging.INFO)
    console_handler.setFormatter(formatter)

    # Set up file handler
    file_handler = FileHandler('app.log')
    file_handler.setLevel(logging.INFO)
    file_handler.setFormatter(formatter)

    # Add handlers to the app's logger
    app.logger.addHandler(console_handler)
    app.logger.addHandler(file_handler)

    # Optionally set the logging level for the app
    app.logger.setLevel(logging.INFO)