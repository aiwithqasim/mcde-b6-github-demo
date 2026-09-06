use bikestores;

--Task 9:  List the top 10 most expensive products, sorted by price descending.

select top 10 *
from production.products
order by list_price desc;

--Task 10:  List all customers sorted by last name (A–Z), then first name (A–Z).

select *
from sales.customers
order by last_name asc, first_name asc;

--Task 11:  Find the 5 cheapest products that were produced in model year 2018.

select top 5 *
from production.products
where model_year = 2018
order by list_price asc;