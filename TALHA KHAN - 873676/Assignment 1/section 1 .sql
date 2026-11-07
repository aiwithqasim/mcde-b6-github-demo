USE BikeStores;
GO

SELECT 
    p.product_id,
    p.product_name,
    c.category_id,
    c.category_name
FROM production.products AS p
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id
WHERE p.product_id = 1;

 --Task 1: List all products with their name, model year, and list price.
SELECT
    product_name,
    model_year,
    list_price
FROM production.products;

-- Task 2: Find all products whose list price is greater than 1000. Show product name and price.
SELECT
    product_name,
    list_price
FROM production.products
WHERE list_price > 1000;


-- Task 3: List all customers from the state of New York.
SELECT *
FROM sales.customers
WHERE state = 'NY';
 

 -- Task 4: Find all orders placed in the year 2017.
SELECT *
FROM sales.orders
WHERE YEAR(order_date) = 2017;

-- Task 5: List products whose name contains the word 'Trek'.
SELECT
    product_name
FROM production.products
WHERE product_name LIKE '%Trek%';

-- Task 6: Find all products priced between 500 and 1500.
SELECT
    product_name,
    list_price
FROM production.products
WHERE list_price BETWEEN 500 AND 1500;


-- Task 7: List all distinct cities where customers are located.
SELECT DISTINCT city
FROM sales.customers;

-- Task 8: Find all orders that have NOT been shipped yet.
SELECT *
FROM sales.orders
WHERE shipped_date IS NULL;