---SECTION 1 - BASIC SELECT & FILTERING
--TASK 1
--List all products with thier name, model year, and list price

SELECT product_name, model_year, list_price FROM production.products;

--TASK 2
--Find all product whose list price greater than 1000. show product name and price

SELECT product_name, list_price From production.products
WHERE list_price >= 1000;

--TASK 3
--List all the customers from the state of new york (NY)

SELECT * FROM sales.customers WHERE state = 'NY';

--TASK 4
--Find all order placed in the year of 2017

SELECT *
FROM sales.orders
WHERE order_date >= '2017-01-01' 
  AND order_date < '2018-01-01';

--TASK 5 
--List all product whose name contains the word trek

SELECT *, product_name FROM production.products
WHERE (product_name) LIKE '%Trek%';

--TASK 6
--Find all product priced between 500 and 1500

SELECt * 
FROM production.products
WHERE list_price >= 500
  AND list_price <= 1500;

--TASK 7
--List all distintct cities where customers are located

SELECT DISTINCT city 
FROM sales.customers;

--TASK 8
--Find all orders that have not been shipped yet

SELECT * FROM sales.orders
WHERE shipped_date IS NULL;


