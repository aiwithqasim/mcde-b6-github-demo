use bikestores;

--TASK-1
SELECT
product_name,
model_year,
list_price
FROM production.products;

--TASK-2
SELECT 
product_name, 
list_price
FROM production.products
WHERE list_price > 1000;

--TASK-3
SELECT 
customer_id,
first_name,
last_name,
state
FROM sales.customers
WHERE state = 'NY';

--TASK-4
SELECT order_id, order_date
FROM sales.orders
WHERE order_date BETWEEN '2017-01-01' AND '2017-12-31';

--TASK-5
SELECT product_name FROM production.products
WHERE product_name LIKE 'Trek%';

--TASK-6
SELECT product_name, list_price
FROM production.products
WHERE list_price BETWEEN 500 AND 1500;

--TASK-7
SELECT DISTINCT customer_id ,city FROM sales.customers;

--TASK-8
SELECT order_id, shipped_date
FROM sales.orders
WHERE shipped_date IS NULL;
