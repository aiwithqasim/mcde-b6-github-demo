--Section 1 — Basic SELECT & Filtering

--1 list all product_name, model_year, list_price with there name 

select product_name, model_year, list_price from production.products


--2 Find all products whose price is greater than 1000.show product name and price
select product_name , list_price
from production.products
where list_price >1000;

--3 list all the customer from the state of new york
select first_name,last_name,state from sales.customers
where state  = 'NY';

--4 find all orders placed in the year 2017
select order_id ,order_date from sales.orders
WHERE order_date >= '20170101'
  AND order_date < '20180101';


--5 List all the products whose name contains the word 'trek'
select product_name  from production.products
WHERE product_name LIKE '%Trek%';


--6 find all products where price between 500 and 1500
select product_name,list_price from production.products
where list_price between 500 and 1500

--7  list all distict cities where customers are located
select DISTINCT city from sales.customers


--8 find all orders that have not shipped yet

 select order_id, shipped_date from sales.orders
 where  shipped_date is null
