						-----SECTION 1-----  
	
--TASK  1;

SELECT product_name, model_year, list_price
FROM production.products

--TASK 2;

SELECT product_name, list_price
FROM production.products
WHERE list_price > 1000

--TASK 3;

SELECT first_name, last_name, state
FROM sales.customers
WHERE state = 'NY' 

--TASK 4;

SELECT order_id, customer_id, order_date
FROM sales.orders
where order_date >= '2017-01-01' and 
order_date < '2018-01-01'

--TASK 5;

SELECT product_name
FROM production.products
WHERE product_name LIKE 'TREK%'

--TASK 6;
SELECT product_name, list_price
FROM production.products
WHERE list_price BETWEEN 500 and 1500

--TASK 7;
SELECT DISTINCT city
FROM sales.customers

--TASK 8;

SELECT order_id, customer_id, shipped_date 
FROM sales.orders
WHERE shipped_date is null


