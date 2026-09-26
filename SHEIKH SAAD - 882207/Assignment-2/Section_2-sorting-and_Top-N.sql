--TASK-9 
SELECT TOP 10 product_name, list_price
FROM production.products
ORDER BY list_price DESC;

--TASK-10
SELECT last_name, first_name
FROM sales.customers
ORDER BY last_name ASC,  first_name ASC;

--TASK-11
SELECT TOP (5)
	product_id,
	product_name,
	model_year,
	list_price
FROM production.products
WHERE model_year = 2018
ORDER BY list_price ASC;