--task 9

 SELECT top 10 * FROM production.products 
ORDER BY list_price DESC;
-----ya---- 
 SELECT top 10 * FROM production.products 
ORDER BY list_price ASC;


 --task 10

SELECT * FROM sales.customers order by  first_name  ASC, last_name  ASC;

--task 11 
SELECT  top 5 * FROM production.products  WHERE model_year = 2018 
ORDER BY list_price ASC;
 
