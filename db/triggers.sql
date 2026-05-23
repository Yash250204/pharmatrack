use pharmatrack;

-- trigger 1 Auto restock alert when stock falls low
DELIMITER $$
create trigger low_stock_alert
after update on inventory
for each row
begin
	if new.quantity < (select reorder_level from medicines
						where medicine_id = new.medicine_id)
	then 
		insert into restock_alerts
			(warehouse_id, medicine_id, current_quantity, reorder_level)
		values
			(new.warehouse_id, new.medicine_id, new.quantity,(select reorder_level from medicines
																		where medicine_id = new.medicine_id));
                                                                        
	end if;
end$$

Delimiter ;

update inventory set quantity = 20 where inventory_id = 1;
select * from restock_alerts;

show triggers from pharmatrack;

-- Trigger 2 Auto log every stock change
delimiter $$
create trigger log_stock_movement
after update on inventory
for each row
begin
	if new.quantity != old.quantity then 
		insert into stock_movements
			(inventory_id, movement_type, quantity, reference_type, notes)
		values(
			new.inventory_id, 
			if(new.quantity > old.quantity, 'In', 'Out'),
			abs(new.quantity - old.quantity),
			if(new.quantity > old.quantity, 'Purchase', 'Sale'),
			concat('auto-logged:', old.quantity, '-->', new.quantity)
		);
	end if;
end$$

delimiter ;

update inventory set quantity = 300 where inventory_id = 2;
update inventory set quantity = 10 where inventory_id = 2;
select * from stock_movements;


-- trigger3 Flag medicine expiring within 90 days
delimiter $$
create trigger flag_medicine_expiring
after insert on inventory 
for each row 
begin
	if datediff(new.expiry_date, curdate()) <= 90 then
		insert into expiry_watchlist (inventory_id, medicine_id, warehouse_id, expiry_date, days_to_expiry)
        values(
			new. inventory_id,
            new.medicine_id,
            new.warehouse_id,
            new.expiry_date,
            datediff(new.expiry_date, curdate())
		);
	end if;
end$$
delimiter ;

insert into inventory (warehouse_id, medicine_id, quantity, batch_number, expiry_date)
values (1, 1, 100, 'BATCH-TEST01', '2026-07-15');

insert into inventory (warehouse_id, medicine_id, quantity, batch_number, expiry_date)
values (1, 2, 100, 'BATCH-TEST02', '2028-01-01');

select * from expiry_watchlist;

-- Trigger 4: Mark alert as Ordered when Purchase_Order is placed
DELIMITER $$

CREATE TRIGGER resolve_alert_on_order
AFTER INSERT ON purchase_orders
FOR EACH ROW
BEGIN
    UPDATE restock_alerts
    SET alert_status = 'Ordered'
    WHERE medicine_id  = NEW.medicine_id
    AND   warehouse_id = NEW.warehouse_id
    AND   alert_status = 'Open';
END$$

DELIMITER ;
INSERT INTO purchase_orders
(supplier_id, medicine_id, warehouse_id,
 quantity, unit_cost, expected_delivery)
VALUES (1, 2, 1, 200, 40.00, '2026-06-01');

SELECT * FROM restock_alerts;




