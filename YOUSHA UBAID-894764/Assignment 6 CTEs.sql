--Common Table Expressions (CTEs)

--6.1 — Rewrite this derived table query as a CTE
WITH store_counts AS (
    SELECT
        store_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count) AS avg_orders
FROM store_counts;


--6.2 Write a CTE called cte_high_value_products that returns products with list_price > 2000. Then query the CTE to return only Mountain Bikes from that list, joining to production.categories.

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


--6.3 — Write two CTEs in one WITH clause: one that counts orders per customer, and one that sums revenue per customer. Join them in the outer query to return customer_id, order_count, and total_revenue side by side.

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


--6.4 — Using a recursive CTE, generate a list of numbers from 1 to 10. Each row should have the number and its square (n * n).

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

--6.5 — Using the recursive CTE org chart from section 9.6.2 as a starting point, modify it to also show the manager's first_name alongside each employee. Add a level column (0 for the top manager, 1 for their direct reports, 2 for the next level down).

WITH org_chart AS (
    SELECT
        e.staff_id,
        e.first_name,
        e.last_name,
        e.manager_id,
        e.first_name AS manager_first_name,
        0 AS level
    FROM sales.staffs AS e
    WHERE e.manager_id IS NULL

    UNION ALL

    SELECT
        e.staff_id,
        e.first_name,
        e.last_name,
        e.manager_id,
        m.first_name AS manager_first_name,
        o.level + 1 AS level
    FROM sales.staffs AS e
    JOIN org_chart AS o
        ON e.manager_id = o.staff_id
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


--6.6 — Think About It: A CTE is defined once but referenced twice in the same outer query. A colleague says "CTEs are faster than subqueries because the database computes the result once and reuses it." Is this claim accurate? What would you need to do if you genuinely needed the result computed only once and reused?

SELECT
    customer_id,
    COUNT(*) AS order_count
INTO #customer_orders
FROM sales.orders
GROUP BY customer_id;

SELECT *
FROM #customer_orders;

SELECT
    AVG(order_count) AS avg_orders
FROM #customer_orders;

DROP TABLE #customer_orders;