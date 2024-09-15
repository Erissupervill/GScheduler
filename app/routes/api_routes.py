from datetime import datetime, timedelta
from io import BytesIO
import os
from flask import Blueprint, Response, current_app, jsonify, render_template
from flask_login import login_required
from matplotlib import pyplot as plt
import numpy as np
import pandas as pd
from app.db import db
from app.ml_model import get_historical_data, train_model
from app.models import CustomerReservation
from app.services.api_services import get_booking_summaries, get_table_utilization
from app.services.api_services import fetch_historical_data
from app.services.reservation_services import get_reservations
import seaborn as sns
import matplotlib.colors as mcolors

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
        
        end_date = datetime.today()
        start_date = end_date - timedelta(days=6)
        date_range = [start_date + timedelta(days=i) for i in range(7)]
        
        labels = [date.strftime('%Y-%m-%d') for date in date_range]
        
        actual_reservations = get_reservations()
        
        # print(actual_reservations.reservation_date)
        actual_data = []
        for date in date_range:
        
          
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
        

        future_predictions = model.predict(np.array(future_dates_ordinal).reshape(-1, 1)).tolist()
        
        # print(future_predictions)
        
        # Convert predictions and actual_data to native Python types
        actual_data = [int(val) for val in actual_data]  
        combined_predictions = [0] * len(labels) + future_predictions
        combined_predictions = [float(val) for val in combined_predictions]  
        
       
        return jsonify({
            'labels': dates,
            'actual': actual_data + [0] * len(future_dates),  
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
        'branch': item.name,
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
    
        # print(week._asdict())
    data = [{
        'branch': item.name,
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
        'branch': item.name,
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
    
    # print(historical_data)

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
        hour = record['hour']  
        total_bookings = record['total_bookings']  
        predictions[hour] = total_bookings  

    return predictions


@api_routes_bp.route('/api/test')
def test():
    return render_template('admin/test.html')


def categorize_hour(hour):
    if 0 <= hour < 12:
        return 'Morning'
    elif 12 <= hour < 18:
        return 'Afternoon'
    else:
        return 'Evening'

@api_routes_bp.route('/api/resource_utilization_heatmap', methods=['GET'])
def resource_utilization_heatmap():

    utilization_data = get_table_utilization()
    
  
    data = []
    for entry in utilization_data:
        hour = entry.hour
        branch_name = entry.name
        tables_used = entry.reservations
        hour_category = categorize_hour(hour)
        print("HOURCATEGORY", entry)
        data.append([hour_category, branch_name, tables_used])
    
    df = pd.DataFrame(data, columns=['Period', 'Branch', 'Reservations'])
    
   
    periods = ['Morning', 'Afternoon', 'Evening']
    branches = df['Branch'].unique()
    
   
    index = pd.MultiIndex.from_product([periods, branches], names=['Period', 'Branch'])
    heatmap_data = pd.DataFrame(index=index).reset_index()
    

    heatmap_data = heatmap_data.merge(df, how='left', on=['Period', 'Branch'])
    # heatmap_data['Reservations'].fillna(0, inplace=True) 
    heatmap_data.loc[:, 'Reservations'] = heatmap_data['Reservations'].fillna(0)

    heatmap_json = heatmap_data.to_json(orient='split')
    response = Response(heatmap_json, mimetype='application/json')
    response.headers['Content-Type'] = 'application/json'
    
    return response

@api_routes_bp.route('/api/firebase-config', methods=['GET', 'POST'])
def firebase_config():
    return jsonify({
        'apiKey': current_app.config['FIREBASE_API_KEY'],
        'authDomain': current_app.config['FIREBASE_AUTH_DOMAIN'],
        'projectId': current_app.config['FIREBASE_PROJECT_ID'],
        'storageBucket': current_app.config['FIREBASE_STORAGE_BUCKET'],
        'messagingSenderId': current_app.config['FIREBASE_MESSAGING_SENDER_ID'],
        'appId': current_app.config['FIREBASE_APP_ID'],
    })