from app import create_app
import logging

app=create_app()

logging.basicConfig(level=logging.INFO)
logging.info("Starting the Flask application...")

if __name__ == "__main__":
    app.run(debug = app.config['DEBUG'])   