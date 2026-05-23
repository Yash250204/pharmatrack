from flask import Blueprint, render_template
import mysql.connector
from config import DB_CONFIG

alerts_bp = Blueprint('alerts', __name__)

@alerts_bp.route('/alerts')
def alerts():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            ra.alert_id,
            m.name AS medicine_name,
            w.name AS warehouse_name,
            w.city,
            ra.current_quantity,
            ra.reorder_level,
            ra.alert_status,
            ra.created_at
        FROM restock_alerts ra
        JOIN medicines m ON ra.medicine_id = m.medicine_id
        JOIN warehouses w ON ra.warehouse_id = w.warehouse_id
        ORDER BY 
            CASE ra.alert_status
                WHEN 'Open' THEN 1
                WHEN 'Ordered' THEN 2
                WHEN 'Resolved' THEN 3
            END
    """)
    restock = cursor.fetchall()


    cursor.execute("""
        SELECT 
            ew.watch_id,
            m.name AS medicine_name,
            w.name AS warehouse_name,
            w.city,
            ew.expiry_date,
            ew.days_to_expiry    
        FROM expiry_watchlist ew
        JOIN medicines m ON ew.medicine_id = m.medicine_id
        JOIN warehouses w ON ew.warehouse_id = w.warehouse_id
        ORDER BY ew.days_to_expiry ASC
    """)
    expiry = cursor.fetchall()

    cursor.close()
    conn.close()  

    return render_template('alerts.html', restock=restock, expiry=expiry)