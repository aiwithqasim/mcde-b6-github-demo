-- 5.1
SELECT p1.product_id, p1.product_name, p1.brand_id, p1.list_price
FROM production.products p1
WHERE p1.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.brand_id = p1.brand_id
);

-- 5.2
SELECT o.*
FROM sales.orders o
WHERE o.customer_id IN (
    SELECT c.customer_id
    FROM sales.customers c
    WHERE c.state IN ('NY', 'CA')
);

-- 5.3
SELECT c.customer_id
FROM sales.customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
);

-- 5.4
SELECT AVG(item_count * 1.0) AS avg_items_per_order
FROM (
    SELECT order_id, COUNT(*) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_item_counts;

-- 5.5
SELECT c.customer_id, c.first_name, c.last_name
FROM sales.customers c
WHERE c.customer_id IN (
    SELECT o.customer_id
    FROM sales.orders o
);

-- Safer: EXISTS/NOT EXISTS - NULL values se affect nahi hota, IN/NOT IN NULL trap ka shikar ho sakte hain.

-- 5.6
SELECT c.customer_id, c.first_name, o.order_id, o.order_date
FROM sales.customers c
CROSS APPLY (
    SELECT TOP 3 ord.order_id, ord.order_date
    FROM sales.orders ord
    WHERE ord.customer_id = c.customer_id
    ORDER BY ord.order_date DESC
) AS o
ORDER BY c.customer_id, o.order_date DESC;

-- 5.7
SELECT product_id, product_name, list_price
FROM production.products
WHERE list_price >= ALL (SELECT list_price FROM production.products);