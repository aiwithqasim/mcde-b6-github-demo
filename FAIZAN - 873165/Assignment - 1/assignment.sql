-- List all products with their name, model year, and list price.

select * from production.products

select brand_id,
* from production.products



select product_name,
*from production.products

select product_name as pn,
model_year as my,
list_price as lp
From production.products

--Task 2:  Find all products whose list price is greater than 1000. Show product name and price.
SELECT product_name, list_price
FROM production.products


SELECT product_name, list_price
FROM production.products
WHERE   list_price > 1000;

SELECT product_name,list_price
FROM production.products


--Task 3:  List all customers from the state of New York (NY).


SELECT
first_name
FROM sales.customers where state = 'NY'

--Task 4:  Find all orders placed in the year 2017.
select 
product_name

from production.products where model_year = 2017

--Task 5:  List products whose name contains the word 'Trek'.
SELECT product_name FROM production.products
WHERE product_name LIKE'Trek%';

--Task 6:  Find all products priced between 500 and 1500

SELECT list_price FROM production.products

where list_price  BETWEEN 500 AND 1500;

--Task 7:  List all distinct cities where customers are located.
select distinct city from sales.customers

--Task 8:  Find all orders that have NOT been shipped yet.
select order_status from sales.orders where order_status=4
