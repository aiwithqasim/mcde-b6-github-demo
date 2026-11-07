-- Task 1
SELECT
    product_name,
    model_year,
    list_price
FROM production.products;


-- Task 2
SELECT
    product_name,
    list_price
FROM production.products
WHERE list_price > 1000;


-- Task 3
SELECT
    customer_id,
    first_name,
    last_name,
    city,
    state
FROM sales.customers
WHERE state = 'NY';


-- Task 4
SELECT
    order_id,
    customer_id,
    order_date,
    order_status
FROM sales.orders
WHERE YEAR(order_date) = 2017;


-- Task 5
SELECT
    product_id,
    product_name,
    list_price
FROM production.products
WHERE product_name LIKE '%Trek%';


-- Task 6
SELECT
    product_name,
    list_price
FROM production.products
WHERE list_price BETWEEN 500 AND 1500;


-- Task 7
SELECT DISTINCT city
FROM sales.customers;


-- Task 8
SELECT
    order_id,
    customer_id,
    order_date,
    shipped_date
FROM sales.orders
WHERE shipped_date IS NULL;
