-- ASSIGNMENT 5 (SUBQUERIES)

-- Excersice 5.1

SELECT
    p.product_id,
    p.product_name,
    p.brand_id,
    p.list_price
FROM production.products AS p
WHERE p.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products AS p2
    WHERE p2.brand_id = p.brand_id
);

-- Excersice 5.2

SELECT *
FROM sales.orders
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE state IN ('NY', 'CA')
);

-- Excersice 5.3

SELECT c.customer_id
FROM sales.customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
);

-- Excersice 5.4

SELECT AVG(item_count * 1.0) AS average_items_per_order
FROM (
    SELECT
        order_id,
        COUNT(*) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_totals;


-- Excercise 5.5

SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
WHERE EXISTS (
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
);


-- Excersice 5.6

SELECT
    c.customer_id,
    c.first_name,
    o.order_id,
    o.order_date
FROM sales.customers AS c
CROSS APPLY (
    SELECT TOP 3
        o.order_id,
        o.order_date
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
    ORDER BY
        o.order_date DESC,
        o.order_id DESC
) AS o
ORDER BY
    c.customer_id,
    o.order_date DESC;


-- Excercise 5.7

-- I would choose ANY when I need to compare a value with at least one value returned by the subquery using operators such as >, <, >=, or <=. For equality, = ANY is equivalent to IN.

-- I would choose ALL when the comparison must be true for every value returned by the subquery.

-- A business question for ALL is:

-- Which products have a price greater than every product of a particular brand?


