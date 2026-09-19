--5.1 — Correlated Subquery
SELECT product_id, product_name, brand_id, list_price
FROM production.products p
WHERE list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.brand_id = p.brand_id
);
--5.2 — Using IN
SELECT *
FROM sales.orders
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.customers
    WHERE state IN ('New York', 'California')
);
--5.3 — Fix NOT IN NULL Trap
SELECT c.customer_id
FROM sales.customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
);
--5.4 — Derived Table in FROM
SELECT AVG(item_count) AS avg_items_per_order
FROM (
    SELECT order_id, COUNT(*) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS order_counts;
--5.5 — Task

--Rewrite the EXISTS example from section 8.6 using IN instead. Which version is safer and why?

SELECT customer_id
FROM sales.customers
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.orders
);
--5.6 — Task

--Use CROSS APPLY to return the top 3 most recent orders for each customer. Show customer_id, first_name, order_id, and order_date.

SELECT 
    c.customer_id,
    c.first_name,
    o.order_id,
    o.order_date
FROM sales.customers c
CROSS APPLY (
    SELECT TOP 3 order_id, order_date
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
    ORDER BY order_date DESC
) o;
--5.7 — Task

--Think About It: = ANY (subquery) is functionally identical to IN (subquery). When would you choose ANY over IN, and when would you choose ALL?

-- ANY
SELECT
    product_name,
    list_price
FROM production.products
WHERE list_price >= ANY (
    SELECT AVG(list_price)
    FROM production.products
    GROUP BY brand_id
);
           

