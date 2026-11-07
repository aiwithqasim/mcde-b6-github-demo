
SELECT product_name, model_year, list_price
FROM production.products;



SELECT product_name, list_price
FROM production.products
WHERE list_price > 1000;


SELECT *
FROM sales.customers
WHERE state = 'NY';


SELECT *
FROM sales.orders
WHERE YEAR(order_date) = 2017;


SELECT *
FROM production.products
WHERE product_name LIKE '%Trek%';


SELECT product_name, list_price
FROM production.products
WHERE list_price BETWEEN 500 AND 1500;


SELECT DISTINCT city
FROM sales.customers;


SELECT *
FROM sales.orders
WHERE shipped_date IS NULL;

