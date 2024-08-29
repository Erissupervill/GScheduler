from flask_wtf import FlaskForm
from wtforms import DateTimeField, DateTimeLocalField, RadioField, SelectField, StringField, PasswordField, SubmitField, TextAreaField
from wtforms.validators import DataRequired, Email, EqualTo, Length

class RegistrationForm(FlaskForm):
    last_name = StringField('Name', validators=[DataRequired(), Length(min=2, max=25)])
    first_name = StringField('Last Name', validators=[DataRequired(), Length(min=2, max=25)])
    email = StringField('Email', validators=[DataRequired(), Email()])
    phone_number = StringField('Phone Number', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired(),Length(min=2, max=10)])
    confirmpassword = PasswordField('Confirm Password', validators=[DataRequired(), EqualTo('password'),Length(min=2, max=10)])
    role = StringField('role', validators=[DataRequired()])
    submit = SubmitField('Sign Up')
    
class LoginForm(FlaskForm):
    email_address = StringField('Email', validators=[DataRequired(),Email()])
    password = PasswordField('Password', validators=[DataRequired(),Length(min=2, max=10)])
    submit = SubmitField('Register')
    
class ReservationForm(FlaskForm):
    reservation_date = DateTimeField('Reservation Date', format='%Y-%m-%d', validators=[DataRequired()])
    reservation_time = DateTimeField('Reservation Time', format='%H:%M', validators=[DataRequired()])
    number_of_guests = StringField('Number of Guests', validators=[DataRequired()])
    branch_id = StringField('Branch',validators=[DataRequired()])
    submit = SubmitField('Reserve')
    
class FeedbackForm(FlaskForm):
    rating = RadioField('Rating', choices=[('1', '1 star'), ('2', '2 stars'), ('3', '3 stars'), ('4', '4 stars'), ('5', '5 stars')], validators=[DataRequired()])
    message = TextAreaField('Message', validators=[DataRequired()])

    
class UserForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired(), Length(min=2, max=10)])
    first_name = StringField('First name', validators=[DataRequired(), Length(min=2, max=10)])
    last_name = StringField('Last name', validators=[DataRequired(), Length(min=2, max=10)])
    email = StringField('Email', validators=[DataRequired(), Email()])
    phone_number = StringField('Phone Number', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired(),Length(min=2, max=10)])
    confirmpassword = PasswordField('Confirm Password', validators=[DataRequired(), EqualTo('password'),Length(min=2, max=10)])
    role = StringField('role', validators=[DataRequired()])
    submit = SubmitField('Sign Up')
