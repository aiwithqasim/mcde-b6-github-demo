--Section 2 - Sorting & Top-N

--Task 9: List top 10 most expenssive products, sorted by price descending?
SELECT top 10 product_name, list_price FROM Production.products
	ORDER BY list_price DESC

--Task 10: List all customers sorted by last name (A-Z), then first name (A-Z)
SELECT * FROM sales.customers
	WHERE phone is null
	ORDER BY last_name ASC, first_name ASC

--Task 11: Find the 5 cheapest products that were produced in model year 2018?
SELECT top 5 * FROM production.products
	WHERE model_year = '2018'
	ORDER BY list_price ASC
	
	