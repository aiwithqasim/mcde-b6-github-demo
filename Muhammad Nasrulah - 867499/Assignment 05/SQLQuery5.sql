-- Chapter 5: Subqueries
-- Assignment Solutions

-- 5.1
-- Products with a price above the average price in their brand

SELECT
    product_name,
    list_price,
    brand_id
FROM production.products p
WHERE list_price > (
    SELECT AVG(list_price)
    FROM production.products
    WHERE brand_id = p.brand_id
);


-- 5.2
-- Orders placed by customers living in New York or California

SELECT
    order_id,
    customer_id,
    order_date
FROM sales.orders
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE state IN ('NY', 'CA')
);


-- 5.3
-- Customers who never placed an order

SELECT
    customer_id,
    first_name,
    last_name
FROM sales.customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM sales.orders
    WHERE customer_id IS NOT NULL
);


-- 5.4
-- Average number of items per order
-- 5.4
-- Average number of items per order

SELECT
    AVG(item_count * 1.0) AS average_items_per_order
FROM (
    SELECT
        order_id,
        COUNT(*) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_counts;

-- 5.5
-- Customers who placed at least one order in 2017
-- Using IN instead of EXISTS

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

-- EXISTS is generally safer when NULL values can be involved,
-- especially when using NOT EXISTS.


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
    ORDER BY order_date DESC
) AS o
ORDER BY
    c.customer_id,
    o.order_date DESC;


-- 5.7
-- ANY vs ALL
--
-- ANY is useful when a condition only needs to be true
-- for at least one value returned by the subquery.
--
-- ALL is useful when the condition must be true
-- for every value returned by the subquery.
--
-- Example business question for ALL:
-- Which products have a price greater than or equal to
-- every brand's average price?
