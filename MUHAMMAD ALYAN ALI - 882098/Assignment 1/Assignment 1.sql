--ASSIGNMENT 1 SECTION 1 (SQL) ------------------------------

--Task 1: list all products with their name, model year, and list price.

SELECT product_name , model_year , list_price
FROM production.products;

--Task 2: Find all products whose list price is greater than 1000. Show product name and price.

SELECT product_name , list_price
FROM production.products
WHERE list_price > 1000 ;

--Task 3: list all customers from the state of new york (NY)

SELECT *
FROM sales.customers
WHERE state = 'NY' ;

--Task 4: Find all orders placed in the year 2017.

SELECT *
FROM sales.orders
WHERE year(order_date) = 2017;

--Task 5: list products whose name contains the word 'TREK'

SELECT *
FROM production.products
WHERE product_name LIKE '%Trek%'

--Task 6: Find all products priced between 500 And 1500

SELECT *
FROM production.products
WHERE list_price BETWEEN 500 AND 1500

--Task 7: list all distinct cities where customers are located.

SELECT DISTINCT city
FROM sales.customers
ORDER BY city ASC;

--Task 8: Find all orders that have not been shipped yet.

SELECT *
FROM sales.orders
WHERE shipped_date IS NULL



