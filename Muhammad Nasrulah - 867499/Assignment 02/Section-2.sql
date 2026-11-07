--Section 2 — Sorting & Top-N

--Task 9:  List the top 10 most expensive products, sorted by price descending.
SELECT top 10 list_price
from production.products
order by list_price desc;


--Task 10:  List all customers sorted by last name (A–Z), then first name (A–Z).
SELECT 
customer_id,first_name,last_name
FROM sales.customers
ORDER BY last_name ASC ,first_name ASC;

--Task 11:  Find the 5 cheapest products that were produced in model year 2018.
select top 5 
product_name,
model_year,
list_price
from production.products
WHERE model_year =2018
order by list_price ASC