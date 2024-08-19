Project Setup and Running Instructions
Setting Up the Project
Install Python and XAMPP

Ensure Python and XAMPP are installed on your system.

Export the Project

Copy or move the project directory to C:\xampp\htdocs.

Running the Project
Install Python

Make sure Python is installed on your system.

Create a Virtual Environment

Navigate to the root directory of your project and run:

bash
Copy code
py -3 -m venv .venv
Activate the Virtual Environment

Activate the virtual environment with:

bash
Copy code
.venv\Scripts\activate
Your command line should look like this: (.venv) C:\xampp\htdocs\GScheduler-main>

Install Dependencies

Install the required packages using:

bash
Copy code
pip install -r requirements.txt
Run the Project

Start the Flask application with:

bash
Copy code
flask run
Setting Up XAMPP Database
Open XAMPP Control Panel

Launch the XAMPP Control Panel.

Start Apache and MySQL

Click "Start" for both Apache and MySQL services.

Access phpMyAdmin

Open your browser and navigate to http://localhost/phpmyadmin.

Import the Database

Use the import feature in phpMyAdmin to load the Gscheduler.sql file into the database.

Environment Setup
Create a .env File

In the root directory of your project, create a file named .env.

Add Environment Variables

Open the .env file and add the necessary environment variables. Here is an example configuration:

plaintext
Copy code
# .env

# Flask configuration
FLASK_ENV=development
SECRET_KEY=your-secret-key

# Database configuration
DATABASE_URL=mysql+pymysql://user:password@localhost/dbname

# Session configuration
SESSION_COOKIE_NAME=your_session_cookie_name
SESSION_COOKIE_SECURE=True
SESSION_COOKIE_HTTPONLY=True

# Cache configuration
CACHE_TYPE=simple
CACHE_DEFAULT_TIMEOUT=300

# CSRF configuration
CSRF_ENABLED=True
Note: Remove any unnecessary or duplicate entries and use only the relevant variables for your setup.

Use the .env File

Ensure your application is configured to load environment variables from the .env file. You can use the python-dotenv package to achieve this:

python
Copy code
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

# Example of setting configuration
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL')
Add .env to .gitignore

To prevent the .env file from being committed to version control, ensure it is listed in your .gitignore file:

bash
Copy code
# .gitignore
.env
Provide a Template File

Include a .env.example file with placeholder values. This file should be committed to version control as a reference for other developers:

plaintext
Copy code
# .env.example

# Flask configuration
FLASK_ENV=development
SECRET_KEY=your_secret_key_here

# Database configuration
DATABASE_URL=mysql+pymysql://user:password@localhost/dbname
New developers should copy .env.example to .env and replace the placeholder values with their actual configuration settings.

Framework Type
This project follows the MVC (Model-View-Controller) architectural pattern.