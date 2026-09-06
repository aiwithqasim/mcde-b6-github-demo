USE bikestores;

		--	      		SECTION 1				--

	            --Basic SELECT & FILTERING--

	/*TASK 1: List all products with their name,model year & list price.*/
	
	-- SOLUTION:

	select 
	product_name,
	model_year,
	list_price
	from production.products;

	-----------------------------------------------------------------------------------------------

	/*TASK 2: Find all products whose list price is greater than 1000,
			  show product name and price.*/

	 -- SOLUTION:

	select 
	product_name,
	list_price
	from production.products
	where list_price > 1000;

	--------------------------------------------------------------------------------------------------

	/*TASK 3: LIST ALL CUSTOMERS FROM THE STATE OF NEW YORK (NY).*/

	-- SOLUTION:

SELECT *
FROM sales.customers
WHERE STATE = 'NY';

	/*TASK 4:FIND ALL ORDERS PLACED IN THE YEAR 2017.*/

	-- SOLUTION:

	select *
	from sales.orders
	where year(order_date) = 2017 

	--------------------------------------------------------------------------------------------------
	
	/*TASK 5: List products whose name contains the word 'TREK'.*/

	-- SOLUTION:

	select *
	 from production.products
	 where product_name like '%TREK%';

	--------------------------------------------------------------------------------------------------

	 /*TASK 6: FIND ALL PRODUCTS PRICED BETWEEN 500 AND 1500.*/

	-- SOLUTION:

	 select *
	 from production.products
		where list_price between 500 and 1500;

	--------------------------------------------------------------------------------------------------

	/*TASK 7: LIST ALL DISTINCT CITIES WHERE CUSTOMERS ARE LOCATED.*/
	
	-- SOLUTION:

	SELECT DISTINCT city	
	FROM sales.customers;

	--------------------------------------------------------------------------------------------------

	/*TASK 8: FIND ALL ORDERS THAT HAVE NOT BEEN SHIPPED YET.*/

	-- SOLUTION:

	select *
	from sales.orders
	where shipped_date IS NULL;

	--------------------------------------------------------------------------------------------------
							---SECTION 1 ENDED---