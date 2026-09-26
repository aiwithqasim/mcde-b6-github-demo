Use Bikestores;

--Section 1 - Basic SELECT & FILTERING

-- Q1 List all products with their name, model year and list price?
SELECT product_name, model_year, list_price
	FROM production.products;

-- Q2 Find all products whose list price is greater than 1000. show product name and price?
SELECT product_name, list_price
	FROM production.products
	WHERE list_price  > 1000;

--Q3 Lsit all customers from the state of NY?
SELECT * FROM sales.customers
	WHERE state = 'NY'

-- Q4 Find all orders placed in the year 2017?
SELECT * FROM sales.orders
	WHERE order_date >= '2017-01-01' and order_date < '2018-01-01'

-- Q5 List products whose name contains the word 'Terk'. Hint Use the LIKE operator with wildcards.
SELECT * FROM production.products
	WHERE product_name Like '%Trek%';

-- Q6 FInd all products priced between 500 and 1500?
SELECT product_name, list_price FROM production.products
	WHERE list_price between 500 and 1500;

-- Q7 List all distinct cities where customers are located? Use Select Distinct.
SELECT distinct city
	FROM sales.customers;

-- Q8 Find all orders that have NOT been shipped yet? Hint: Filter where shipped_date is null
SELECT * FROM sales.orders
	WHERE shipped_date is NUll;
