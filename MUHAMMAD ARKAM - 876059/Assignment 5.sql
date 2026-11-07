
----------------Chapter 5: Subqueries---------------------------

TASK(5.1) SELECT 
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

TASK(5.2) SELECT *
FROM sales.orders
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE state IN ('NY', 'CA')
);

TASK(5.3) SELECT 
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
);
 .
TASK(5.4)  SELECT AVG(item_count) AS average_items_per_order
FROM (
    SELECT 
        order_id,
        SUM(quantity) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_totals;

TASK(5.5) ```sql
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
WHERE c.customer_id IN (
    SELECT o.customer_id
    FROM sales.orders AS o
);


TASK(5.6) SELECT 
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
    ORDER BY o.order_date DESC
) AS o
ORDER BY c.customer_id, o.order_date DESC;

TASK(5.7) SELECT 
    product_name,
    list_price
FROM production.products
WHERE list_price > ALL (
    SELECT list_price
    FROM production.products
   
