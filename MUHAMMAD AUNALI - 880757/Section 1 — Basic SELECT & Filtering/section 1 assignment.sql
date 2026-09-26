use BikeStores;

--task1
select product_name, model_year,list_price from production.products

--task2
select product_name,list_price from production.products where list_price > 1000;

--task3
select customer_id, first_name, state from sales.customers where state = 'NY';

--task4
select order_id, customer_id,order_date from sales.orders where YEAR(order_date) = 2017;
--task5
select product_name from production.products where product_name LIKE '%trek%'
--task6
select product_name,list_price from production.products where list_price between 500 and 1500;
--task7
select distinct city from sales.customers;
--task8
select order_id, order_status,shipped_date from sales.orders where shipped_date is NULL;

