-- ============================================
-- SECTION 1 — Basic SELECT & Filtering
-- ============================================

-- Task 1: List all products with name, model year, and price
SELECT product_name, model_year, list_price
FROM production.products;


-- Task 2: Products with price greater than 1000
SELECT product_name, list_price
FROM production.products
WHERE list_price > 1000;


-- Task 3: Customers from New York (NY)
SELECT *
FROM sales.customers
WHERE state = 'NY';


-- Task 4: Orders placed in 2017
SELECT *
FROM sales.orders
WHERE YEAR(order_date) = 2017;


-- Task 5: Products whose name contains 'Trek'
SELECT *
FROM production.products
WHERE product_name LIKE '%Trek%';


-- Task 6: Products priced between 500 and 1500
SELECT *
FROM production.products
WHERE list_price BETWEEN 500 AND 1500;


-- Task 7: Distinct cities where customers are located
SELECT DISTINCT city
FROM sales.customers;


-- Task 8: Orders that have not been shipped
SELECT *
FROM sales.orders
WHERE shipped_date IS NULL;