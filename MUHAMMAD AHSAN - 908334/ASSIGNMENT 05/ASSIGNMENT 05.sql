-- 5.1
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


-- 5.2
SELECT *
FROM sales.orders
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE state IN ('NY', 'CA')
);


-- 5.3
-- NOT IN NULL trap ko avoid karne ke liye NOT EXISTS use karein
SELECT c.customer_id
FROM sales.customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
);


-- 5.4
-- Har order ke items count karo, phir un counts ka average nikalo
SELECT AVG(item_count * 1.0) AS average_items_per_order
FROM (
    SELECT
        order_id,
        COUNT(*) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_items_count;


-- 5.5
-- EXISTS ko IN ke saath rewrite
SELECT *
FROM sales.customers
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.orders
);

-- EXISTS version generally safer than IN when the subquery column
-- can contain NULL values.


-- 5.6
-- CROSS APPLY: har customer ke top 3 most recent orders
SELECT
    c.customer_id,
    c.first_name,
    recent_orders.order_id,
    recent_orders.order_date
FROM sales.customers AS c
CROSS APPLY (
    SELECT TOP 3
        o.order_id,
        o.order_date
    FROM sales.orders AS o
    WHERE o.customer_id = c.customer_id
    ORDER BY o.order_date DESC, o.order_id DESC
) AS recent_orders
ORDER BY c.customer_id, recent_orders.order_date DESC;


-- 5.7
-- ANY = IN jaisa kaam karta hai
-- ALL ka matlab: value subquery ke HAR result se condition satisfy kare.

-- Example:
-- Aise products find karo jinki price kisi category ke
-- tamam products se zyada hai:

SELECT
    product_id,
    product_name,
    list_price
FROM production.products
WHERE list_price > ALL (
    SELECT list_price
    FROM production.products
    WHERE category_id = 1
);