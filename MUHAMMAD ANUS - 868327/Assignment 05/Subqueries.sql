----5.1 - Write a query using a scalar subquery that returns all products
--with a list_price above the average price in their brand
---Use a correlated subquery in WHERE.
SELECT
p1.product_name,
p1.list_price
FROM production.products p1
WHERE p1.list_price >(
SELECT avg(p2.list_price) AS avg_price
FROM production.products p2
WHERE p1.brand_id=p2.brand_id);

--5.2 - Write a query using IN that returns 
--all orders placed by customers living in New York or California.
SELECT
    o.order_date,
    o.order_id
FROM sales.orders o
WHERE o.customer_id IN (
    SELECT s.customer_id
    FROM sales.customers s
    WHERE s.state IN ('NY', 'CA')
);
--5.3 - The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:
--SELECT customer_id FROM sales.customers
--WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders);
SELECT customer_id 
FROM sales.customers
WHERE customer_id NOT IN (
    SELECT customer_id 
    FROM sales.orders
    WHERE customer_id IS NOT NULL
);
--5.4 - Using a derived table in FROM,
--write a query that finds the average number of items 
--per order across all orders.
SELECT AVG(item_count) AS avg_items_per_order
FROM (
    SELECT order_id, COUNT(*) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_counts;
--5.5 - Rewrite the EXISTS example from section 8.6 using IN instead.
--Which version is safer and why?
SELECT *
FROM sales.customers
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.orders
);
--5.6 - Use CROSS APPLY to return the top 3 most recent orders for each customer.
--Show customer_id, first_name, order_id, and order_date.
SELECT
c.customer_id,
c.first_name,
o.order_id,
o.order_date
FROM sales.customers c
CROSS APPLY (
SELECT TOP 3 
order_id,
order_date
FROM sales.orders o
WHERE o.customer_id = c.customer_id
ORDER BY o.order_date DESC
) O
ORDER BY c.customer_id,o.order_date DESC;
--5.7 - Think About It: = ANY (subquery) is functionally identical to IN (subquery).
--Given that, when would you choose ANY over IN, and when would you choose ALL?
--What business question naturally maps to ALL that cannot be expressed cleanly with IN?
SELECT * 
FROM production.products p
WHERE p.list_price > ALL(
   SELECT p2.list_price 
   FROM production.products p2
   WHERE p2.brand_id =1
);