--TASK 1 :
SELECT 
	product_name,
	model_year,
	list_price
FROM production.products;


--TASK 2 :
SELECT 
	product_name,
	list_price
FROM production.products
WHERE list_price > 1000;




--TASK 3 :
SELECT *
FROM sales.customers
WHERE state = 'NY';


--TASK 4 ;
SELECT *
FROM sales.orders
WHERE order_date BETWEEN '2017-1-1' AND '2017-12-30';


--TASK 5 ;
SELECT *
FROM production.products
WHERE product_name LIKE 'Trek%';


--TASK 6 ;
SELECT *
FROM production.products
WHERE list_price BETWEEN 500 AND 1500;




--TASK 7 ;
SELECT DISTINCT city 
FROM sales.customers;



--TASK 8 ;
SELECT *
FROM sales.orders
WHERE shipped_date is NULL;