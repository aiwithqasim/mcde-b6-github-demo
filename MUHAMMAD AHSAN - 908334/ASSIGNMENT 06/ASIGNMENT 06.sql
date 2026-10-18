-- =========================================
-- 6.1 — Derived Table to CTE
-- =========================================

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


-- =========================================
-- 6.2 — High Value Products CTE
-- =========================================

WITH cte_high_value_products AS (
    SELECT
        product_id,
        product_name,
        brand_id,
        category_id,
        list_price
    FROM production.products
    WHERE list_price > 2000
)
SELECT
    h.product_id,
    h.product_name,
    h.list_price,
    c.category_name
FROM cte_high_value_products AS h
INNER JOIN production.categories AS c
    ON h.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';


-- =========================================
-- 6.3 — Two CTEs: Order Count + Revenue
-- =========================================

WITH customer_orders AS (
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
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    co.customer_id,
    co.order_count,
    cr.total_revenue
FROM customer_orders AS co
INNER JOIN customer_revenue AS cr
    ON co.customer_id = cr.customer_id;


-- =========================================
-- 6.4 — Recursive CTE: Numbers 1 to 10
-- =========================================

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


-- =========================================
-- 6.5 — Recursive CTE: Organization Chart
-- =========================================

WITH org_chart AS (
    -- Top manager
    SELECT
        s.staff_id,
        s.first_name,
        s.last_name,
        s.manager_id,
        CAST(NULL AS VARCHAR(100)) AS manager_first_name,
        0 AS level
    FROM sales.staffs AS s
    WHERE s.manager_id IS NULL

    UNION ALL

    -- Employees under each manager
    SELECT
        s.staff_id,
        s.first_name,
        s.last_name,
        s.manager_id,
        oc.first_name AS manager_first_name,
        oc.level + 1 AS level
    FROM sales.staffs AS s
    INNER JOIN org_chart AS oc
        ON s.manager_id = oc.staff_id
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


-- =========================================
-- 6.6 — Think About It
-- =========================================

-- No query is required for this question.
--
-- A CTE is NOT automatically faster than a subquery.
-- A CTE does not necessarily compute its result once
-- and reuse it.
--
-- If you genuinely need the result to be computed once
-- and reused, use a temporary table such as:
--
-- SELECT ...
-- INTO #temp_table
-- FROM ...;
--
-- Then reference #temp_table multiple times.