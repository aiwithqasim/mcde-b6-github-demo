Use BikeStore
-------QUERY------

------ TASK 1--------

SELECT * FROM production.products;

------TASK 2---------

 SELECT* FROM sales.customers
where customer_id > 100;

------ TASK 3-----------

SELECT * FROM sales.customers where state = 'NY'

-----TASK 4---------

SELECT * FROM  sales.orders WHERE YEAR(order_date) = 2017

----TASK 6-----------

SELECT * FROM sales.order_items WHERE list_price BETWEEN '500' and '1500'

---------- TASK 7-------

SELECT * FROM sales.stores SELECT_DISTINCT ;

------------TASK 8 --------
SELECT *FROM sales.orders	WHERE shipped_date IS NULL
--------- 5 NOT DONE YET-------




