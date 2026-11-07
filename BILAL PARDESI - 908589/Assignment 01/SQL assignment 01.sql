-- Section 1 — Basic SELECT & Filtering

-- Task 1
SELECT product_name, model_year, list_price
FROM production.products;

-- Task 2
SELECT product_name, list_price
FROM production.products
WHERE list_price > 1000;

-- Task 3
SELECT *
FROM sales.customers
WHERE state = 'NY';

-- Task 4
SELECT *
FROM sales.orders
WHERE YEAR(order_date) = 2017;

-- Task 5
SELECT *
FROM production.products
WHERE product_name LIKE '%Trek%';

-- Task 6
SELECT *
FROM production.products
WHERE list_price BETWEEN 500 AND 1500;

-- Task 7
SELECT DISTINCT city
FROM sales.customers;

-- Task 8
SELECT *
FROM sales.orders
WHERE shipped_date IS NULL;