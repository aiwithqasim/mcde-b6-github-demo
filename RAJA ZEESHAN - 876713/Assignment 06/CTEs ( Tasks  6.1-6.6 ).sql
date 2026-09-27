
--- Assignment 06: Common Table Expressions (CTEs) ---

-- TASK 6.1: Rewrite derived table query as CTE:

WITH store_counts AS (
SELECT store_id, COUNT(*) AS order_count
FROM sales.orders
GROUP BY store_id
)
SELECT AVG(order_count) AS avg_orders
FROM store_counts;

-- TASK 6.2: Write a CTE called cte_high_value_products that returns products with list_price > 2000. Then query the CTE to return only Mountain Bikes from that list, joining to production.categories.

WITH cte_high_value_products AS (
SELECT p.product_id, p.product_name, p.category_id, p.list_price
FROM production.products p
WHERE p.list_price > 2000
)
SELECT hvp.product_id, hvp.product_name, hvp.list_price, c.category_name
FROM cte_high_value_products hvp
JOIN production.categories c ON hvp.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';


-- TASK 6.3: Write two CTEs in one WITH clause: one that counts orders per customer, and one that sums revenue per customer. Join them in the outer query to return customer_id, order_count, and total_revenue side by side.

WITH customer_orders AS (
SELECT customer_id, COUNT(order_id) AS order_count
FROM sales.orders
GROUP BY customer_id
),
customer_revenue AS (
SELECT o.customer_id, SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.order_items i ON o.order_id = i.order_id
GROUP BY o.customer_id
)
SELECT 
co.customer_id, 
co.order_count, 
ROUND(cr.total_revenue, 2) AS total_revenue
FROM customer_orders co
JOIN customer_revenue cr ON co.customer_id = cr.customer_id;

-- TASK 6.4: Using a recursive CTE, generate a list of numbers from 1 to 10. Each row should have the number and its square (n * n).

WITH numbers_cte AS (
SELECT 1 AS n
UNION ALL
SELECT n + 1
FROM numbers_cte
WHERE n < 10
)
SELECT n, (n * n) AS square
FROM numbers_cte;

-- TASK 6.5: Using the recursive CTE org chart from section 9.6.2 as a starting point, modify it to also show the manager's first_name alongside each employee. Add a level column (0 for the top manager, 1 for their direct reports, 2 for the next level down).

-- Recursive org chart with manager's first_name and level
WITH org_chart AS (
    -- Anchor member: Top manager (staff without manager)
  SELECT 
    s.staff_id, 
    s.first_name, 
    s.last_name, 
    s.manager_id, 
    CAST(NULL AS VARCHAR(50)) AS manager_first_name, 
    0 AS level
    FROM sales.staffs s
    WHERE s.manager_id IS NULL

    UNION ALL

    -- Recursive member: Direct reports
    SELECT 
    emp.staff_id, 
    emp.first_name, 
    emp.last_name, 
    emp.manager_id, 
    m.first_name AS manager_first_name, 
    m.level + 1 AS level
    FROM sales.staffs emp
    INNER JOIN org_chart m ON emp.manager_id = m.staff_id
)
SELECT staff_id, first_name, last_name, manager_id, manager_first_name, level
FROM org_chart;

-- TASK 6.6: Think About It: A CTE is defined once but referenced twice in the same outer query. A colleague says "CTEs are faster than subqueries because the database computes the result once and reuses it." Is this claim accurate? What would you need to do if you genuinely needed the result computed only once and reused?

/*
Task 6.6 Answer:
1. Is the claim accurate?
No, the claim is inaccurate. In standard SQL Server, a CTE is logically equivalent to a derived table / inline view. The database engine re-evaluates or expands the CTE definition each time it is referenced in the query, so referencing it twice does not automatically cache or reuse the computed result.

2. What to do if result must be computed ONCE and reused?
To compute the result once and reuse it across multiple joins or queries, store the intermediate result in a Temporary Table (#TempTable) or a Table Variable (@TableVar) first, index it if necessary, and then query that temp structure.
*/