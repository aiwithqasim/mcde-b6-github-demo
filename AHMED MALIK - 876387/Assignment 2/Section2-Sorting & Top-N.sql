

-- Task 9 is Completed!! --

SELECT TOP 10
     product_name,
     list_price
FROM production.products
ORDER  BY list_price DESC;

----------------------------------

-- Task 10 is Completed!! --

SELECT 
   *
FROM sales.customers
ORDER BY last_name ASC,first_name ASC;

--------------------------------------

-- Task 11 is Completed!! --

SELECT TOP 5
   product_name,
   model_year,
   list_price
FROM production.products
WHERE model_year = 2018
ORDER BY list_price ASC;

---x------x-----x-----x--------x-----------x--------x------
