-- 6.1
WITH store_counts AS (
    SELECT 
        store_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT 
    AVG(order_count) AS avg_orders
FROM store_counts;

-- 6.2
WITH cte_high_value_products AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.list_price,
        p.category_id
    FROM production.products p
    WHERE p.list_price > 2000
)
SELECT 
    hvp.product_name,
    hvp.list_price,
    c.category_name
FROM cte_high_value_products hvp
INNER JOIN production.categories c ON hvp.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';

-- 6.3
WITH order_counts AS (
    SELECT 
        customer_id,
        COUNT(order_id) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
customer_revenue AS (
    SELECT 
        o.customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.orders o
    INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT 
    oc.customer_id,
    oc.order_count,
    cr.total_revenue
FROM order_counts oc
INNER JOIN customer_revenue cr ON oc.customer_id = cr.customer_id
ORDER BY cr.total_revenue DESC;

-- 6.4
WITH numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM numbers
    WHERE n < 10
)
SELECT 
    n,
    n * n AS square
FROM numbers;

-- 6.5
WITH org_chart AS (
    SELECT 
        s.staff_id,
        s.first_name,
        s.last_name,
        s.manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_name,
        0 AS level
    FROM sales.staffs s
    WHERE s.manager_id IS NULL

    UNION ALL

    SELECT 
        e.staff_id,
        e.first_name,
        e.last_name,
        e.manager_id,
        m.first_name AS manager_name,
        oc.level + 1 AS level
    FROM sales.staffs e
    INNER JOIN org_chart oc ON e.manager_id = oc.staff_id
    INNER JOIN sales.staffs m ON e.manager_id = m.staff_id
)
SELECT 
    staff_id,
    first_name,
    last_name,
    manager_name,
    level
FROM org_chart
ORDER BY level, first_name;

-- 6.6
-- The claim is not always accurate. In most databases, a CTE is treated
-- as a temporary view and may be re-executed each time it is referenced.
-- To compute once and reuse: use a TEMPORARY TABLE, MATERIALIZED VIEW,
-- or in PostgreSQL use WITH ... AS MATERIALIZED.