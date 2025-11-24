CREATE DATABASE ecommerce_system
USE ecommerce_system

CREATE TABLE inventory (
product_id INT PRIMARY KEY IDENTITY(1, 1),
product_name VARCHAR(100) NOT NULL,
quantity_available INT NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
last_updated DATETIME2 DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO inventory (product_name, quantity_available, unit_price) VALUES
('Laptop', 50, 999.99),
('Mouse', 200, 29.99),
('Keyboard', 150, 79.99),
('Monitor', 75, 299.99),
('Headphones', 100, 149.99);

CREATE PROCEDURE GetProductAvailabilityById
	@product_id int
AS
BEGIN
	select product_name, quantity_available from inventory where product_id = @product_id
END

CREATE TYPE ProductQuantityTableType AS TABLE (
	product_id int NULL,
	quantity int NULL
)

CREATE PROCEDURE UpdateInventory 
	@ProductQuantities ProductQuantityTableType READONLY
AS
BEGIN
	UPDATE inventory
	set quantity_available = quantity_available + pq.quantity
	from inventory i inner join @ProductQuantities pq on pq.product_id = i.product_id

	select 'Inventory updated' as [message], 'Success' as [status]
END