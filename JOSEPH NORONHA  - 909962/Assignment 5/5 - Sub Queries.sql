-- Subquery

-- 5.1 - Write a query using a scalar subquery that returns all products with a list_price above 
-- the average price in their brand. Use a correlated subquery in WHERE.
SELECT
    p1.product_name,
    p1.brand_id,
    p1.list_price
FROM production.products p1
WHERE p1.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.brand_id = p1.brand_id
);

-- 5.2 - Write a query using IN that returns all orders placed by customers living in New York or California.
SELECT o.*
FROM sales.orders o
WHERE o.customer_id IN (
    SELECT c.customer_id
    FROM sales.customers c
    WHERE c.state IN ('NY', 'CA')
);

-- 5.3 - The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:
-- SELECT customer_id FROM sales.customers
-- WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders);
SELECT c.customer_id, c.first_name, c.last_name
FROM sales.customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
);

-- 5.4 - Using a derived table in FROM, 
-- write a query that finds the average number of items per order across all orders.
SELECT AVG(item_count) AS avg_items_per_order
FROM (
    SELECT order_id, COUNT(item_id) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_item_counts;

-- 5.5 - Rewrite the EXISTS example from section 8.6 using IN instead. 
-- Which version is safer and why?
SELECT c.customer_id, c.first_name, c.last_name, c.city
FROM sales.customers c
WHERE EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
      AND YEAR(o.order_date) = 2017
);
-- EXISTS is generally safer, but in this case both IN and EXISTS work correctly. 
-- The NULL problem only happens with NOT IN, not IN.
-- EXISTS is still preferred because it can stop as soon as it finds a match, 
-- making it more efficient for large queries. 
-- It also helps you avoid accidentally using NOT IN later and running into NULL problems.

-- 5.6 - Use CROSS APPLY to return the top 3 most recent orders for each customer. 
-- Show customer_id, first_name, order_id, and order_date.
SELECT
    c.customer_id,
    c.first_name,
    top_orders.order_id,
    top_orders.order_date
FROM sales.customers c
CROSS APPLY (
    SELECT TOP 3 order_id, order_date
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
    ORDER BY order_date DESC
) AS top_orders
ORDER BY c.customer_id, top_orders.order_date DESC;

-- 5.7 - Think About It: = ANY (subquery) is functionally identical to IN (subquery). 
-- Given that, when would you choose ANY over IN, and when would you choose ALL? 
-- What business question naturally maps to ALL that cannot be expressed cleanly with IN?
= ANY and IN mean the same thing: the value must match at least one value in the subquery.
Use ANY when you want comparisons like >, <, or >= against at least one value.
Use ALL when the value must satisfy the condition against every value in the subquery.
For example, price >= ALL (...) answers: “Is this product priced higher than or equal to every brand’s average price?”
This cannot be expressed cleanly with IN because IN only checks whether a value exists in a set.