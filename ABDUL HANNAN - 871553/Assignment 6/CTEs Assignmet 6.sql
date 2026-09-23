--								ASSIGNMENT NO 6  CTEs
USE BikeStores
GO
-- 6.1 — Rewrite this derived table query as a CTE:
with store_count AS(
SELECT store_id ,COUNT(*) AS order_count
FROM 
sales.orders
GROUP BY store_id
)
select AVG(order_count) AS AVG_COUNT
from
store_count;
-- 6.1 END


-- 6.2 — Write a CTE called cte_high_value_products that returns products with list_price > 2000. 
--Then query the CTE to return only Mountain Bikes from that list, joining to production.categories.
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
    p.product_name,
    p.list_price,
    c.category_id,
    c.category_name
FROM cte_high_value_products p
INNER JOIN production.categories c 
    ON p.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';
-- 6.2  END


-- 6.3 — Write two CTEs in one WITH clause: one that counts orders per customer, and one that sums
--revenue per customer. Join them in the outer query to return customer_id, order_count, and total_revenue
--side by side.
WITH count_orders AS (
    -- CTE 1: Har customer ne kitne orders kiye
    SELECT 
        customer_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
customer_revenue AS (
    -- CTE 2: Har customer ne kitni revenue di
    SELECT 
        o.customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.orders o
    INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
-- Outer Query: Dono ko side by side jorna
SELECT 
    co.customer_id,
    co.order_count,
    cr.total_revenue
FROM count_orders co
INNER JOIN customer_revenue cr 
    ON co.customer_id = cr.customer_id
ORDER BY co.customer_id;
-- 6.3 END


-- 6.4 — Using a recursive CTE, generate a list of numbers from 1 to 10. Each row should have the number 
--and its square (n * n).
WITH numbers AS (
    -- Anchor
    SELECT 1 AS n
    
    UNION ALL
    
    -- Recursive: Agla number banao
    SELECT n + 1
    FROM numbers
    WHERE n < 10
)
select 
n,
n * n AS square
from
numbers;
-- 6.4 END


/*6.5 — Using the recursive CTE org chart from section 9.6.2 as a starting point, modify it to also show 
the manager's first_name alongside each employee. Add a level column (0 for the top manager, 1 for their
direct reports, 2 for the next level down).*/
WITH staff_hierarchy AS (
    -- Anchor: Top manager, level 0, uska koi manager nahi
    SELECT 
        staff_id,
        first_name,
        manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_first_name,
        0 AS level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: Har employee ke saath uske manager ka naam lao
    SELECT 
        s.staff_id,
        s.first_name,
        s.manager_id,
        h.first_name AS manager_first_name,
        h.level + 1 AS level
    FROM sales.staffs s
    INNER JOIN staff_hierarchy h ON s.manager_id = h.staff_id
)
SELECT 
    staff_id,
    first_name,
    manager_first_name,
    level
FROM staff_hierarchy
ORDER BY level, staff_id;
-- 6.5 END


/*6.6 — Think About It: A CTE is defined once but referenced twice in the same outer query. A colleague says
"CTEs are faster than subqueries because the database computes the result once and reuses it." Is this claim
accurate? What would you need to do if you genuinely needed the result computed only once and reused?*/

/*Answer 6.6:
No, the claim is not accurate. In SQL Server a non-recursive CTE is just a named subquery / syntax shortcut
for readability. The optimizer usually inlines it. If you reference the same CTE twice in the outer query, 
the underlying query will be executed twice, it is not materialized and reused automatically. So it is not
faster than a subquery.

If I genuinely need the result computed only once and reused, I would materialize it myself by using a temp
table SELECT ... INTO #temp or a table variable @table, and then reference that temp table multiple times 
in the outer query. */

-- 6.6 END

