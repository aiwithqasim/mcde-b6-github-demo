									-- Assignment # 06 --
							----- Common Table Expressions -----

/*6.1 — Rewrite this derived table query as a CTE*/

SELECT 
    AVG(order_count) AS avg_orders
FROM (
       SELECT 
            store_id, 
            COUNT(*) AS order_count
       FROM sales.orders
       GROUP BY store_id
) AS store_counts;

-- As a CTE --

WITH cte_order_counts AS (
    SELECT
        store_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
),
cte_avg_order_count AS (
    SELECT
        AVG(order_count) AS avg_orders
    FROM cte_order_counts
)
SELECT * FROM cte_avg_order_count;
    
/*6.2 — Write a CTE called cte_high_value_products that returns products with list_price > 2000. Then query the CTE to return only 
Mountain Bikes from that list, joining to production.categories*/

WITH cte_high_value_products AS (
    SELECT
        p.product_id,
        p.product_name,
        p.list_price,
        p.category_id
    FROM production.products AS p
    WHERE list_price > 2000
)
SELECT
    hp.product_id,
    hp.product_name,
    hp.list_price,
    c.category_id,
    c.category_name
FROM cte_high_value_products AS hp
INNER JOIN production.categories AS c
    ON c.category_id = hp.category_id
WHERE c.category_name = 'Mountain Bikes'
ORDER BY hp.list_price DESC;


/*6.3 — Write two CTEs in one WITH clause: one that counts orders per customer, and one that sums revenue per customer. 
Join them in the outer query to return customer_id, order_count, and total_revenue side by side*/

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS order_counts
    FROM sales.orders
    GROUP BY customer_id
),
customer_revenue AS (
    SELECT
        customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS Total_revenue
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON oi.order_id = o.order_id
    GROUP BY customer_id
)
    SELECT
        co.customer_id,
        co.order_counts,
        cr.Total_revenue
    FROM customer_revenue AS cr
    INNER JOIN customer_orders AS co
        ON co.customer_id = cr.customer_id
    ORDER BY co.customer_id;

/*6.4 — Using a recursive CTE, generate a list of numbers from 1 to 10. Each row should have the number and its square (n * n)*/

WITH numbers AS (
    SELECT 
        1 AS n,
        1 + 1 As square
    UNION ALL
    SELECT 
        (n + 1),
        (n + 1) * (n + 1)
    FROM numbers
    WHERE n < 10
)
SELECT * FROM numbers;


/*6.5 — Using the recursive CTE org chart from section 9.6.2 as a starting point, modify it to also show the manager's first_name alongside 
each employee. Add a level column (0 for the top manager, 1 for their direct reports, 2 for the next level down)*/

WITH cte_org AS (
    -- Anchor: get the top manager (no manager_id)
    SELECT
        staff_id,
        first_name,
        manager_id
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: get each manager's direct reports
    SELECT
        e.staff_id,
        e.first_name,
        e.manager_id
    FROM sales.staffs e
    INNER JOIN cte_org o ON o.staff_id = e.manager_id
)
SELECT * FROM cte_org;

------ Modify -----
WITH cte_org AS (
    -- Anchor: get the top manager (no manager_id)
    SELECT
        s.staff_id,
        s.first_name,
        s.manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_first_name,
        0 AS level
    FROM sales.staffs As s
    WHERE s.manager_id IS NULL

    UNION ALL

    -- Recursive: get each manager's direct reports
    SELECT
        e.staff_id,
        e.first_name,
        e.manager_id,
        o.first_name AS manger_first_name,
        o.level + 1 AS level
    FROM sales.staffs e
    INNER JOIN cte_org o 
        ON e.manager_id = o.staff_id
)
SELECT 
    staff_id,
    first_name,
    manager_first_name,
    manager_id,
    level
FROM cte_org
ORDER BY 
    level,
    staff_id;

/*6.6 — Think About It: A CTE is defined once but referenced twice in the same outer query. A colleague says "CTEs are faster than 
subqueries because the database computes the result once and reuses it." Is this claim accurate? What would you need to do if you 
genuinely needed the result computed only once and reused?*/

/*Answer. No. A CTE does not guarantee that its result is computed once and reused. A CTE is primarily a named query expression used 
for readability and query organization, and SQL Server's optimizer determines the execution plan. If I genuinely need to materialize an
intermediate result and reuse it, I can use a temporary table such as #temp_table and optionally index it*/

