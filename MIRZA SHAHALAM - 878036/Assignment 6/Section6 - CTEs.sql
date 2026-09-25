-- 6.1 — Rewrite this derived table query as a CTE:

''' SELECT AVG(order_count) AS avg_orders
    FROM (
        SELECT store_id, COUNT(*) AS order_count
        FROM sales.orders
        GROUP BY store_id
    ) AS store_counts; '''

WITH store_counts as (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count) AS avg_orders
FROM store_counts

-- 6.2 — Write a CTE called cte_high_value_products that returns products with list_price > 2000. Then query
-- the CTE to return only Mountain Bikes from that list, joining to production.categories.

WITH cte_high_value_products as (
    SELECT * FROM production.products
    WHERE list_price > 2000
)
SELECT
    p.product_id,
    p.product_name,
    p.list_price,
    c.category_name
FROM cte_high_value_products as p
INNER JOIN production.categories as c
    ON p.category_id = c.category_id
    WHERE c.category_name = 'Mountain Bikes'

-- 6.3 — Write two CTEs in one WITH clause: one that counts orders per customer, and one that sums revenue per
-- customer. Join them in the outer query to return customer_id, order_count, and total_revenue side by side.

WITH counts_orders as (
    SELECT
        customer_id, COUNT(*) as order_count
    FROM sales.orders
    GROUP BY customer_id
),
sums_revenue as (
    SELECT
        o.customer_id,
            SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
    FROM sales.orders as o
    INNER JOIN sales.order_items as oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    co.customer_id,
    co.order_count,
    sr.total_revenue
FROM counts_orders as co
INNER JOIN sums_revenue as sr
    ON co.customer_id = sr.customer_id

-- 6.4 — Using a recursive CTE, generate a list of numbers from 1 to 10. Each row should have the number 
-- and its square (n * n).

WITH numeric_cte as (
    SELECT
        1 as number
    UNION ALL
    SELECT
        number + 1
    FROM numeric_cte
        WHERE number < 10
)
SELECT
    number,
    number * number as square
FROM numeric_cte

-- 6.5 — Using the recursive CTE org chart from section 9.6.2 as a starting point, modify it to also show the 
-- manager's first_name alongside each employee. Add a level column (0 for the top manager, 1 for their direct 
-- reports, 2 for the next level down).

WITH cte_org AS (
    SELECT
        staff_id,
        first_name,
        manager_id,
        0 as level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL
    SELECT
        e.staff_id,
        e.first_name,
        e.manager_id,
        o.level + 1
    FROM sales.staffs as e
    INNER JOIN cte_org as o
        ON o.staff_id = e.manager_id
)
SELECT
    o.staff_id,
    o.first_name,
    s.first_name as manager_name,
    o.level
FROM cte_org as o
LEFT JOIN sales.staffs as s
    ON o.manager_id = s.staff_id

-- 6.6 — Think About It: A CTE is defined once but referenced twice in the same outer query. A colleague says "CTEs
-- are faster than subqueries because the database computes the result once and reuses it." Is this claim accurate?
-- What would you need to do if you genuinely needed the result computed only once and reused?

-- Ans: A CTE is not faster than a subquery because SQL Server may execute the CTE multiple times when
-- referenced more than once. If we need the result computed once and reused, we can store it in a temporary table.