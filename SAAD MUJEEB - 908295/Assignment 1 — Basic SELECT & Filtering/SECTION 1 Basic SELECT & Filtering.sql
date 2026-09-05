-- ASSIGNMENT
-- ==========
use BikeStores;
--TASK 1
--------

select product_name, model_year, list_price
from production.products;

--TASK 2
--------

SELECT product_name, list_price from production.products
where list_price > 1000;

--TASK 3
--------

select * from sales.customers
where state = 'NY';

--TASK 4
---------

select * from sales.orders
where year(order_date) = 2017

--TASK 5
--------

select * from production.products
where product_name like '%trek%';

--TASK 6
--------

SELECT * from production.products
where list_price between 500 and 1500;

--TASK 7
--------

SELECT DISTINCT city from sales.customers;


--TASK 8
--------

select * from sales.orders
where shipped_date is null;

