-- 5.1
-- Products with a price above the average price of their brand

SELECT *
FROM production.products p
WHERE p.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.brand_id = p.brand_id
);

-- 5.2
-- Orders placed by customers living in New York or California

SELECT *
FROM sales.orders
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE state IN ('NY', 'CA')
);

-- 5.3
-- Customers who never placed an order

SELECT customer_id
FROM sales.customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM sales.orders
    WHERE customer_id IS NOT NULL
);

-- 5.4
-- Average number of items per order

SELECT AVG(item_count) AS avg_items_per_order
FROM (
    SELECT order_id, COUNT(*) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_counts;

-- 5.5
-- Customers who have placed at least one order using IN

SELECT *
FROM sales.customers
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.orders
);

-- 5.6
-- Top 3 most recent orders for each customer

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
) o
ORDER BY c.customer_id, o.order_date DESC;

-- 5.7
-- ANY vs IN vs ALL

-- IN checks whether a value exists in the subquery result.
-- = ANY is similar to IN for equality comparisons.
-- ALL means the condition must be true for every value returned.

-- Business question:
-- Which products are more expensive than every product from Brand 1?

SELECT *
FROM production.products p
WHERE p.list_price > ALL (
    SELECT p2.list_price
    FROM production.products p2
    WHERE p2.brand_id = 1
);