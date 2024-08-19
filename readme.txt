# Project Setup and Running Instructions

## Setting Up the Project

1. **Install Python and XAMPP**

   Ensure Python and XAMPP are installed on your system.

2. **Export the Project**

   Copy or move the project directory to `C:\xampp\htdocs`.

## Running the Project

1. **Install Python**

   Make sure Python is installed on your system.

2. **Create a Virtual Environment**

   Navigate to the root directory of your project and run:

   py -3 -m venv .venv

3. **Activate the Virtual Environment**

   Activate the virtual environment with:

   .venv\Scripts\activate

   Your command line should look like this: `(.venv) C:\xampp\htdocs\GScheduler-main>`

4. **Install Dependencies**

   Install the required packages using:

   pip install -r requirements.txt

5. **Run the Project**

   Start the Flask application with:

   flask run

## Setting Up XAMPP Database

1. **Open XAMPP Control Panel**

   Launch the XAMPP Control Panel.

2. **Start Apache and MySQL**

   Click "Start" for both Apache and MySQL services.

3. **Access phpMyAdmin**

   Open your browser and navigate to [http://localhost/phpmyadmin](http://localhost/phpmyadmin).

4. **Import the Database**

   Use the import feature in phpMyAdmin to load the `Gscheduler.sql` file into the database.

## Environment Setup

1. **Create a `.env` File**

   In the root directory of your project, create a file named `.env`.

2. **Add Environment Variables**

   Open the `.env` file and add the necessary environment variables. Here is an example configuration:

   # .env

   # Flask configuration
   FLASK_ENV=development
   SECRET_KEY=your-secret-key

   # Database configuration
   DATABASE_URL=mysql+pymysql://user:password@localhost/dbname

## Framework Type

This project follows the MVC (Model-View-Controller) architectural pattern.
