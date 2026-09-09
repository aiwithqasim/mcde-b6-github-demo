--SECTION 2 SORTING & TOP-N
--TASK 9
-- List top 10 most expensive products sorted by price DESC

SELECT TOP 10 * FROM production.products
ORDER BY list_price DESC;

--TASK 10
--List all customers sorted by last name a-z then thier first name a-z

SELECT * FROM sales.customers
ORDER BY last_name ASC, first_name ASC;

--TASK 11
--Find the 5 cheapest products that were produced in model year 2018

SELECT TOP 5 product_id, product_name, model_year, list_price
FROM production.products
WHERE model_year = 2018
ORDER BY list_price ASC