--Task 1: List all products with their name, model year and list price
use BikeStores
go
select 
product_name, model_year, list_price
from production.products;

--Task 2: Find all products whose list price is greater than 1000. 
--show product name and price
use BikeStores;
go
select 
product_name, list_price
from production.products
where list_price > 1000;

--Task 3: List all customers from the state of New York (NY)
use BikeStores;
go
select 

(first_name + ' ' + last_name) AS [customer name], state

from sales.customers
where state = 'NY';

--Task 4: Find all orders placed in the year 2017
--Hint: Use YEAR(order_date) or a date range filter
use BikeStores;
go
select order_id, customer_id, order_date, order_status
from sales.orders
where YEAR (order_date) = '2017';

--Task 5: List products whose name contains the word 'Trek'
--Hint: Use the LIKE operator with wildcards
use BikeStores;
go

select
*
from production.products
where product_name LIKE '%Trek%';

--Task 6: Find all products priced between 500 and 1500
--Hint: Use the BETWEEN operator
use BikeStores;
go
select *
from production.products
where list_price BETWEEN '500' AND '1500';

--Task 7: List all distinct cities where customers are located
--Hint: Use SELECT DISTINCT
use BikeStores;
go
select distinct city
from sales.customers;


--Task 8: Find all the orders that have NOT been shipped yet
--Hint: Filter where shiped_date is NULL
use BikeStores;
go
select *
from sales.orders
where shipped_date is NULL;


