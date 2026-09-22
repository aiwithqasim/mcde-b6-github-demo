--6.1 — Rewrite this derived table query as a CTE:

--SELECT AVG(order_count) AS avg_orders
--FROM (
--    SELECT store_id, COUNT(*) AS order_count
--    FROM sales.orders
--    GROUP BY store_id
--) AS store_counts;
WITH cte_stores AS (
 SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count) AS avg_orders
FROM cte_stores;

--6.2 — Write a CTE called cte_high_value_products that returns products with list_price > 2000.
--Then query the CTE to return only Mountain Bikes from that list, joining to production.categories.
WITH cte_high_value_products AS (
  SELECT 
  p.product_id,
  p.product_name,
  p.category_id,
  p.list_price
  FROM production.products p
  WHERE p.list_price > 2000
)
SELECT   
p.product_id,
p.product_name,
p.list_price,
c.category_name 
FROM cte_high_value_products p
JOIN production.categories c
ON p.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';

--6.3 — Write two CTEs in one WITH clause: one that counts orders per customer, 
--and one that sums revenue per customer. Join them in the outer query to return customer_id, order_count, and total_revenue side by side.
WITH cte_customers AS (
  SELECT 
  c.customer_id,
  c.first_name + ' ' + c.last_name AS customer_name,
  c.city,
  COUNT(o.order_id) AS order_count
  FROM sales.customers c
  JOIN sales.orders o
  ON c.customer_id = o.customer_id
  GROUP BY c.customer_id,
  c.first_name,c.last_name,c.city
),
cte_revenue AS(
    SELECT
    c.customer_id,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.order_items oi
    JOIN sales.orders o
    ON o.order_id = oi.order_id
    JOIN sales.customers c
    ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)
SELECT
cc.customer_id,
cc.order_count,
cr.total_revenue
FROM cte_customers cc
JOIN cte_revenue cr
ON cc.customer_id = cr.customer_id
ORDER BY cc.customer_id;

--6.4 — Using a recursive CTE, generate a list of numbers from 1 to 10. Each row should have the number and its square (n * n).
WITH cte_numbers AS
(
  SELECT 1 AS n

  UNION ALL

  SELECT n + 1
  FROM cte_numbers
  WHERE n < 10
)
SELECT
n,
n * n AS square
FROM cte_numbers;

--6.5 — Using the recursive CTE org chart from section 9.6.2 as a starting point, modify it to
--also show the manager's first_name alongside each employee. 
--Add a level column (0 for the top manager, 1 for their direct reports, 2 for the next level down).
WITH cte_org AS (
    SELECT
    staff_id,
    first_name,
    manager_id,
    0 AS level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    
    SELECT
    e.staff_id,
    e.first_name,
    e.manager_id,
    o.level + 1 AS level
    FROM sales.staffs e
    INNER JOIN cte_org o
    ON e.manager_id = o.staff_id
)
SELECT
o.staff_id,
o.first_name,
m.first_name AS manager_first_name,
o.level
FROM cte_org o
LEFT JOIN sales.staffs m
ON o.manager_id = m.staff_id;

--6.6 — Think About It:** A CTE is defined once but referenced twice in the same outer query.
--A colleague says "CTEs are faster than subqueries because the database computes the result once and reuses it.
--" Is this claim accurate? What would you need to do if you genuinely needed the result computed only once and reused?  

--ANSWER
--No, this is not always true. A CTE does not guarantee that the result is calculated only once. 
--If I need to calculate it once and reuse it, I can use a temporary table.
