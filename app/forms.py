from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import DataRequired, Email, EqualTo, Length

class RegistrationForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired(), Length(min=2, max=10)])
    email = StringField('Email', validators=[DataRequired(), Email()])
    phone_number = StringField('Phone Number', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired(),Length(min=2, max=10)])
    confirmpassword = PasswordField('Confirm Password', validators=[DataRequired(), EqualTo('password'),Length(min=2, max=10)])
    role = PasswordField('Confirm Password', validators=[DataRequired()])
    submit = SubmitField('Sign Up')
    
class LoginForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired(),Length(min=2, max=10)])
    password = PasswordField('Password', validators=[DataRequired(),Length(min=2, max=10)])
    submit = SubmitField('Register')
    
