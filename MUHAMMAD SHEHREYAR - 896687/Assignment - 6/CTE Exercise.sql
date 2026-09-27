-- Muhammad Shehreyar
-- CTE Exercises 6.1 - 6.6


/* =========================================================
   6.1 — Rewrite the derived table query as a CTE
   ========================================================= */

WITH store_counts AS
(
    SELECT
        store_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT
    AVG(order_count) AS avg_orders
FROM store_counts;


/* =========================================================
   6.2 — High Value Products
   Write a CTE called cte_high_value_products that returns
   products with list_price > 2000.
   Then return only Mountain Bikes.
   ========================================================= */

WITH cte_high_value_products AS
(
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


/* =========================================================
   6.3 — Two CTEs in one WITH clause
   Count orders per customer and sum revenue per customer.
   ========================================================= */

WITH order_counts AS
(
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
customer_revenue AS
(
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.list_price) AS total_revenue
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


/* =========================================================
   6.4 — Recursive CTE
   Generate numbers from 1 to 10 and their squares.
   ========================================================= */

WITH numbers AS
(
    -- Anchor member
    SELECT
        1 AS n,
        1 * 1 AS square

    UNION ALL

    -- Recursive member
    SELECT
        n + 1,
        (n + 1) * (n + 1)
    FROM numbers
    WHERE n < 10
)
SELECT
    n,
    square
FROM numbers
OPTION (MAXRECURSION 10);


/* =========================================================
   6.5 — Recursive CTE Org Chart
   Show manager's first name and employee level.
   Level 0 = top manager
   Level 1 = direct reports
   Level 2 = next level down
   ========================================================= */

WITH org_chart AS
(
    -- Top manager
    SELECT
        staff_id,
        first_name,
        last_name,
        manager_id,
        first_name AS manager_first_name,
        0 AS level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    -- Employees under the manager
    SELECT
        s.staff_id,
        s.first_name,
        s.last_name,
        s.manager_id,
        m.first_name AS manager_first_name,
        oc.level + 1 AS level
    FROM sales.staffs AS s
    JOIN org_chart AS oc
        ON s.manager_id = oc.staff_id
    JOIN sales.staffs AS m
        ON s.manager_id = m.staff_id
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


/* =========================================================
   6.6 — Think About It
   A CTE is not automatically calculated once and reused.
   If the result genuinely needs to be calculated once and
   reused, a temporary table can be used.
   ========================================================= */

-- Example:

SELECT
    store_id,
    COUNT(*) AS order_count
INTO #store_counts
FROM sales.orders
GROUP BY store_id;

-- Reuse the temporary table:

SELECT *
FROM #store_counts;

SELECT AVG(order_count) AS avg_orders
FROM #store_counts;

-- Clean up the temporary table:
DROP TABLE #store_counts;

-- Short answer:
-- No. A CTE does not guarantee that its result is calculated
-- only once and reused. If the result must genuinely be
-- materialized and reused, use a temporary table such as #temp.
