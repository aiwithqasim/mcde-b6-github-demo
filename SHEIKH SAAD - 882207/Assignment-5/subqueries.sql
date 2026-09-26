--Write a query using a scalar subquery that returns all products 
--with a list_price above the average price in their brand. 
--Use a correlated subquery in WHERE.

SELECT DISTINCT
 p1.product_name,
 p1.brand_id,
 list_price
FROM production.products AS p1
WHERE p1.list_price > (
	SELECT AVG(list_price)
	FROM production.products as p2
	WHERE p2.brand_id = p1.brand_id
	)
ORDER BY p1.brand_id,list_price DESC;

--Write a query using IN that returns all orders placed by customers 
--living in New York or California.

SELECT 
	order_id,
	order_date,
	customer_id,
	order_status
FROM sales.orders
WHERE customer_id IN (
	SELECT customer_id FROM sales.customers
	WHERE state IN('NY', 'CA')
) ORDER BY order_date DESC;

--The following query is meant to find customers 
--who never ordered, but has a NULL trap. Fix it:
--SELECT customer_id FROM sales.customers
--WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders);5

SELECT c.customer_id 
FROM sales.customers AS c
WHERE NOT EXISTS (
	SELECT 1 FROM sales.orders AS o 
	WHERE o.customer_id = c.customer_id 
);

--Using a derived table in FROM, write a query that finds		
--the average number of items per order across all orders.

SELECT AVG(t.total_items_per_order) AS avg_items_per_order
FROM (
	SELECT
		order_id,
		SUM(quantity) AS total_items_per_order
	FROM sales.order_items
	GROUP BY order_id
) t;

--5.5 - Rewrite the EXISTS example from section 8.6 (5.6) using IN instead. 
--Which version is safer and why?

SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM sales.customers as c
WHERE EXISTS (
    SELECT 1
    FROM sales.orders as o
    WHERE o.customer_id = c.customer_id
      AND YEAR(o.order_date) = 2017
);

SELECT  
	customer_id,
    first_name,
    last_name,
    city
FROM sales.customers
WHERE customer_id IN (
	SELECT customer_id
	FROM sales.orders
	WHERE YEAR(order_date) = 2017
);
-- Both give same result but IN and EXISTS but EXISTS is more save in the sence while NULL value if having. 



