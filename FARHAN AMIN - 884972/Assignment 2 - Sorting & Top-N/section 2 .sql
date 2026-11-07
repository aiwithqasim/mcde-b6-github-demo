--Task 9: List the top 10 most expensive products, sorted by price descending
use BikeStores;
go
select TOP 10 product_name, list_price
from production.products
order by list_price DESC;

--Task 10: List all customers sorted by last name (A-Z), then first name (A-Z)
use BikeStores;
go
select last_name, first_name

from sales.customers
order by last_name ASC, first_name ASC;

--Task 11: Find the 5 cheapest products that were produced in model year 2018
use BikeStores;
go

select TOP 5 product_name, list_price, model_year

from production.products
where model_year = '2018'
order by list_price ASC;


