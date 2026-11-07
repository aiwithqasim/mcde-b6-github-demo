USE BikeStores;
-- SECTION 1 - Basic SELECT & FILTERING
--											✦✦✦ QUESTION 1 ✦✦✦
-- List all products with their name, model year, and list price.

SELECT 
	product_name,
	model_year,
	list_price
FROM production.products;

--											✦✦✦ QUESTION 2 ✦✦✦
-- Find all products whose list price is greater than 1000, show product name and price
SELECT 
	 product_name,
	 list_price
FROM production.products
WHERE list_price > 1000;

--											✦✦✦ QUESTION 3 ✦✦✦
-- List all customers from the state of NY
SELECT * FROM sales.customers
WHERE state = 'NY';

--											✦✦✦ QUESTION 4 ✦✦✦
--Find all orders place in the year 2017
SELECT * FROM sales.orders
WHERE order_date >= '2017-01-01' AND order_date < '2018-01-01';

--											✦✦✦ QUESTION 5 ✦✦✦
-- List all products whose name contains the word 'Trek'
SELECT * FROM production.products
WHERE product_name LIKE '%Trek%';

--											✦✦✦ QUESTION 6 ✦✦✦
-- Find all products priced between 500 and 1500
SELECT * FROM production.products
WHERE list_price BETWEEN 500 AND 1500;

--											✦✦✦ QUESTION 7 ✦✦✦
-- List all distinct cities where customers are located.
SELECT DISTINCT city FROM sales.customers;

--											✦✦✦ QUESTION 8 ✦✦✦
-- Find all orders that haven't been shipped yet
SELECT * FROM sales.orders
WHERE shipped_date is NULL;
