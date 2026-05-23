from flask import Flask, render_template
import mysql.connector
from config import DB_CONFIG
from routes.inventory import inventory_bp
from routes.suppliers import suppliers_bp
from routes.orders import orders_bp
from routes.alerts import alerts_bp

app = Flask(__name__)
app.register_blueprint(inventory_bp)
app.register_blueprint(suppliers_bp)
app.register_blueprint(orders_bp)
app.register_blueprint(alerts_bp)

@app.route('/')
def dashboard():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT COUNT(*) AS total FROM warehouses")
    warehouses = cursor.fetchone()['total']

    cursor.execute("SELECT COUNT(*) AS total FROM medicines")
    medicines = cursor.fetchone()['total']

    cursor.execute("SELECT COUNT(*) AS total FROM suppliers")
    suppliers = cursor.fetchone()['total']

    cursor.execute("SELECT COUNT(*) AS total FROM inventory")
    stock_items = cursor.fetchone()['total']

    cursor.execute("""
        SELECT COUNT(*) AS total FROM restock_alerts
        WHERE alert_status = 'open'
    """)
    open_alerts = cursor.fetchone()['total']

    cursor.execute("""
        SELECT COUNT(*) AS total FROM expiry_watchlist
        WHERE days_to_expiry <= 90
    """)

    expiring = cursor.fetchone()['total']

    cursor.close()
    conn.close()

    return render_template('dashboard.html',
                           warehouses=warehouses,
                           medicines=medicines,
                           suppliers=suppliers,
                           stock_items=stock_items,
                           open_alerts=open_alerts,
                           expiring=expiring
                           )
if __name__ == '__main__':
    app.run(debug=True)