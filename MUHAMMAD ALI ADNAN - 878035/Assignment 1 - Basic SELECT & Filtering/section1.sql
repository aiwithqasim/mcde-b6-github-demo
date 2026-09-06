--Section 1 — Basic SELECT & Filtering

--task 1
select 
product_name ,
list_price,
model_year
from [production].[products] 

--task 2
select 
product_name,
list_price
from [production].[products]
where list_price > 1000
order by list_price  asc

--task 3
select 
first_name,
last_name,
state 
from [sales].[customers]
where state= 'NY'

--task 4 
SELECT order_id, order_date
FROM sales.orders
WHERE YEAR(order_date) = 2017;

--task 5 
SELECT product_name
FROM [production].[products]
where product_name like '%trek%'

--task 6 
select 
product_name,
list_price
from [production].[products]
where list_price between 500 and 1500 order by list_price asc;

--task 7
select 
distinct city
from [sales].[customers]

--task 8
select 
order_date,
order_id,
shipped_date
from sales.orders
where shipped_date IS NULL
order by order_date asc

