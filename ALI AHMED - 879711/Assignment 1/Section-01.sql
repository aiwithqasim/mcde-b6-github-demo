-- Section 1 — Basic SELECT & Filtering --

USE Bikestore;

-- Q1 : List all products with their name, model, year, and list price

SELECT product_name, model_year, list_price FROM production.products;


-- Q2 : Find all products whose list price is greater than 1000. Show product name and price.

SELECT product_name, list_price FROM production.products
WHERE list_price > 1000;

-- Q3 : List all customers from the state of New York (NY).

SELECT * FROM sales.customers WHERE state = 'NY';

-- Q4 : Find all orders placed in the year 2017.
-- Hint: Use YEAR(order_date) or a date range filter.

SELECT * FROM sales.orders WHERE YEAR(order_date) = 2017;

-- Q5 : List products whose name contains the word "Trek".
-- Hint: Use the LIKE operator with wildcards.

SELECT product_name FROM production.products
WHERE product_name LIKE 'Trek%';

-- Q6 : Find all products price between 500 and 1500.
-- Hint: Use the BETWEEN operator.

SELECT product_name, list_price FROM production.products
WHERE list_price BETWEEN 500 AND 1500;


-- Q7 : List all distinct cities where customers are located
-- Hint: Use SELECT DISTINCT

SELECT DISTINCT first_name, last_name, city FROM sales.customers;

-- Q8 : Find all orders that have NOT been shipped yet
-- Hint : Filter where shipped_date is NULL.

SELECT * FROM sales.orders
WHERE shipped_date IS NULL;