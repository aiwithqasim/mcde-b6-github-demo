--Section 1 — Basic SELECT & Filtering 
--task 01
select product_name,model_year,list_price
from production.products;
--task 02
select product_name,list_price 
from production.products 
where list_price > 1000
--task 03
select *
from sales.customers
where state='NY'
--task04
select *
from sales.orders
where year(order_date)=2017
--task05
select product_name
from [production].[products]
where product_name like 'Trek%';
--task06
select *
from production.products
where list_price between 500 and 1500;
--task07
select distinct city
from sales.customers
--task08
select order_id,shipped_date
from sales.orders
where shipped_date is null;


