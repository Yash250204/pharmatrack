CREATE database PharmaTrack;
use pharmatrack;
create table warehouses(
	warehouse_id int auto_increment primary key,
    name varchar(100) not null,
    city varchar(50),
    manager_name varchar(100),
    contact_number int,
    email varchar(100),
    capacity int
);

create table medicines (
	medicine_id int auto_increment primary key,
    name varchar(150) not null,
    brand varchar(100),
    category ENUM('Antibiotic','Painkiller','Vitamin','Vaccine','Cardiac','Diabetic','General'),
    unit_price decimal(10,2),
    reorder_level int default 50,
    shelf_life_days int,
    requires_cold_storage boolean default false
);

create table suppliers(
	supplier_id int auto_increment primary key,
    name varchar(150) not null,
    city varchar(50),
    contact_number int,
    email varchar(100),
    rating decimal(2,1) default 5.0,
    delivery_time_days int default 3
    );
    
create table inventory(
	inventory_id int auto_increment primary key,
    warehouse_id int,
    medicine_id int,
    quantity int default 0,
    batch_number varchar(50),
    expiry_date date,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    foreign key ( warehouse_id) references warehouses(warehouse_id),
    foreign key ( medicine_id) references medicines(medicine_id)
    );
    
create table purchase_orders(
	order_id int auto_increment primary key,
	supplier_id int,
    medicine_id int,
    warehouse_id int,
	quantity int,
    unit_cost decimal(10,2),
    total_cost decimal(12,2) generated always as (quantity * unit_cost) stored,
    status enum('Pending','Approved','Shipped','Delivered','Cancelled') DEFAULT 'Pending',
    order_date timestamp default current_timestamp,
	expected_delivery date,
    foreign key (supplier_id) references suppliers(supplier_id),
	foreign key (medicine_id) references medicines(medicine_id),
    foreign key (warehouse_id) references warehouses(warehouse_id)
    );
    
create table stock_movements(
	movement_id int auto_increment primary key,
    inventory_id int,
    movement_type enum('IN','OUT','TRANSFER','ADJUSTMENT'),
    quantity INT,
    reference_type ENUM('Purchase','Sale','Transfer','Damage'),
    moved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id)
);

CREATE TABLE restock_alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_id INT,
    medicine_id INT,
    current_quantity INT,
    reorder_level INT,
    alert_status ENUM('Open','Ordered','Resolved') DEFAULT 'Open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
    FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id)
);

CREATE TABLE expiry_watchlist (
    watch_id INT AUTO_INCREMENT PRIMARY KEY,
    inventory_id INT,
    medicine_id INT,
    warehouse_id INT,
    expiry_date DATE,
    days_to_expiry INT,
    flagged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id)
);

alter table warehouses modify contact_number varchar(15);
alter table suppliers modify contact_number varchar(15);


 
 
 