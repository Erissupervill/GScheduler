from flask import current_app
import pandas as pd
from datetime import timedelta
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
import numpy as np

def get_historical_data(csv_file_path):
    """Load historical reservation data from CSV and process dates."""
    try:
        # Load the data from CSV
        df = pd.read_csv(csv_file_path)
        
        # Check for required columns
        required_columns = ['reservation_date', 'number_of_guests']
        missing_columns = [col for col in required_columns if col not in df.columns]
        if missing_columns:
            raise ValueError(f"Required columns are missing from the DataFrame: {', '.join(missing_columns)}")
        
        # Convert 'reservation_date' to datetime format
        df['reservation_date'] = pd.to_datetime(df['reservation_date'], format='%d/%m/%Y')
        
        return df
    except Exception as e:
        current_app.logger.error(f'Error loading historical data: {e}')
        raise

def train_model(df):
    """Train a linear regression model using historical reservation data."""
    try:
        # Ensure 'reservation_date' is in datetime format
        df['reservation_date'] = pd.to_datetime(df['reservation_date'], format='%d/%m/%Y')
        
        # Aggregate data by month
        df_monthly = df.groupby(df['reservation_date'].dt.to_period('d')).agg({
            'number_of_guests': 'sum'
        }).reset_index()
        # print(df_monthly)
        # Rename columns for clarity
        df_monthly.columns = ['month', 'total_guests']
        
        # Convert 'month' to ordinal format for regression
        df_monthly['month'] = df_monthly['month'].apply(lambda x: x.to_timestamp().toordinal())
        
        # Prepare features and target variable
        X = df_monthly[['month']].values
        y = df_monthly['total_guests'].values
        
        # Split data into training and test sets (if needed)
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=0)
        
        # Define and fit the Linear Regression model
        model = LinearRegression()
        model.fit(X_train, y_train)
        
        # Forecast future reservations
        forecast_steps = 7  # Forecast for the next 7 months
        last_date = df_monthly['month'].max()
        future_dates = [last_date + i for i in range(1, forecast_steps + 1)]
        
        # Prepare data for predictions
        future_dates_ordinal = np.array(future_dates).reshape(-1, 1)
        forecast = model.predict(future_dates_ordinal)
        
        # Convert future dates back to 'YYYY-MM' format
        future_dates_formatted = [pd.Timestamp.fromordinal(int(date)).strftime('%Y-%m') for date in future_dates]
        
        # Return the trained model, min_date, and last_day
        min_date = df_monthly['month'].min()
        last_day = df_monthly['month'].max()
        
        return model, min_date, last_day, future_dates_formatted, forecast.tolist()
    except Exception as e:
        current_app.logger.error(f'Error training model: {e}')
        raise

def get_reservation_predictions(model, min_date, max_date):
    """Generate predictions using the trained Linear Regression model."""
    try:
        # Generate future dates for prediction
        date_range = pd.date_range(start=min_date, end=max_date + timedelta(days=8))  # Include 7 days plus 1 future day
        future_dates_ordinal = np.array([date.toordinal() for date in date_range]).reshape(-1, 1)
        
        # Predict reservations
        predictions = model.predict(future_dates_ordinal)
        
        return date_range.strftime('%Y-%m-%d').tolist(), predictions.tolist()
    except Exception as e:
        current_app.logger.error(f'Error generating reservation predictions: {e}')
        raise

