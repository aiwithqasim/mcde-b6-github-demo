                                
                                                     --(Section no 1)
--Task 1

Select 
product_name, list_price, model_year
from production.products

--task 2

Select
product_name, list_price
from production.products
where list_price > 1000

--task 3

select
first_name,last_name, customer_id, state
from sales.customers
where state = 'ny'

--task 4

select 
Order_id
from sales.orders
where year (order_date) = '2017'

--task 5

Select
product_name
From production.products
where product_name like 'trek%' 

--task 6

Select
product_name, list_price
from production.products
where list_price between 500 and 1500

--task 7

select distinct city
from sales.customers

--task 8

select 
order_id, shipped_date
from sales.orders
where shipped_date is null
































