USE BikeStores;
GO
--------------------------TASK 1--------------------------
SELECT * FROM production.products;

-------------------------------TASK 2 ---------------------------
SELECT product_name, list_price FROM production.products
WHERE list_price < 1000;

--------------------TASK 3---------------------------
SELECT * FROM sales.customers
WHERE state = 'NY';

---------------------TASK 4 --------------------------
SELECT * FROM sales.orders
WHERE order_date >= '2017-01-01' AND order_date < '2027-12-30';


----------------TASK 5---------------------------------
SELECT * FROM production.products
where product_name like '%Trek%';

------------------TASK 6-----------------------
SELECT * FROM production.products
WHERE list_price BETWEEN 500 AND 1000;

---------------------- TASK 7----------------------------
select distinct city 
from sales.customers

--------------------TASK 8--------------------------------------

select * from sales.orders
where shipped_date is null;


--------------------SECTION 2-----------------
-----------------TASK 1-------------------------
select top 10 * from production.products 
order by list_price desc 

--------------------------TASK 2--------------------
SELECT last_name, first_name FROM sales.staffs
order by last_name, first_name asc


-------------------TASK 3 --------------------------
SELECT top 5 * 
FROM production.products 
WHERE model_year = '2018'
order by list_price asc;




