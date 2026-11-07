-- 5.1 - Write a query using a scalar subquery that returns all products with a list_price above the 
-- average price in their brand. Use a correlated subquery in WHERE.

SELECT
	product_name,
	list_price
FROM production.products
WHERE list_price > (
	SELECT AVG(list_price)
	FROM production.products
)

-- 5.2 - Write a query using IN that returns all orders placed by customers living in New York or 
-- California.

SELECT
	first_name,
	last_name
FROM sales.customers
WHERE customer_id IN (
	SELECT customer_id
	FROM sales.orders
	WHERE state = 'NY'
		OR state = 'CA'
)

-- 5.3 - The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:

SELECT
	customer_id
FROM sales.customers
WHERE customer_id NOT IN (
	SELECT customer_id 
	FROM sales.orders
	WHERE customer_id is not NULL
)

-- 5.4 - Using a derived table in FROM, write a query that finds the average number of items per order 
-- across all orders.

SELECT
	AVG(item_count) as average_number_of_items_per_order
FROM (
	SELECT
		order_id,
		COUNT(item_id) as item_count
	FROM sales.order_items
	GROUP BY order_id
) as average_item_count

-- 5.5 - Rewrite the EXISTS example from section 5.6 using IN instead. Which version is safer and why?

-- Ans: The EXISTS version is safer because it only checks whether a matching row exists and is not affected 
-- by NULL values in the same way as IN. IN is simpler and readable when the subquery returns a clean list 
-- of non-NULL values.

SELECT
	customer_id,
	first_name,
	last_name,
	city
FROM sales.customers as c
WHERE customer_id IN (
	SELECT customer_id
	FROM sales.orders as o
	WHERE o.customer_id = c.customer_id
		AND YEAR(o.order_date) = 2017
)

-- 5.6 - Use CROSS APPLY to return the top 3 most recent orders for each customer. Show customer_id, 
-- first_name, order_id, and order_date.

SELECT
	c.customer_id,
	c.first_name,
	o.order_id,
	o.order_date
FROM sales.customers as c
CROSS APPLY (
	SELECT TOP 3
		order_id,
		order_date
	FROM sales.orders
	WHERE customer_id = c.customer_id
	ORDER BY order_date DESC
) as o
ORDER BY c.first_name, o.order_date DESC

-- 5.7 - Think About It: = ANY (subquery) is functionally identical to IN (subquery). Given that, when 
-- would you choose ANY over IN, and when would you choose ALL? What business question naturally maps to 
-- ALL that cannot be expressed cleanly with IN?

-- Ans: ANY is useful when you want to compare a value with at least one value returned by a subquery. 
-- Since = ANY is equivalent to IN, I would usually choose IN because it is simpler and more readable. 
-- However, ANY becomes more useful with comparison operators such as > ANY, < ANY, etc.