-- =============================================================
-- Muhammad Shehreyar - Assignment 5
-- =============================================================


-- =============================================================
-- EXERCISE 5.1
-- Write a query using a scalar subquery that returns all products
-- with a list_price above the average price in their brand.
-- Use a correlated subquery in WHERE.
-- =============================================================

SELECT
    p.product_name,
    p.list_price,
    p.brand_id
FROM production.products AS p
WHERE p.list_price >
(
    SELECT AVG(b.list_price)
    FROM production.products AS b
    WHERE b.brand_id = p.brand_id
);


-- =============================================================
-- EXERCISE 5.2
-- Write a query using IN that returns all orders placed by
-- customers living in New York or California.
-- =============================================================

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_status
FROM sales.orders AS o
WHERE o.customer_id IN
(
    SELECT c.customer_id
    FROM sales.customers AS c
    WHERE c.state IN ('NY', 'CA')
);


-- =============================================================
-- EXERCISE 5.3
-- The following query is meant to find customers who never
-- ordered, but has a NULL trap. Fix it.
--
-- Original:
-- SELECT customer_id
-- FROM sales.customers
-- WHERE customer_id NOT IN
-- (
--     SELECT customer_id
--     FROM sales.orders
-- );
-- =============================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
WHERE NOT EXISTS
(
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
);


-- =============================================================
-- EXERCISE 5.4
-- Using a derived table in FROM, write a query that finds the
-- average number of items per order across all orders.
-- =============================================================

SELECT
    AVG(item_count) AS average_items_per_order
FROM
(
    SELECT
        order_id,
        SUM(quantity) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_totals;


-- =============================================================
-- EXERCISE 5.5
-- Rewrite the EXISTS example from section 8.6 using IN instead.
-- Which version is safer and why?
-- =============================================================

SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM sales.customers
WHERE customer_id IN
(
    SELECT customer_id
    FROM sales.orders
    WHERE YEAR(order_date) = 2017
);

-- EXISTS is generally safer when the subquery may contain NULLs,
-- because NOT IN can produce unexpected results when NULL is present.
-- EXISTS checks whether a matching row exists and does not have
-- the same NULL trap as NOT IN.


-- =============================================================
-- EXERCISE 5.6
-- Use CROSS APPLY to return the top 3 most recent orders for
-- each customer.
-- Show customer_id, first_name, order_id, and order_date.
-- =============================================================

SELECT
    c.customer_id,
    c.first_name,
    o.order_id,
    o.order_date
FROM sales.customers AS c
CROSS APPLY
(
    SELECT TOP 3
        order_id,
        order_date
    FROM sales.orders
    WHERE customer_id = c.customer_id
    ORDER BY order_date DESC, order_id DESC
) AS o
ORDER BY
    c.first_name,
    o.order_date DESC;


-- =============================================================
-- EXERCISE 5.7
-- Think About It:
-- = ANY (subquery) is functionally identical to IN (subquery).
-- Given that, when would you choose ANY over IN, and when would
-- you choose ALL?
-- What business question naturally maps to ALL that cannot be
-- expressed cleanly with IN?
-- =============================================================

-- ANY is useful when we want to compare a value using operators
-- such as >, <, or = against at least one value returned by a
-- subquery.
--
-- IN is mainly used to check whether a value matches any value
-- in a list or subquery result.
--
-- ALL is useful when a condition must be true for every value
-- returned by the subquery.
--
-- Example business question for ALL:
-- "Find products whose price is higher than the price of every
-- product in a particular category."
--
-- This can be written using:
-- WHERE list_price > ALL (subquery)
--
-- ALL naturally expresses a comparison against every row,
-- whereas IN is mainly a membership check.


-- =============================================================
-- END OF ASSIGNMENT 5
-- Muhammad Shehreyar
-- =============================================================
