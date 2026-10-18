-- ============================================================
-- Assignment 5 - Subqueries
-- Student: Muhammad Ayan
-- ID: 906504
-- Database: BikeStores
-- ============================================================


-- 5.1 Scalar correlated subquery
-- Products whose list_price is above the average price of their own brand
SELECT 
    product_id,
    product_name,
    brand_id,
    list_price
FROM production.products p
WHERE list_price > (
    SELECT AVG(list_price)
    FROM production.products
    WHERE brand_id = p.brand_id
);


-- 5.2 Using IN
-- All orders placed by customers living in New York or California
SELECT 
    order_id,
    customer_id,
    order_date,
    order_status
FROM sales.orders
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE state IN ('NY', 'CA')
);


-- 5.3 Fix the NULL trap
-- Customers who never placed an order (safe version)
SELECT customer_id
FROM sales.customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
);


-- 5.4 Derived table
-- Average number of items per order
SELECT AVG(item_count) AS avg_items_per_order
FROM (
    SELECT 
        order_id,
        COUNT(*) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_counts;


-- 5.5 Rewrite EXISTS using IN
SELECT 
    customer_id,
    first_name,
    last_name
FROM sales.customers
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.orders
);

-- Note: EXISTS is safer than IN when the subquery can return NULLs.


-- 5.6 CROSS APPLY
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
    ORDER BY order_date DESC
) o
ORDER BY c.customer_id, o.order_date DESC;


-- 5.7 Think About It (ANY vs IN vs ALL)

--= ANY (subquery) is functionally the same as IN (subquery).

--Use ANY when you need other comparison operators:
--    list_price > ANY (subquery)

--Use ALL when the value must be greater/less than EVERY value returned by the subquery.

--Business question that maps naturally to ALL:
--"Find products that are more expensive than every product of brand Trek"

--Example:
--SELECT product_name, list_price
--FROM production.products
--WHERE list_price > ALL (
--    SELECT list_price
--    FROM production.products
--    WHERE brand_id = 9   -- Trek
--);