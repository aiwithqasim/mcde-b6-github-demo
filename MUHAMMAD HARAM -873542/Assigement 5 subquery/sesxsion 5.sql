5.1
SELECT p.product_id, p.product_name, p.brand_id, p.list_price
FROM production.products p
WHERE p.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.brand_id = p.brand_id
);

5.2
SELECT o.*
FROM sales.orders o
WHERE o.customer_id IN (
    SELECT c.customer_id
    FROM sales.customers c
    WHERE c.state IN ('NY', 'CA')
);

5.3 
SELECT customer_id
FROM sales.customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM sales.orders
    WHERE customer_id IS NOT NULL
);

5.4
SELECT AVG(order_totals.item_count) AS avg_items_per_order
FROM (
    SELECT order_id, SUM(quantity) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_totals;

5.5
SELECT c.customer_id, c.first_name
FROM sales.customers c
WHERE EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
);

5.6
SELECT c.customer_id, c.first_name, o.order_id, o.order_date
FROM sales.customers c
CROSS APPLY (
    SELECT TOP 3 ord.order_id, ord.order_date
    FROM sales.orders ord
    WHERE ord.customer_id = c.customer_id
    ORDER BY ord.order_date DESC
) o;

5.7
SELECT product_name, list_price
FROM production.products
WHERE list_price > ALL (
    SELECT list_price
    FROM production.products
    WHERE brand_id = 5
);