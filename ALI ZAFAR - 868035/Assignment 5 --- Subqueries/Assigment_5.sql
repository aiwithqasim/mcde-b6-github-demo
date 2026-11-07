--Task 5.1
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


--Task 5.2
SELECT o.*
FROM sales.orders AS o
WHERE o.customer_id IN (
    SELECT c.customer_id
    FROM sales.customers AS c
    WHERE c.state IN ('NY', 'CA')
);


--Task 5.3
SELECT c.customer_id
FROM sales.customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
);


--Task 5.4
SELECT AVG(items_per_order) AS avg_items_per_order
FROM (
    SELECT
        order_id,
        SUM(quantity) AS items_per_order
    FROM sales.order_items
    GROUP BY order_id
) AS order_totals;


--Task 5.5
SELECT c.customer_id, c.first_name, c.last_name
FROM sales.customers AS c
WHERE EXISTS (
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
);

--Task 5.6
SELECT
    c.customer_id,
    c.first_name,
    o.order_id,
    o.order_date
FROM sales.customers AS c
CROSS APPLY (
    SELECT TOP (3)
        o.order_id,
        o.order_date
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
    ORDER BY o.order_date DESC, o.order_id DESC
) AS o
ORDER BY c.customer_id, o.order_date DESC;

--TAsk 5.7
SELECT *
FROM production.products
WHERE list_price > ANY (
    SELECT list_price
    FROM production.products
    WHERE brand_id = 1
);

SELECT *
FROM production.products
WHERE list_price > ALL (
    SELECT list_price
    FROM production.products
    WHERE brand_id = 1
);