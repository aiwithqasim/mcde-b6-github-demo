-- ASSIGNMENT 5
================

-- EXCERCISE 5.1

SELECT p.product_id,
       p.product_name,
       p.brand_id,
       p.list_price
FROM production.products AS p
WHERE p.list_price > (
        SELECT AVG(p2.list_price)
        FROM production.products AS p2
        WHERE p2.brand_id = p.brand_id
      )
ORDER BY p.brand_id, p.list_price DESC;

-- EXCERCISE 5.2

SELECT o.order_id,
       o.customer_id,
       o.order_status,
       o.order_date,
       o.store_id
FROM sales.orders AS o
WHERE o.customer_id IN (
        SELECT c.customer_id
        FROM sales.customers AS c
        WHERE c.state IN ('NY', 'CA')
      )
ORDER BY o.order_date DESC;

-- EXCERCISE 5.3

SELECT c.customer_id
FROM sales.customers AS c
WHERE NOT EXISTS (
        SELECT 1
        FROM sales.orders AS o
        WHERE o.customer_id = c.customer_id
      );

-- EXCERCISE 5.4

SELECT AVG(item_counts.num_items) AS avg_items_per_order
FROM (
        SELECT order_id, COUNT(*) AS num_items
        FROM sales.order_items
        GROUP BY order_id
     ) AS item_counts;

-- EXCERCISE 5.6

SELECT c.customer_id,
       c.first_name,
       top_orders.order_id,
       top_orders.order_date
FROM sales.customers AS c
CROSS APPLY (
        SELECT TOP 3 o.order_id, o.order_date
        FROM sales.orders AS o
        WHERE o.customer_id = c.customer_id
        ORDER BY o.order_date DESC
     ) AS top_orders
ORDER BY c.customer_id, top_orders.order_date DESC;

-- EXCERCISE 5.7

-- ANY generalizes IN to non-equality operators (>, <, etc.) — use it when you need "beats at least one row" with
-- something other than =. ALL maps to "beats every row" (e.g., priced higher than all Electronics products), a
-- comparison IN simply can't express.