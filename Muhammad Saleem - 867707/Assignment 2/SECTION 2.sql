
--Section 2 — Sorting & Top-N

--Task 9: Top 10 most expensive products
SELECT TOP 10 product_id, product_name, list_price
FROM production.products
ORDER BY list_price DESC;


--Task 10: Customers sorted by last name then first name

SELECT  last_name, first_name
FROM sales.customers
ORDER BY last_name ASC, first_name ASC;


--Task 11: 5 cheapest products from model year 2018

SELECT TOP 5 product_id, product_name, list_price
FROM production.products
WHERE model_year = 2018
ORDER BY list_price ASC;

