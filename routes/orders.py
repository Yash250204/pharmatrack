from flask import Blueprint, render_template
import mysql.connector
from config import DB_CONFIG

orders_bp = Blueprint('orders', __name__)

@orders_bp.route('/orders')
def orders():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            po.order_id,
            s.name AS supplier_name,
            m.name AS medicine_name,
            w.name AS warehouse_name,
            po.quantity,
            po.total_cost,
            PO.status,  
            po.order_date,
            po.expected_delivery
        FROM purchase_orders po
        JOIN suppliers s ON po.supplier_id = s.supplier_id
        JOIN medicines m ON po.medicine_id = m.medicine_id
        JOIN warehouses w ON po.warehouse_id = w.warehouse_id
        ORDER BY po.order_date DESC
    """)

    orders_list = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('orders.html', orders=orders_list)