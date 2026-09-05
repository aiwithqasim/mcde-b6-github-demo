-- Section 2 — Sorting & Top-N
use BikeStores;
Go

--Task 9:  List the top 10 most expensive products,
-- sorted by price descending.

select top 10 product_name, list_price
from production.products
order by list_price desc;

--Cheaper
select top 10 product_name, list_price
from production.products
order by list_price asc;

-- Task 10:  List all customers sorted by last name (A–Z),
-- then first name (A–Z).


select * from sales.customers
order by last_name, first_name;

--Task 11:  Find the 5 cheapest products that were produced in model year 2018.

select top 5 *
from production.products
where model_year = 2018
order by list_price asc;


