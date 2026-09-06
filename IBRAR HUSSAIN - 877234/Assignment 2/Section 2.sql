 use bikestores;

--Task 9:
SELECT TOP 10 *
FROM production.products
ORDER BY list_price DESC;


--Task 10:

SELECT *
FROM sales.customers
ORDER BY last_name ASC, first_name ASC;



--Task 11:

SELECT TOP 5 *
FROM production.products
WHERE model_year = 2018
ORDER BY list_price ASC;
