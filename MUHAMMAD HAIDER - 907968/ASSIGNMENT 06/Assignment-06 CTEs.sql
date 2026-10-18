/*========================================================================================================================
6.1 — Rewrite this derived table query as a CTE:

SELECT AVG(order_count) AS avg_orders
FROM (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
) AS store_counts;
========================================================================================================================*/ 
WITH store_counts AS(
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
    )
SELECT 
    AVG(order_count) AS avg_orders
FROM store_counts;

/*========================================================================================================================
6.2 — Write a CTE called cte_high_value_products that returns products with list_price > 2000. Then query the CTE to return
only Mountain Bikes from that list, joining to production.categories.
========================================================================================================================*/
WITH cte_high_value_prods AS (
    SELECT
        product_id,
        product_name,
        list_price,
        category_id
    FROM production.products
    WHERE list_price > 2000
    )
SELECT 
    hvp.product_id,
    hvp.product_name,
    hvp.list_price,
    c.category_name
FROM cte_high_value_prods hvp
INNER JOIN production.categories c
    ON hvp.category_id = c.category_id
WHERE category_name = 'Mountain Bikes';

/*========================================================================================================================
6.3 — Write two CTEs in one WITH clause: one that counts orders per customer, and one that sums revenue per customer. 
Join them in the outer query to return customer_id, order_count, and total_revenue side by side.
========================================================================================================================*/
WITH orders_per_cust AS (
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM sales.orders
    GROUP BY customer_id
    ),
revenue_per_cust AS(
    SELECT
        o.customer_id,
        SUM(oi.list_price * oi.quantity * (1- oi.discount)) AS total_revenue
    FROM sales.orders o
    INNER JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
    )
SELECT
    rpc.customer_id,
    opc.order_count,
    rpc.total_revenue
FROM orders_per_cust opc
INNER JOIN revenue_per_cust rpc
    ON opc.customer_id = rpc.customer_id;

/*========================================================================================================================
6.4 — Using a recursive CTE, generate a list of numbers from 1 to 10. Each row should have the number and its square (n * n).
========================================================================================================================*/
WITH NumbersCTE AS (
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM NumbersCTE
    WHERE n < 10 -- Stop condition
)
SELECT 
    n, 
    (n * n) AS square
FROM NumbersCTE;

/*========================================================================================================================
6.5 — Using the recursive CTE org chart from section 9.6.2 as a starting point, modify it to also show the manager's 
first_name alongside each employee. Add a level column (0 for the top manager, 1 for their direct reports, 2 for the
next level down).
========================================================================================================================*/
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
    INNER JOIN cte_org o 
        ON o.staff_id = e.manager_id
)
SELECT 
    staff_id,
    first_name,
    manager_id,
    manager_first_name,
    level
FROM cte_org;

/*========================================================================================================================
6.6 — Think About It: A CTE is defined once but referenced twice in the same outer query. A colleague says "CTEs are
faster than subqueries because the database computes the result once and reuses it." Is this claim accurate? What would
you need to do if you genuinely needed the result computed only once and reused?
========================================================================================================================*/
-- ANSWER
/*
Is the claim accurate?
No, the claim is inaccurate.

Why?
In SQL Server, a CTE is an inline view/alias. If a CTE is referenced twice in the outer query, the database engine evaluates
and computes the CTE query twice, rather than caching or reusing the result.

What to do if you need the result computed once and reused?
Use a Temporary Table (#TempTable). Store the intermediate query result into a #TempTable first, and then reference that 
temporary table multiple times in your outer query. This guarantees the logic is calculated only once.
*/
