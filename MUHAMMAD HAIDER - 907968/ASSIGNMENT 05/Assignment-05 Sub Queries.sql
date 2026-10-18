
--										✧✧✧ SUB QUERIES ASSIGNMENT ✧✧✧
/*============================================================================================================================
5.1 - Write a query using a scalar subquery that returns all products with a list_price above the average price in their brand.
Use a correlated subquery in WHERE. 
============================================================================================================================*/
 SELECT 
	product_id,
	product_name,
	list_price
FROM production.products p1
WHERE list_price > 
		(SELECT  
		AVG(list_price) 
	FROM production.products p2
	WHERE p1.brand_id = p2.brand_id);
-- ============================================================================================================================
-- 5.2 - Write a query using IN that returns all orders placed by customers living in New York or California.
-- ============================================================================================================================
SELECT
	order_id,
	order_date,
	customer_id
FROM sales.orders 
WHERE customer_id IN ( 
	SELECT customer_id FROM sales.customers WHERE state IN ('NY', 'CA') );
-- ============================================================================================================================
-- 5.3 - The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:
-- ============================================================================================================================
SELECT customer_id FROM sales.customers
WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders);

-- corrected query (my correction)
SELECT customer_id FROM sales.customers
WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders WHERE customer_id IS NOT NULL);

/* ============================================================================================================================
5.4 - Using a derived table in FROM, write a query that finds the average number of items per order
across all orders. 
============================================================================================================================*/   
SELECT  
	AVG(CAST(total_qtty AS FLOAT)) AS avg_items_per_order
FROM 
	(SELECT 
		order_id, 
		SUM(quantity) AS total_qtty
	FROM sales.order_items 
	GROUP BY order_id
	) AS order_totals
/* ============================================================================================================================
5.5 - Rewrite the EXISTS example from section 8.6 using IN instead. Which version is safer and why?
Customers who placed at least one order in 2017 (USING EXISTS)
============================================================================================================================*/
SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM sales.customers c
WHERE EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
      AND YEAR(o.order_date) = 2017
);

-- Customers who placed at least one order in 2017 (USING IN)

    customer_id,
    first_name,
    last_name,
    city
FROM sales.customers c
WHERE customer_id IN (
	SELECT customer_id FROM sales.orders 
	WHERE YEAR(order_date) = 2017 );
-- Which one is better and recommended?
-- Exists version is better due to: Null Safe and Fast Execution.


/* ============================================================================================================================
5.6 - Use CROSS APPLY to return the top 3 most recent orders for each customer. Show customer_id, 
first_name, order_id, and order_date.
============================================================================================================================*/ 
SELECT 
	c.customer_id,
	c.first_name,
	o.order_id,
	o.order_date
FROM sales.customers c
CROSS APPLY (
	SELECT 
		TOP 3
		order_id,
		order_date
	FROM sales.orders o
	WHERE o.customer_id = c.customer_id
	ORDER BY o.order_date DESC) AS o;

/* ============================================================================================================================
5.7 - Think About It: = ANY (subquery) is functionally identical to IN (subquery). Given that, when would you choose
ANY over IN, and when would you choose ALL? What business question naturally maps to ALL that cannot be expressed
cleanly with IN?
============================================================================================================================*/

/* • ANY vs IN
• IN / = ANY: Both are identical when checking for an exact match (WHERE id IN (...)).
• When to use ANY: Use it when you need comparison operators other than = (like >, <, >=).
• Example: price > ANY (...) means "greater than at least one value in the list."

• When to use ALL?
• Use ALL when a condition must be true against every single value in the subquery list (Logical AND).

• Business Example for ALL
• Question: "Find products that are more expensive than ALL products in Brand 1."
• IN fails here because: IN only checks for equality (=). It cannot evaluate "greater than everything" logic.
*/
