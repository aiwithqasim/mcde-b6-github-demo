use bikestores;

-- TASK 1

SELECT *FROM production.products;
 
 --TASK 2 

 SELECT * FROM production.products where list_price  >= 1000; 

 --Task3
 
 SELECT * FROM sales.customers where state = 'NY';
 --Task 4
  

 SELECT * FROM sales.orders where YEAR(order_date) =2017;
--TASK 5 

SELECT * FROM production.products where  product_name LIKE '%TREK%';

--TASK 6

SELECT *FROM production.products WHERE  list_price  BETWEEN 500 AND 1500;

--TASK 7

SELECT DISTINCT city from  sales.customers order by  'city' asc;


--Task 8 

SELECT * FROM  sales.orders  where shipped_date is null;