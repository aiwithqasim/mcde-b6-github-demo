----Task 9:  List the top 10 most expensive products, sorted by price descending.
SELECT 
TOP 10 Product_name,
list_price
FROM production.products AS P
ORDER BY list_price  DESC;



---Task 10:  List all customers sorted by last name (A–Z), then first name (A–Z).
SELECT *
FROM sales.customers
ORDER BY last_name ASC, first_name ASC;

----Task 11:  Find the 5 cheapest products that were produced in model year 2018.

SELECT TOP 5 
product_name,
list_price 
FROM production.products AS P
WHERE model_year = 2018 
ORDER BY  list_price ASC;



