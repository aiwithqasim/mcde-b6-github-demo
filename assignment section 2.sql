                                                              
                                                               (Section no 2)

--task 1

Select top 10
product_name, list_price
from production.products 
order by list_price desc

--task 2

Select
first_name, last_name
from sales.customers
order by last_name, first_name 

--task 3

Select top 5
product_name, list_price, model_year
from production.products
where model_year = 2018
order by list_price 

















