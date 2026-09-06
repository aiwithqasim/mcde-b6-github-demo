						-----SECTION 2-----  

--TASK 1;

SELECT TOP 10 product_name, list_price
FROM production.products
ORDER BY list_PRICE DESC


--TASK 2;

SELECT first_name, last_name
FROM sales.customers
ORDER BY last_name, first_name


--TASK 3;
SELECT top 5 product_name, list_price, model_year
FROM production.products
WHERE model_year = 2018
ORDER BY list_price
