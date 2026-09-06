use bikestores

--basic select and filtering--

select product_name, model_year, list_price
from production.products;

select product_name, list_price 
from production.products
where list_price > 1000;

select *
from sales.customers
where state = 'NY';

select *
from sales.orders
where order_date > = '2017-01-01'
 and order_date < '2018-01-01'

 select *
from production.products 
where PRODUCT_name like'%trek%';


