--Section 2 — Sorting & Top-N

--task 9
select top 10 
product_name,
list_price
from [production].[products]
order by list_price desc

--task 10
select
first_name,
last_name
from [sales].[customers]
order by last_name asc, first_name asc

--task 11
select top 5
product_name,
list_price,
model_year
from [production].[products]
where model_year= 2018
order by list_price asc