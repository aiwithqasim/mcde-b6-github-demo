-----Section 1 — Basic SELECT & Filtering

--task 1:- List all products with their name, model year, and list price.

SELECT product_name, model_year, list_price FROM production.products;


---Task 2:  Find all products whose list price is greater than 1000. Show product name and price.
SELECT * FROM production.products
where list_price > 1000

-----Task 3 :-  List all customers from the state of New York (NY).
SELECT * FROM sales.customers WHERE state ='NY'; 

---Task 4 :- Find all orders placed in the year 2017.
SElECT *
FROM sales.orders
WHERE YEAR (order_date) = 2017

-----Task 5:  List products whose name contains the word 'Trek'.
SELECT *
FROM production.products WHERE 
product_name like '%Trek%';

----- task 6:- -Find all products priced between 500 and 1500.
SELECT * 
FROM production.products 
WHERE list_price BETWEEN 500 and 1500

----task 7 :-List all distinct cities where customers are located.
SELECT DISTINCT CITY 
FROM sales.customers

-----task 8 :-  Find all orders that have NOT been shipped yet.
SELECT *
FROM sales.orders
WHERE shipped_date is NULL;
