--Task 1:  List all products with their name, model year, and list price.
select product_name,model_year, list_price
	from production.products;

--Task 2:  Find all products whose list price is greater than 1000. Show product name and price.
select product_name, list_price
	from production.products
	where list_price > 1000;

--Task 3:  List all customers from the state of New York (NY).
select *
from sales.customers
where state = 'NY';

--Task 4:  Find all orders placed in the year 2017.
--Hint: Use YEAR(order_date) or a date range filter.

select * 
from sales.orders
where order_date >='2017-01-01' and order_date <'2018-01-01';

--select * 
--from sales.orders
--where order_date   between '2017-01-01' and '2017-12-31';

--Task 5:  List products whose name contains the word 'Trek'.
--Hint: Use the LIKE operator with wildcards.
select * 
from production.products
where product_name like 'Trek%'; 

--Task 6:  Find all products priced between 500 and 1500.
--Hint: Use the BETWEEN operator.
select *
from production.products
where list_price  between '500' and '1500'  order by list_price Asc;

--Task 7:  List all distinct cities where customers are located.
--Hint: Use SELECT DISTINCT.
select count(distinct(city))
from sales.customers;

--Task 8:  Find all orders that have NOT been shipped yet.
--Hint: Filter where shipped_date IS NULL.

--select city, count(customer_id) as total_customer
--from sales.customers
--group by city;

select *
from sales.orders
where shipped_date is null;
