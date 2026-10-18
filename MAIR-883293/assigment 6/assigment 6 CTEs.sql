----CTEs Assigment 06 --------------
---ALL EXCERCISES---
---6.1 — Rewrite this derived table query as a CTE:

--SELECT AVG(order_count) AS avg_orders 
--FROM ( SELECT store_id, COUNT(*) AS order_count 
--FROM sales.orders GROUP BY store_id ) AS store_counts;


WITH store_counts AS (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count) AS avg_orders
FROM store_counts;

---6.2 — Write a CTE called cte_high_value_products that returns products with list_price > 2000. Then query the CTE to return only Mountain Bikes from that list, joining to production.categories

WITH cte_high_value_products AS (
    SELECT *
    FROM production.products
    WHERE list_price > 2000
)
SELECT p.*
FROM cte_high_value_products AS p
JOIN production.categories AS c
    ON p.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';

---6.3 — Write two CTEs in one WITH clause: one that counts orders per customer, and one that sums revenue per customer. Join them in the outer query to return customer_id, order_count, and total_revenue side by side.

WITH order_counts AS (
    SELECT customer_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
customer_revenue AS (
    SELECT o.customer_id,
           SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_revenue
    FROM sales.orders AS o
    JOIN sales.order_items AS i
        ON o.order_id = i.order_id
    GROUP BY o.customer_id
)
SELECT oc.customer_id,
       oc.order_count,
       cr.total_revenue
FROM order_counts AS oc
inner JOIN customer_revenue AS cr
    ON oc.customer_id = cr.customer_id;


---6.4 — Using a recursive CTE, generate a list of numbers from 1 to 10. Each row should have the number and its square (n * n). is ka matlab or query

WITH numbers AS (
    -- Anchor: Starting number
    SELECT 1 AS n
    UNION ALL
    -- Recursive: Add 1 to the previous number
    SELECT n + 1
    FROM numbers
    WHERE n < 10
)
SELECT n, n * n AS square
FROM numbers
OPTION (MAXRECURSION 10);


--6.5 — Using the recursive CTE org chart from section 9.6.2 as a starting point, modify it to also show the manager's first_name alongside each employee. Add a level column (0 for the top manager, 1 for their direct reports, 2 for the next level down).

WITH org_chart AS (
 -- Anchor: Top manager
    SELECT
        s.staff_id,
        s.first_name,
        s.manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_first_name,
        0 AS level
    FROM sales.staffs AS s
    WHERE s.manager_id IS NULL

    UNION ALL

-- Recursive: Employees under each manager
    SELECT
        e.staff_id,
        e.first_name,
        e.manager_id,
        m.first_name AS manager_first_name,
        o.level + 1 AS level
    FROM sales.staffs AS e
  INNER  JOIN org_chart AS o
        ON e.manager_id = o.staff_id
  INNER  JOIN sales.staffs AS m
        ON e.manager_id = m.staff_id
)
SELECT
    staff_id,
    first_name,
    manager_first_name,
    level
FROM org_chart
ORDER BY level, staff_id
OPTION (MAXRECURSION 100);


--- 6.6 — Think About It: A CTE is defined once but referenced twice in the same outer query. A colleague says "CTEs are faster than subqueries because the database computes the result once and reuses it." Is this claim accurate? What would you need to do if you genuinely needed the result computed only once and reused?

WITH customer_orders AS (
    SELECT customer_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
)
SELECT
    a.customer_id,
    a.order_count,
    b.order_count
FROM customer_orders AS a
INNER JOIN customer_orders AS b
    ON a.customer_id = b.customer_id;
