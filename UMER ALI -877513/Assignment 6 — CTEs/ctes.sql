-- CTE's
-- task 1 
WITH store_counts AS (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count) AS avg_orders
FROM store_counts;

--task 2 
WITH cte_high_value_products AS (
    SELECT product_id, product_name, category_id, list_price
    FROM production.products
    WHERE list_price > 2000
)
SELECT p.product_id, p.product_name, p.list_price, c.category_name
FROM cte_high_value_products  p
JOIN production.categories  c
    ON p.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';

--task 3
WITH order_counts AS (
    SELECT customer_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
revenue_totals AS (
    SELECT o.customer_id,
           SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.orders  o
    JOIN sales.order_items  oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT oc.customer_id, oc.order_count, rt.total_revenue
FROM order_counts  oc
JOIN revenue_totals  rt
    ON oc.customer_id = rt.customer_id;

--task 4

WITH cte_numbers (n, n_squared) AS (
    SELECT 1, 1                        
    UNION ALL
    SELECT n + 1, (n + 1) * (n + 1)    
    FROM cte_numbers
    WHERE n < 10                         
)
SELECT n, n_squared
FROM cte_numbers;

--task 5
WITH cte_org AS (
    SELECT
        staff_id,
        first_name,
        manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_first_name,
        0 AS level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.staff_id,
        e.first_name,
        e.manager_id,
        o.first_name AS manager_first_name,
        o.level + 1 AS level
    FROM sales.staffs e
    INNER JOIN cte_org o ON o.staff_id = e.manager_id
)
SELECT staff_id, first_name, manager_first_name, level
FROM cte_org
ORDER BY level, staff_id;

--task 6.6 —
--Think About It: A CTE is defined once but referenced twice in the same outer query. A colleague says "CTEs are faster than subqueries because the database computes the result once and reuses it." Is this claim accurate? What would you need to do if you genuinely needed the result computed only once and reused?
--answer:
--The claim isn't fully accurate — SQL Server can inline and re-execute a CTE once per reference, just like a subquery. It's not guaranteed to compute once. To force single computation, materialize the result into a temp table (SELECT ... INTO #temp) or table variable, since SQL Server has no per-CTE materialization hint like Postgres's MATERIALIZED.