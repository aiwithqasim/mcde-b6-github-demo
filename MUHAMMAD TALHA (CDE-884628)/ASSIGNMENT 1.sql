-- Assignment: Basic SELECT & Filtering
-- Student: Muhammad Talha
-- Saylani ID: [CDE-884628]

-------------------------------------------------
-- TASK 1: Show product name, model year, and price
-------------------------------------------------
SELECT product_name, model_year, list_price
FROM production.products;

-------------------------------------------------
-- TASK 2: Show products with price greater than 1000
-------------------------------------------------
SELECT product_name, list_price
FROM production.products
WHERE list_price > 1000;

-------------------------------------------------
-- TASK 3: Show customers from New York (NY)
-------------------------------------------------
SELECT * 
FROM sales.customers
WHERE state = 'NY';

-------------------------------------------------
-- TASK 4: Show orders placed in year 2017
-------------------------------------------------
SELECT *
FROM sales.orders
WHERE YEAR(order_date) = 2017;

-------------------------------------------------
-- TASK 5: Show products containing 'Trek' in name
-------------------------------------------------
SELECT *
FROM production.products
WHERE product_name LIKE '%Trek%';

-------------------------------------------------
-- TASK 6: Show products with price between 500 and 1500
-------------------------------------------------
SELECT *
FROM production.products
WHERE list_price BETWEEN 500 AND 1500;

-------------------------------------------------
-- TASK 7: Show distinct cities of customers
-------------------------------------------------
SELECT DISTINCT city
FROM sales.customers;

-------------------------------------------------
-- TASK 8: Show orders not yet shipped
-------------------------------------------------
SELECT *
FROM sales.orders
WHERE shipped_date IS NULL;
