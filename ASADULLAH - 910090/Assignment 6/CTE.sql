-- Task 6.2
WITH   AVG
AS     (SELECT AVG(order_count) AS avg_orders
        FROM   (SELECT   store_id,
                         COUNT(*) AS order_count
                FROM     sales.orders
                GROUP BY store_id) AS store_counts)
SELECT *
FROM   AVG;

-- Task 6.3
WITH   cte_high_value_products
AS     (SELECT pp.product_name,
               pp.list_price,
               pp.category_id
        FROM   production.products AS pp
        WHERE  pp.list_price > 2000)
SELECT h.product_name,
       h.list_price,
       c.category_name
FROM   cte_high_value_products AS h
       INNER JOIN
       production.categories AS c
       ON h.category_id = c.category_id
WHERE  category_name = 'Mountain Bikes';

-- Task 6.4
WITH   cte_numbers
AS     (SELECT 1 AS n
        UNION ALL
        SELECT n + 1
        FROM   cte_numbers
        WHERE  n < 10)
SELECT n,
       n * n AS square
FROM   cte_numbers;

-- Task 6.5
WITH   cte_org
AS     (SELECT staff_id,
               first_name,
               manager_id,
               first_name AS manager_name,
               0 AS level
        FROM   sales.staffs
        WHERE  manager_id IS NULL
        UNION ALL
        SELECT s.staff_id,
               s.first_name,
               s.manager_id,
               o.first_name AS manager_name,
               o.level + 1 AS level
        FROM   sales.staffs AS s
               INNER JOIN
               cte_org AS o
               ON s.manager_id = o.staff_id)
SELECT staff_id,
       first_name AS employee_name,
       manager_name,
       level
FROM   cte_org;


-- Task 6.6:
-- Think About It:
-- A CTE is defined once but referenced twice in the same outer query. 
-- A colleague says "CTEs are faster than subqueries because the database computes the result once and reuses it." 
-- Is this claim accurate? What would you need to do if you genuinely needed the result computed only once and reused?
-- THINKING:
-- A CTE is not necessarily calculated only once. Even if we reference the CTE multiple times,
-- the database optimizer may execute its query again instead of reusing the same result.
-- If we really want to calculate the result once and reuse it,
-- we can store it in a temporary table (`#temp`) and then use that table multiple times.