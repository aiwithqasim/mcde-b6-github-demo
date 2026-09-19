-- SECTION 02:

--Task 9:  List the top 10 most expensive products, sorted by price descending.
SELECT TOP 10
list_price
FROM production.products
ORDER BY list_price DESC;

--Task 10:  List all customers sorted by last name (A–Z), then first name (A–Z).
SELECT last_name,
first_name
FROM sales.customers
WHERE first_name LIKE 'A%Z' AND
last_name LIKE 'A%Z'

--Task 11:  Find the 5 cheapest products that were produced in model year 2018.
SELECT TOP 5
product_name,
list_price
FROM production.products
WHERE model_year = 2018
ORDER BY list_price asc;















