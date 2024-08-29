from datetime import datetime, timedelta
import os
from flask import Blueprint, current_app, jsonify
from flask_login import login_required
import numpy as np
from app.db import db
from app.ml_model import get_historical_data, train_model
from app.services.api_services import get_booking_summaries
from app.services.api_services import fetch_historical_data
from app.services.reservation_services import get_reservations

api_routes_bp = Blueprint('api_routes_bp', __name__)

@api_routes_bp.route('/api/reservation_predictions')
@login_required
def reservation_predictions():
    """API endpoint to get reservation predictions."""
    try:
        project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../'))
        csv_file_path = os.path.join(project_root, 'customer_reservation.csv')
        
        # Get historical data and train model
        df = get_historical_data(csv_file_path)
        if df.empty:
            raise ValueError("Historical data could not be loaded or is empty.")
        
        model, min_date, last_day, dates, predictions = train_model(df)
        
        # Get the last 5 days, today, and tomorrow
        end_date = datetime.today()
        start_date = end_date - timedelta(days=6)
        date_range = [start_date + timedelta(days=i) for i in range(7)]
        
        # Convert dates to string format for labels
        labels = [date.strftime('%Y-%m-%d') for date in date_range]
        
        # Fetch actual reservations data for the last 7 days
        actual_reservations = get_reservations()
        
        # print(actual_reservations.reservation_date)
        actual_data = []
        for date in date_range:
            # Filter reservations for the current date
          
            daily_reservations = [res for res in actual_reservations if res.reservation_date.strftime('%Y-%m-%d') == date.strftime('%Y-%m-%d')]
            # for res in actual_reservations:
            #     print(type(res.reservation_date))
            # Sum the number of guests for the filtered reservations
            daily_sum = sum(res.number_of_guests for res in daily_reservations)
            
            actual_data.append(daily_sum)
        # print(actual_data)
        
        # Ensure predictions cover the last 7 days, today, and tomorrow
        future_dates = [(end_date + timedelta(days=i)).strftime('%Y-%m-%d') for i in range(1, 3)]  # Tomorrow and the day after
        dates = labels + future_dates
        
        # Get the last date's ordinal for future predictions
        last_date_ordinal = datetime.today().toordinal()
        future_dates_ordinal = [last_date_ordinal + i for i in range(1, 3)]
        
        # Predict future reservations
        future_predictions = model.predict(np.array(future_dates_ordinal).reshape(-1, 1)).tolist()
        
        print(future_predictions)
        
        # Convert predictions and actual_data to native Python types
        actual_data = [int(val) for val in actual_data]  # Convert int64 to int
        combined_predictions = [0] * len(labels) + future_predictions
        combined_predictions = [float(val) for val in combined_predictions]  # Convert np.float64 to float
        
        # Return JSON response
        return jsonify({
            'labels': dates,
            'actual': actual_data + [0] * len(future_dates),  # Zeroes for future days
            'predicted': combined_predictions
        })
    except Exception as e:
        current_app.logger.error('Error in reservation_predictions: %s', e)
        return jsonify({'error': 'An error occurred while fetching predictions'}), 500

@api_routes_bp.route('/api/daily_booking_summary', methods=['GET'])
def get_daily_booking_summary():
    # Fetch daily booking summaries from the database
    summaries = get_booking_summaries()
    daily_summary = summaries['daily']
    
    data = [{
        'date': item.date,
        'total_bookings': item.total_bookings,
        'avg_group_size': item.avg_group_size,
        'cancellation_rate': item.total_cancellations / item.total_bookings * 100 if item.total_bookings > 0 else 0
    } for item in daily_summary]

    return jsonify(data)

@api_routes_bp.route('/api/weekly_booking_summary', methods=['GET'])
def get_weekly_booking_summary():
    # Fetch weekly booking summaries from the database
    summaries = get_booking_summaries()
    weekly_summary = summaries['weekly']
    
    data = [{
        'week': item.week,
        'year': item.year,
        'total_bookings': item.total_bookings,
        'avg_group_size': item.avg_group_size,
        'cancellation_rate': item.total_cancellations / item.total_bookings * 100 if item.total_bookings > 0 else 0
    } for item in weekly_summary]

    return jsonify(data)

@api_routes_bp.route('/api/monthly_booking_summary', methods=['GET'])
def get_monthly_booking_summary():
    # Fetch monthly booking summaries from the database
    summaries = get_booking_summaries()
    monthly_summary = summaries['monthly']
    
    data = [{
        'month': item.month,
        'year': item.year,
        'total_bookings': item.total_bookings,
        'avg_group_size': item.avg_group_size,
        'cancellation_rate': item.total_cancellations / item.total_bookings * 100 if item.total_bookings > 0 else 0
    } for item in monthly_summary]

    return jsonify(data)

@api_routes_bp.route('/api/peak_time_predictions', methods=['GET'])
def get_peak_time_predictions():
    historical_data = fetch_historical_data()
    peak_times = predict_peak_times(historical_data)  
    
    print(historical_data)

    response = {
        'labels': [str(hour) for hour in range(24)],  # 24-hour format labels
        'predictions': peak_times
    }
    return jsonify(response)

def predict_peak_times(historical_data):
    # Initialize predictions for each hour (0-23) to zero
    predictions = [0] * 24

    # Iterate over historical data to populate the predictions list
    for record in historical_data:
        hour = record['hour']  # Extract the hour from the record
        total_bookings = record['total_bookings']  # Extract the total bookings for that hour
        predictions[hour] = total_bookings  # Update the predictions list at the index corresponding to the hour

    return predictions
