use BikeStores;

--Subquery Exercises

-- 5.1

SELECT 
    p1.product_id,
    p1.product_name,
    p1.brand_id,
    p1.list_price
FROM production.products AS p1
WHERE p1.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products AS p2
    WHERE p2.brand_id = p1.brand_id);

--5.2
SELECT 
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status
FROM sales.orders AS o
WHERE o.customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE state IN ('NY', 'CA'));

--5.3
SELECT customer_id 
FROM sales.customers
WHERE customer_id NOT IN (
    SELECT customer_id 
    FROM sales.orders 
    WHERE customer_id IS NOT NULL);

--5.4
SELECT c.customer_id 
FROM sales.customers AS c
WHERE NOT EXISTS (
    SELECT 1 
    FROM sales.orders AS o 
    WHERE o.customer_id = c.customer_id);

--5.4

SELECT 
    AVG(order_counts.total_items) AS avg_items_per_order
FROM (
    SELECT 
        order_id, 
        SUM(quantity) AS total_items
    FROM sales.order_items
    GROUP BY order_id
) AS order_counts;

--5.5

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
WHERE c.customer_id IN (
    SELECT o.customer_id
    FROM sales.orders AS o);


--5.6
SELECT 
    c.customer_id,
    c.first_name,
    o.order_id,
    o.order_date
FROM sales.customers AS c
CROSS APPLY (
    SELECT TOP (3) 
        o_inner.order_id,
        o_inner.order_date
    FROM sales.orders AS o_inner
    WHERE o_inner.customer_id = c.customer_id
    ORDER BY o_inner.order_date DESC, o_inner.order_id DESC) AS o;


--5.7
--  IN: Checks if a value equals any single item in a list or subquery result set.

--  = ANY: Functionally identical to IN, but allows non-equality operators (like >, <, or <>) to compare a value against at least one item in a set.

--  ALL: Checks if a comparison (such as >, <, or =) holds true against every single item returned by a subquery.