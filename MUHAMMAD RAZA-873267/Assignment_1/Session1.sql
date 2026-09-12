-- SECTION 1: BASIC SELECT & FILTERING

USE BikeStores;

-- TASK 1: List all products with their name, model year, and list price.

SELECT product_name, model_year, list_price
FROM production.products;

-- TASK 2: Find all products whose list price is greater than 1000. Show product name and price.

SELECT product_name, list_price
FROM production.products
WHERE list_price > 1000;

-- TASK 3: List all customers from the state of New York (NY).

SELECT first_name, last_name, city, state
FROM sales.customers
WHERE state = 'NY';

-- TASK 4: Find all orders placed in the year 2017.

SELECT order_id, order_date, customer_id
FROM sales.orders
WHERE YEAR(order_date) = 2017;

-- TASK 5: List products whose name contains the word 'Trek'.

SELECT product_name, list_price
FROM production.products
WHERE product_name LIKE '%Trek%';

-- TASK 6: Find all products priced between 500 and 1500.

SELECT product_name, list_price
FROM production.products
WHERE list_price BETWEEN 500 AND 1500;

-- TASK 7: List all distinct cities where customers are located.

SELECT DISTINCT city
FROM sales.customers
ORDER BY city;

-- TASK 8: Find all orders that have NOT been shipped yet.

SELECT order_id, order_date, shipped_date
FROM sales.orders
WHERE shipped_date IS NULL;

-- ==========================
-- END TASK
-- ==========================