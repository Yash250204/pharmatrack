import mysql.connector
from faker import Faker
import random
from datetime import date, timedelta
import sys
sys.path.append('.')
from config import DB_CONFIG


fake = Faker()
conn = mysql.connector.connect(**DB_CONFIG)
cursor = conn.cursor()

# Seed Warehouses
cities = ["Delhi", "Mumbai", "Chennai", "Kolkata", "Hyderabad"]
for city in cities:
    cursor.execute("""INSERT INTO warehouses
                   (name, city, manager_name, contact_number, capacity)
                   VALUES (%s,%s,%s,%s,%s)""",
                   (f"{city} Pharma Hub", city,
                    fake.name(),
                    fake.numerify('9#########'),
                    10000))
conn.commit()
print("✅ Warehouses seeded!")

# Seed Medicines
medicines = [
    ("Paracetamol","Calpol","Painkiller",12.50,100,365),
    ("Amoxicillin","Novamox","Antibiotic",45.00,60,730),
    ("Metformin","Glycomet","Diabetic",30.00,80,548),
    ("Atorvastatin","Lipitor","Cardiac",85.00,40,730),
    ("Vitamin D3","Calcirol","Vitamin",120.00,50,365),
    ("Azithromycin","Zithromax","Antibiotic",95.00,30,548),
    ("Omeprazole","Prilosec","General",25.00,70,365),
    ("Cetirizine","Zyrtec","General",18.00,90,548),
]
for m in medicines:
    cursor.execute("""INSERT INTO medicines
                   (name,brand,category,unit_price,
                   reorder_level,shelf_life_days)
                   VALUES (%s,%s,%s,%s,%s,%s)""", m)
conn.commit()
print("✅ Medicines seeded!")

# Seed Suppliers
for _ in range(10):
    cursor.execute("""INSERT INTO suppliers
                   (name, city, contact_number, 
                   email, rating, delivery_time_days)
                   VALUES (%s,%s,%s,%s,%s,%s)""",
                   (fake.company(),
                    random.choice(cities),
                    fake.numerify('9#########'),
                    fake.email(),
                    round(random.uniform(3.0, 5.0), 1),
                    random.randint(2, 7)))
conn.commit()
print("✅ Suppliers seeded!")

# Seed Inventory
cursor.execute("SELECT warehouse_id FROM warehouses")
wids = [r[0] for r in cursor.fetchall()]
cursor.execute("SELECT medicine_id FROM medicines")
mids = [r[0] for r in cursor.fetchall()]

for wid in wids:
    for mid in mids:
        expiry = date.today() + timedelta(
            days=random.randint(30, 730))
        cursor.execute("""INSERT INTO inventory
                       (warehouse_id, medicine_id, quantity,
                       batch_number, expiry_date)
                       VALUES (%s,%s,%s,%s,%s)""",
                       (wid, mid,
                        random.randint(10, 500),
                        fake.bothify('BATCH-??###'),
                        expiry))
conn.commit()
print("✅ Inventory seeded!")

cursor.close()
conn.close()
print("✅ Database seeded successfully!")