from app.models import Branch
from app.db import db

def get_branch():
    """Retrieve all feedback."""
    return Branch.query.all()

def create_new_branch(data):
    """Create a new branch."""
    branch = Branch(
        name=data['name'],
        location=data['location'],
        capacity=data['capacity'],
    )
    db.session.add(branch)
    db.session.commit()
    return branch

def update_branch(branch_id, data):
    """Update branch details based on provided data."""
    branch = Branch.query.get(branch_id)
    
    print(data)
    if not branch:
        raise ValueError("Branch not found")
    
    if 'name' in data and data['name']:
        branch.name = data['name']
    if 'location' in data and data['location']:
        branch.location = data['location']
    if 'capacity' in data and data['capacity']:
        branch.capacity = data['capacity']
    
    db.session.commit()
    return branch


def delete_branch(branch_id):
    """Delete a branch by ID."""
    branch = Branch.query.get(branch_id)
    if not branch:
        raise ValueError("User not found")
    
    db.session.delete(branch)
    db.session.commit()
    
