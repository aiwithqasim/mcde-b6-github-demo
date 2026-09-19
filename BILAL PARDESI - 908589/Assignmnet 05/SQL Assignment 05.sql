--task1
SELECT
    p.product_id,
    p.product_name,
    p.brand_id,
    p.list_price
FROM production.products AS p
WHERE p.list_price >
(
    SELECT AVG(p2.list_price)
    FROM production.products AS p2
    WHERE p2.brand_id = p.brand_id
);


--task2
SELECT
    o.order_id,
    o.customer_id,
    o.order_date
FROM sales.orders AS o
WHERE o.customer_id IN
(
    SELECT c.customer_id
    FROM sales.customers AS c
    WHERE c.state IN ('NY', 'CA')
);


--task3
SELECT
    c.customer_id
FROM sales.customers AS c
WHERE NOT EXISTS
(
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
);


--task4
SELECT
    AVG(order_item_count) AS avg_items_per_order
FROM
(
    SELECT
        order_id,
        COUNT(*) AS order_item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_counts;


--task5
SELECT
    c.customer_id
FROM sales.customers AS c
WHERE c.customer_id IN
(
    SELECT o.customer_id
    FROM sales.orders AS o
);


--task6
SELECT
    c.customer_id,
    c.first_name,
    o.order_id,
    o.order_date
FROM sales.customers AS c
CROSS APPLY
(
    SELECT TOP 3
        o.order_id,
        o.order_date
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
    ORDER BY o.order_date DESC
) AS o
ORDER BY
    c.customer_id,
    o.order_date DESC;



--task7
SELECT
    p.product_id,
    p.product_name,
    p.list_price
FROM production.products AS p
WHERE p.list_price > ALL (
    SELECT p2.list_price
    FROM production.products AS p2
    WHERE p2.category_id = p.category_id
      AND p2.product_id <> p.product_id
);


