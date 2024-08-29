from datetime import datetime, timedelta
from app.db import db
from sqlalchemy import extract, func

from app.models import CustomerReservation


def get_booking_summaries():
    today = datetime.now().date()
    week_start = today - timedelta(days=today.weekday())
    month_start = today.replace(day=1)
    
    daily_summary = db.session.query(
        func.date(CustomerReservation.reservation_date).label('date'),
        func.count(CustomerReservation.id).label('total_bookings'),
        func.avg(CustomerReservation.number_of_guests).label('avg_group_size'),
        func.sum(CustomerReservation.status == 'Cancelled').label('total_cancellations')  # Adjusted
    ).group_by(func.date(CustomerReservation.reservation_date)).all()

    weekly_summary = db.session.query(
        extract('week', CustomerReservation.reservation_date).label('week'),
        func.year(CustomerReservation.reservation_date).label('year'),
        func.count(CustomerReservation.id).label('total_bookings'),
        func.avg(CustomerReservation.number_of_guests).label('avg_group_size'),
        func.sum(CustomerReservation.status == 'Cancelled').label('total_cancellations')  # Adjusted
    ).filter(CustomerReservation.reservation_date >= week_start).group_by(extract('week', CustomerReservation.reservation_date), func.year(CustomerReservation.reservation_date)).all()

    monthly_summary = db.session.query(
        extract('month', CustomerReservation.reservation_date).label('month'),
        func.year(CustomerReservation.reservation_date).label('year'),
        func.count(CustomerReservation.id).label('total_bookings'),
        func.avg(CustomerReservation.number_of_guests).label('avg_group_size'),
        func.sum(CustomerReservation.status == 'Cancelled').label('total_cancellations')  # Adjusted
    ).filter(CustomerReservation.reservation_date >= month_start).group_by(extract('month', CustomerReservation.reservation_date), func.year(CustomerReservation.reservation_date)).all()

    return {
        'daily': daily_summary,
        'weekly': weekly_summary,
        'monthly': monthly_summary
    }
    
def fetch_historical_data():
    end_date = datetime.utcnow()
    start_date = end_date - timedelta(days=30)

    # Query to fetch historical reservation data
    historical_data = db.session.query(
        func.extract('hour', CustomerReservation.reservation_time).label('hour'),
        func.count(CustomerReservation.id).label('total_bookings')
    ).filter(
        CustomerReservation.reservation_date.between(start_date, end_date)
    ).group_by(
        func.extract('hour', CustomerReservation.reservation_time)
    ).all()

    # Convert the query result to a list of dictionaries
    return [{'hour': int(record.hour), 'total_bookings': record.total_bookings} for record in historical_data]