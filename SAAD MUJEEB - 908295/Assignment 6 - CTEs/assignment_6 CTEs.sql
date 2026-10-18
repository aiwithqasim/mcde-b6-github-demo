-- Assignment 6 CTEs
---------------------

-- EXCERCISE 6.1

WITH store_counts AS (
    SELECT 
        store_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count) AS avg_orders
FROM store_counts;



-- EXCERCISE 6.2

WITH cte_high_value_products AS (
    SELECT
        product_id,
        product_name,
        category_id,
        list_price
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

-- EXCERCISE 6.3

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


-- EXCERCISE 6.4

WITH Numbers AS (
    -- Anchor member
    SELECT
        1 AS n,
        1 * 1 AS square

    UNION ALL

    -- Recursive member
    SELECT
        n + 1,
        (n + 1) * (n + 1)
    FROM Numbers
    WHERE n < 10
)
SELECT
    n,
    square
FROM Numbers
OPTION (MAXRECURSION 10);


-- EXCERCISE 6.5

WITH org_chart AS (
    -- Top-level manager
    SELECT
        staff_id,
        first_name,
        last_name,
        manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_first_name,
        0 AS level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    -- Employees under each manager
    SELECT
        s.staff_id,
        s.first_name,
        s.last_name,
        s.manager_id,
        o.first_name AS manager_first_name,
        o.level + 1 AS level
    FROM sales.staffs AS s
    INNER JOIN org_chart AS o
        ON s.manager_id = o.staff_id
)
SELECT
    staff_id,
    first_name,
    last_name,
    manager_first_name,
    level
FROM org_chart
ORDER BY level, staff_id;


-- EXCERCISE 6.6

-- A CTE is mainly a query-writing/readability feature. In SQL Server, a CTE is generally not automatically
-- materialized or computed once and stored for reuse. If you reference the same CTE twice, the optimizer may choose
-- to execute its underlying logic more than once.


