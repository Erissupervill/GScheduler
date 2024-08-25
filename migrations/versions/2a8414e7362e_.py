"""empty message

Revision ID: 2a8414e7362e
Revises: 
Create Date: 2024-08-25 16:58:41.435998

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision = '2a8414e7362e'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('feedbacks')
    with op.batch_alter_table('branch', schema=None) as batch_op:
        batch_op.add_column(sa.Column('name', sa.String(length=100), nullable=False))
        batch_op.add_column(sa.Column('location', sa.String(length=100), nullable=False))
        batch_op.drop_column('branch_name')

    with op.batch_alter_table('customer_reservation', schema=None) as batch_op:
        batch_op.alter_column('status',
               existing_type=mysql.ENUM('Pending', 'Confirmed', 'Completed', 'Cancelled', 'Rejected'),
               nullable=False)
        batch_op.alter_column('created_at',
               existing_type=mysql.TIMESTAMP(),
               type_=sa.DateTime(),
               nullable=True,
               existing_server_default=sa.text('current_timestamp()'))
        batch_op.alter_column('updated_at',
               existing_type=mysql.TIMESTAMP(),
               type_=sa.DateTime(),
               nullable=True,
               existing_server_default=sa.text('current_timestamp() ON UPDATE current_timestamp()'))
        batch_op.drop_column('guest_count')
        batch_op.drop_column('customer_id')

    with op.batch_alter_table('userrole', schema=None) as batch_op:
        batch_op.create_unique_constraint(None, ['role_name'])

    with op.batch_alter_table('usertable', schema=None) as batch_op:
        batch_op.drop_index('user_id')
        batch_op.drop_index('user_id_2')
        batch_op.drop_index('user_id_3')

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('usertable', schema=None) as batch_op:
        batch_op.create_index('user_id_3', ['user_id'], unique=True)
        batch_op.create_index('user_id_2', ['user_id'], unique=True)
        batch_op.create_index('user_id', ['user_id'], unique=True)

    with op.batch_alter_table('userrole', schema=None) as batch_op:
        batch_op.drop_constraint(None, type_='unique')

    with op.batch_alter_table('customer_reservation', schema=None) as batch_op:
        batch_op.add_column(sa.Column('customer_id', mysql.INTEGER(display_width=11), autoincrement=False, nullable=False))
        batch_op.add_column(sa.Column('guest_count', mysql.INTEGER(display_width=11), autoincrement=False, nullable=False))
        batch_op.alter_column('updated_at',
               existing_type=sa.DateTime(),
               type_=mysql.TIMESTAMP(),
               nullable=False,
               existing_server_default=sa.text('current_timestamp() ON UPDATE current_timestamp()'))
        batch_op.alter_column('created_at',
               existing_type=sa.DateTime(),
               type_=mysql.TIMESTAMP(),
               nullable=False,
               existing_server_default=sa.text('current_timestamp()'))
        batch_op.alter_column('status',
               existing_type=mysql.ENUM('Pending', 'Confirmed', 'Completed', 'Cancelled', 'Rejected'),
               nullable=True)

    with op.batch_alter_table('branch', schema=None) as batch_op:
        batch_op.add_column(sa.Column('branch_name', mysql.VARCHAR(length=100), nullable=False))
        batch_op.drop_column('location')
        batch_op.drop_column('name')

    op.create_table('feedbacks',
    sa.Column('feedback_id', mysql.INTEGER(display_width=11), autoincrement=True, nullable=False),
    sa.Column('user_id', mysql.INTEGER(display_width=10, unsigned=True), autoincrement=False, nullable=False),
    sa.Column('feedback_text', mysql.TEXT(), nullable=False),
    sa.Column('rating', mysql.INTEGER(display_width=11), autoincrement=False, nullable=True),
    sa.Column('created_at', mysql.DATETIME(), server_default=sa.text('current_timestamp()'), nullable=True),
    sa.Column('updated_at', mysql.DATETIME(), server_default=sa.text('current_timestamp() ON UPDATE current_timestamp()'), nullable=True),
    sa.ForeignKeyConstraint(['user_id'], ['usertable.user_id'], name='fk_feedbacks_usertable_user_id', onupdate='CASCADE', ondelete='CASCADE'),
    sa.PrimaryKeyConstraint('feedback_id'),
    mysql_collate='utf8mb4_general_ci',
    mysql_default_charset='utf8mb4',
    mysql_engine='InnoDB'
    )
    # ### end Alembic commands ###
