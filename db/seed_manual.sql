use pharmatrack;
insert into warehouses (name, city, manager_name, contact_number, email, capacity) values
('Delhi Pharma Hub','Delhi','Rahul Sharma','9876543210','delhi@pharmatrack.com',10000),
('Mumbai Pharma Hub','Mumbai','Priya Mehta','9823456781','mumbai@pharmatrack.com',8000),
('Chennai Phax	rma Hub','Chennai','Arjun Nair','9712345678','chennai@pharmatrack.com',12000),
('Kolkata Pharma Hub','Kolkata','Sneha Das','9634567890','kolkata@pharmatrack.com',7000),
('Hyderabad Pharma Hub','Hyderabad','Imran Khan','9556789012','hyderabad@pharmatrack.com',9000)
;
select * from warehouses;


insert into medicines (name, brand, category, unit_price, reorder_level, shelf_life_days, requires_cold_storage) values
('Paracetamol','Calpol','Painkiller', 12.50, 100, 365, 0),
('Amoxicillin','Novamox','Antibiotic', 45.00, 60, 730, 0),
('Metformin','Glycomet','Diabetic', 30.00, 80, 548, 0),
('Vitamin D3','Calcirol','Vitamin',120.00, 50, 365, 0),
('Hepatitis B Vaccine','Engerix','Vaccine', 350.00, 20, 180, 1)
;
select * from medicines;

insert into suppliers (name, city, contact_number, email,rating, delivery_time_days) values
('Sun Pharma Supplies','Mumbai','9811122233','contact@sunpharma.com', 4.8, 2),
('Cipla Distributors','Delhi','9822233344','supply@cipla.com', 4.5, 3),
('MedPlus Wholesale','Chennai','9833344455','orders@medplus.com', 4.2, 4),
('Apollo Pharma Dist','Hyderabad','9844455566','dist@apollo.com', 4.7, 2),
('Generic Meds India','Kolkata','9855566677','info@genericmeds.com', 3.9, 5)
;
select * from suppliers;

insert into inventory (warehouse_id, medicine_id, quantity, batch_number, expiry_date) values
(1, 1, 200, 'BATCH-AA101','2026-12-01'),
(1, 2, 45,  'BATCH-BB202', '2027-06-15'),
(2, 3, 30,  'BATCH-CC303', '2026-09-20'),
(3, 4, 150, 'BATCH-DD404', '2026-08-10'),
(4, 5, 15,  'BATCH-EE505', '2026-03-30')
;
select * from inventory;

insert into  purchase_orders (supplier_id, medicine_id, warehouse_id, quantity, unit_cost, status, order_date, expected_delivery) 
VALUES
(1, 1, 1, 500, 10.00, 'Pending',   '2026-05-01', '2026-05-03'),
(2, 2, 1, 200, 40.00, 'Approved',  '2026-05-02', '2026-05-05'),
(3, 3, 2, 300, 28.00, 'Shipped',   '2026-05-03', '2026-05-07'),
(4, 4, 3, 100, 115.00,'Delivered', '2026-05-04', '2026-05-06'),
(5, 5, 4, 50,  340.00,'Cancelled', '2026-05-05', '2026-05-10')
;
select * from purchase_orders;

insert into stock_movements (inventory_id, movement_type, quantity, reference_type, notes) values
(1,'IN',500,'Purchase','Initial stock received'),
(1,'OUT',50,'Sale','Sold to retail customer'),
(2, 'OUT',30,'Sale','Hospital bulk order'),
(3,'IN',100,'Purchase','Restocked from supplier'),
(5,'OUT',10,'Sale','Vaccine sold to clinic')
;
select * from stock_movements;

insert into restock_alerts (warehouse_id, medicine_id, current_quantity, reorder_level, alert_status) values
(1, 2, 45, 60, 'Open'),
(2, 3, 30, 80, 'Open'),
(3, 5, 15, 20, 'Ordered'),
(4, 1, 90, 100, 'Resolved'),
(2, 4, 40, 50, 'Open')
;
 select * from restock_alerts;

insert into expiry_watchlist (inventory_id, medicine_id, warehouse_id, expiry_date, days_to_expiry) values
(5, 5, 4, '2026-03-30', 45),
(3, 3, 2, '2026-09-20', 60),
(4, 4, 3, '2026-08-10', 75),
(2, 2, 1, '2027-06-15', 88),
(1, 1, 1, '2026-12-01', 30)
 ;   
 select * from expiry_watchlist;