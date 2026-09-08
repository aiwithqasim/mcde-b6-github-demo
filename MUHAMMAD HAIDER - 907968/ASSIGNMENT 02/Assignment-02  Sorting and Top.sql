USE BikeStores;

-- SECTION 2 - Sorting & Top-N
--											✦✦✦ QUESTION 9 ✦✦✦
-- List the top ten most expensive products, sorted by price descensding.
SELECT TOP 10 
	product_name,
	brand_id,
	list_price
FROM production.products
ORDER BY list_price DESC;

--											✦✦✦ QUESTION 10 ✦✦✦
-- List all customers sorted by last name (A - Z), then first name (A - Z).
SELECT * FROM sales.customers
ORDER BY 3 ASC, 2 ASC; -- I used column number instead of column name!

--											✦✦✦ QUESTION 11 ✦✦✦
-- Find the five cheapest products that were produced in the model year 2018.
SELECT TOP 5 * FROM production.products
WHERE model_year = 2018
ORDER BY list_price ASC;
