WITH store_counts AS (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count) AS avg_orders
FROM store_counts;


WITH cte_high_value_products AS (
    SELECT product_id, product_name, category_id, list_price
    FROM production.products
    WHERE list_price > 2000
)
SELECT 
    p.product_id,
    p.product_name,
    p.list_price,
    c.category_name
FROM cte_high_value_products AS p
JOIN production.categories AS c
    ON p.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';


WITH order_counts AS (
    SELECT 
        customer_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
customer_revenue AS (
    SELECT 
        o.customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.orders AS o
    JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT 
    oc.customer_id,
    oc.order_count,
    cr.total_revenue
FROM order_counts AS oc
JOIN customer_revenue AS cr
    ON oc.customer_id = cr.customer_id;

    
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
FROM numbers
OPTION (MAXRECURSION 10);


WITH org_chart AS (
    -- Top-level manager
    SELECT
        s.staff_id,
        s.first_name,
        s.last_name,
        s.manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_first_name,
        0 AS level
    FROM sales.staffs AS s
    WHERE s.manager_id IS NULL

    UNION ALL

    -- Employees under each manager
    SELECT
        e.staff_id,
        e.first_name,
        e.last_name,
        e.manager_id,
        m.first_name AS manager_first_name,
        oc.level + 1 AS level
    FROM sales.staffs AS e
    JOIN org_chart AS oc
        ON e.manager_id = oc.staff_id
    JOIN sales.staffs AS m
        ON e.manager_id = m.staff_id
)
SELECT
    staff_id,
    first_name,
    last_name,
    manager_first_name,
    level
FROM org_chart
ORDER BY level, staff_id
OPTION (MAXRECURSION 100);


No. A CTE does not guarantee that its result is computed only once. The optimizer decides how the query is executed. If the result must genuinely be computed once and reused, materialize it in a temporary table or another appropriate persisted/materialized structure.
