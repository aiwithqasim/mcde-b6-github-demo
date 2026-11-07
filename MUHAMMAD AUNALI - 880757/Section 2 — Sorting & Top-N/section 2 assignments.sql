use BikeStores

--task9
select top 10 list_price from production.products order by list_price desc

--task10
select first_name, last_name from sales.customers order by last_name;
select first_name, last_name from sales.customers order by first_name;

--task 11
select top 5 product_name, list_price from production.products where model_year = 2018 order by list_price asc;



