Use bikestores;

--TASK 1

SELECT * FROM production.products;

--TASK2
 
SELECT * FROM production.products Where list_price < 1000;

--Task3

SELECT * FROM sales.customers;

SELECT * FROM sales.customers WHERE State = 'NY';

--TASK4
SELECT * FROM sales.orders;
SELECT * FROM sales.orders WHERE Year (order_date) = 2017

--TASK5
SELECT * FROM production.products WHERE product_name LIKE '%TREK%'

--TASK6

SELECT * FROM production.products WHERE list_price between 500 and 1500

--TASK7

SELECT DISTINCT city FROM sales.customers;

--TASK8

 SELECT * FROM sales.orders;

 SELECT * FROM sales.orders WHERE shipped_date is NULL


