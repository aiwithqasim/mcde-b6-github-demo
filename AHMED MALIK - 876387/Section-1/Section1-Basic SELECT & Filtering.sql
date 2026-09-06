

-- Task 1 is Completed!! --

SELECT 
   product_name,
   model_year,
   list_price
FROM production.products;

---------------------------------

-- Task 2 is Completed!! --

SELECT
   product_name,
   list_price
FROM production.products
WHERE list_price > 1000;

----------------------------------

-- Task 3 is Completed!! --

SELECT
   *
FROM sales.customers
WHERE state = 'NY';

-----------------------------------

-- Task 4 is Completed!! --

SELECT
  *
FROM sales.orders 
WHERE YEAR(order_date) = 2017;

------------------------------------

-- Task 5 is Completed!! --

SELECT 
   product_name
FROM production.products
WHERE product_name LIKE 'Trek%';

------------------------------------

-- Task 6 is Completed!! --

SELECT
   list_price
FROM production.products
WHERE list_price BETWEEN 500 AND 1500;

--------------------------------------

-- Task 7 is Completed!! --

SELECT DISTINCT city
FROM sales.customers;

--------------------------------------

-- Task 8 is Completed!! --

SELECT 
   order_id,
   shipped_date
FROM sales.orders
WHERE shipped_date IS NULL;

---x----x----x----x---x----x----x----x----x----x----x---



