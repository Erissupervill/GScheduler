from datetime import datetime, timedelta
from app.db import db
from sqlalchemy import extract, func

from app.models import Branch, CustomerReservation


def get_booking_summaries():
    today = datetime.now().date()
    week_start = today - timedelta(days=today.weekday())
    month_start = today.replace(day=1)
    
    daily_summary = db.session.query(
        func.date(CustomerReservation.reservation_date).label('date'),
        CustomerReservation.branch_id.label('branch_id'),
        Branch.name.label('name'),
        Branch.location.label('location'),
        func.count(CustomerReservation.id).label('total_bookings'),
        func.avg(CustomerReservation.number_of_guests).label('avg_group_size'),
        func.sum(CustomerReservation.status == 'Cancelled').label('total_cancellations')
    ).join(Branch, Branch.id == CustomerReservation.branch_id) \
     .group_by(func.date(CustomerReservation.reservation_date), CustomerReservation.branch_id).all()

    weekly_summary = db.session.query(
        extract('week', CustomerReservation.reservation_date).label('week'),
        func.year(CustomerReservation.reservation_date).label('year'),
        CustomerReservation.branch_id.label('branch_id'),
        Branch.name.label('name'),
        Branch.location.label('location'),
        func.count(CustomerReservation.id).label('total_bookings'),
        func.avg(CustomerReservation.number_of_guests).label('avg_group_size'),
        func.sum(CustomerReservation.status == 'Cancelled').label('total_cancellations')
    ).join(Branch, Branch.id == CustomerReservation.branch_id) \
     .filter(CustomerReservation.reservation_date >= week_start) \
     .group_by(extract('week', CustomerReservation.reservation_date), func.year(CustomerReservation.reservation_date), CustomerReservation.branch_id).all()

    monthly_summary = db.session.query(
        extract('month', CustomerReservation.reservation_date).label('month'),
        func.year(CustomerReservation.reservation_date).label('year'),
        CustomerReservation.branch_id.label('branch_id'),
        Branch.name.label('name'),
        Branch.location.label('location'),
        func.count(CustomerReservation.id).label('total_bookings'),
        func.avg(CustomerReservation.number_of_guests).label('avg_group_size'),
        func.sum(CustomerReservation.status == 'Cancelled').label('total_cancellations')
    ).join(Branch, Branch.id == CustomerReservation.branch_id) \
     .filter(CustomerReservation.reservation_date >= month_start) \
     .group_by(extract('month', CustomerReservation.reservation_date), func.year(CustomerReservation.reservation_date), CustomerReservation.branch_id).all()

    return {
        'daily': daily_summary,
        'weekly': weekly_summary,
        'monthly': monthly_summary
    }

    
def fetch_historical_data():
    end_date = datetime.utcnow()
    start_date = end_date - timedelta(days=30)


    historical_data = db.session.query(
        func.extract('hour', CustomerReservation.reservation_time).label('hour'),
        func.count(CustomerReservation.id).label('total_bookings')
    ).filter(
        CustomerReservation.reservation_date.between(start_date, end_date)
    ).group_by(
        func.extract('hour', CustomerReservation.reservation_time)
    ).all()

 
    return [{'hour': int(record.hour), 'total_bookings': record.total_bookings} for record in historical_data]
def get_table_utilization():
    today = datetime.now().date()
    date_reservation = db.session.query(func.hour(CustomerReservation.reservation_time).label('hour'),
        Branch.name.label('name'),
        func.count(CustomerReservation.id).label('reservations')).join(
        Branch, Branch.branch_id == CustomerReservation.branch_id).filter(CustomerReservation.reservation_date == today).all()
    
   
    utilization_data = db.session.query(
        func.hour(CustomerReservation.reservation_time).label('hour'),
        Branch.name.label('name'),
        func.count(CustomerReservation.id).label('reservations')
    ).join(
        Branch, Branch.branch_id == CustomerReservation.branch_id
    ).filter(
        CustomerReservation.reservation_date == today
    ).group_by(
        func.hour(CustomerReservation.reservation_time), Branch.name
    ).all()

    # Debug output
    print("Utilization Data:", date_reservation)
    
    return utilization_data
