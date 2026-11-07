--TASK9
 SELECT top 10 * FROM production.products ORDER BY list_price ASC;
 SELECT top 10 * FROM production.products ORDER BY list_price DESC;

 --TASK10
 SELECT * FROM sales.customers ORDER BY first_name ASC , last_name ASC;
 SELECT * FROM sales.customers ORDER BY first_name DESC , last_name DESC;

 SELECT * FROM sales.customers ORDER BY last_name ASC , first_name ASC;
 SELECT * FROM sales.customers ORDER BY last_name DESC , first_name DESC;

 --TASK11

 SELECT * FROM production.products;

 SELECT * FROM production.products WHERE model_year = 2018

 SELECT top 5 * FROM production.products WHERE model_year = 2018 ORDER BY list_price ASC