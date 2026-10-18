--6.1 — Rewrite this derived table query as a CTE:
--SELECT AVG(order_count) AS avg_orders
--FROM (
--    SELECT store_id, COUNT(*) AS order_count
--    FROM sales.orders
--    GROUP BY store_id
--) AS store_counts;

WITH store_counts AS (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
  )
SELECT AVG(order_count) AS avg_orders 
FROM store_counts

--6.2 - write a CTE called cte_high_value_products that returns the products
--with list_price greater than 2000 (list_price > 2000). Then query the CTE
--to return Mountain Bikes from the list, joining to production.categories

with cte_high_value_products AS 
(
select * from production.products
WHERE list_price > 2000
)
select * from cte_high_value_products AS cte
inner join production.categories AS c
ON c.category_id = cte.category_id
where c.category_name = 'Mountain Bikes'

--6.3 - Write two CTEs in one WITH clause: one that counts orders per
--customer, and one that sums revenue per customer. Join them in outer query
--to return customer_id, order_count and total_revenue side by side.

with order_count AS
(
select 
customer_id, 
COUNT(order_id) AS total_orders
from  sales.orders
group by customer_id
),
total_revenue AS
(
select 
o.customer_id, 
SUM(quantity * list_price * (1-discount)) AS total_revenue
from sales.orders AS o
inner join sales.order_items AS oi
ON o.order_id = oi.order_id
group by o.customer_id
)
select oc.customer_id, oc.total_orders, tr.total_revenue   
from order_count AS oc
inner join total_revenue AS tr
ON tr.customer_id = oc.customer_id
order by oc.customer_id;


--6.4 - Using the recursive CTE, generate a list of numbers from 1 to 10. Each row
--should have the number and its square (n * n)

With sql_numbers AS (
    select 
            1 AS n,
            1 AS sqr
        UNION ALL
    select 
            n + 1, 
            (n+1) * (n+1)
    from sql_numbers
    where n < 10 )
select * from sql_numbers;


--6.5 - Using the recursive CTE org chart from section 9.6.2 as a starting point
--modify it to also show the manager's first_name alongside each employee. Add a
--level column (0 for the top manager, 1 for their direct reports, 2 for the 
--next level down)


WITH OrgChart_CTE AS (
    -- Anchor Member: Top manager 
    SELECT 
        staff_id,
        first_name,
        manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_first_name, 
        0 AS level
    FROM 
        sales.staffs
    WHERE 
        manager_id IS NULL

    UNION ALL

    -- Recursive Employees
    SELECT 
        s.staff_id,
        s.first_name,
        s.manager_id,
        m.first_name AS manager_first_name,
        m.level + 1 AS level 
    FROM 
        sales.staffs AS s
    INNER JOIN 
        OrgChart_CTE m ON s.manager_id = m.staff_id
)
-- Final Select query
SELECT 
    staff_id,
    first_name,
    manager_id,
    manager_first_name,
    level
FROM 
    OrgChart_CTE
ORDER BY 
    level, manager_id;


6.6 — Think About It: A CTE is defined once but referenced twice in the same outer query.
A colleague says "CTEs are faster than subqueries because the database computes the result
once and reuses it." Is this claim accurate? What would you need to do if you genuinely 
needed the result computed only once and reused?

--1. Is the claim accurate?
--No, the claim is generally inaccurate. In most modern database engines (like SQL Server),
--a Common Table Expression (CTE) is treated as a disposable view.
--It is primarily used for query readability, not performance. If you reference a CTE 
--twice in the outer query, the database will execute the query twice—just like a subquery.

--2. Use a Temporary Table (#TempTable): Insert the CTE results into a temporary table first
--The database will compute it once, store it in memory/disk, and let you reference it 
--multiple times efficiently.
