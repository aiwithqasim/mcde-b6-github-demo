--Q1) List all products with their name,model year and list price
SELECT 
	product_name,
	model_year,
	list_price
FROM production.products;

--Q2) Find all products whose list price is greater than 1000.Show product name and price.

SELECT 
	product_name,
	list_price
FROM production.products
WHERE list_price  > 1000;

--Q3) List all customers from the state of New York (NY)

SELECT*
FROM sales.customers
WHERE state = 'NY';

--Q4) Find all orders placed in the year 2017

SELECT *
FROM sales.orders
WHERE order_date BETWEEN '2017-01-01' AND '2017-12-31';

--Q5) List products whose name contains the word "Terk"

SELECT
	product_name 
	FROM Production.products
	WHERE  product_name LIKE 'T%';


	--Q6) Find all products priced between 500 and 1500

	SELECT 
		product_name,
		list_price
		FROM production.products
		WHERE list_price BETWEEN '500' and '1500'
		order by list_price ASC;

		--Q7) List all distinct	cities where customers are located 

		SELECT DISTINCT city 
		FROM sales.customers;

		--Q8) Find all orders that have NOT been shipped yet 
			


			SELECT *
			FROM sales.orders
				WHERE shipped_date Is NULL;
