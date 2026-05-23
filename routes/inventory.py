from flask import Blueprint, render_template
import mysql.connector
from config import DB_CONFIG

inventory_bp = Blueprint('inventory', __name__)

@inventory_bp.route('/inventory')
def inventory():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            i.inventory_id,
            m.name AS medicine_name,
            m.category,
            w.name AS warehouse_name,
            w.city,
            i.quantity,
            m.reorder_level,
            i.expiry_date,
            DATEDIFF(i.expiry_date, CURDATE()) AS days_to_expiry,
            CASE
                WHEN i.quantity = 0 THEN 'Out of Stock'
                WHEN i.quantity < m.reorder_level THEN 'Low Stock'
                WHEN DATEDIFF(i.expiry_date, CURDATE()) <= 90 
                     THEN 'Expiring Soon'
                ELSE 'Healthy'
            END AS stock_status
        FROM inventory i
        JOIN medicines m ON i.medicine_id = m.medicine_id
        JOIN warehouses w ON i.warehouse_id = w.warehouse_id
        ORDER BY stock_status, days_to_expiry
    """)

    items = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('inventory.html', items=items)