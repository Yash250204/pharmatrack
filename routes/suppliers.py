from flask import Blueprint, render_template
import mysql.connector
from config import DB_CONFIG

suppliers_bp = Blueprint('suppliers', __name__)

@suppliers_bp.route('/suppliers')
def suppliers():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            supplier_id,
            name,
            city,
            contact_number,
            email,
            rating,
            delivery_time_days
        FROM suppliers
        ORDER BY rating DESC
    """)

    suppliers_list = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('suppliers.html', 
                           suppliers=suppliers_list)