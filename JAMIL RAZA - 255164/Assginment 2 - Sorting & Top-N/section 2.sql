-- SECTION 2 SORTING & TOP N

--- TASK 9

SELECT TOP 10 * FROM production.products
ORDER BY list_price DESC; 

--- TASK 10 

SELECT * FROM sales.customers
ORDER BY last_name ASC, first_name ASC;

--- TASK 11
SELECT TOP 5 *
FROM production.products
WHERE model_year = 2018
ORDER BY list_price ASC;
