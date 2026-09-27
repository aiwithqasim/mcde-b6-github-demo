-- 6.1— Rewrite this derived table query as a CTE:

--SELECT AVG(order_count) AS avg_orders
--FROM (
    --SELECT store_id, COUNT(*) AS order_count
    --FROM sales.orders
    --GROUP BY store_id
--) AS store_counts;

WITH store_counts AS (
    SELECT 
        store_id, 
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count) AS avg_orders
FROM store_counts;


-- 6.2 Write a CTE called cte_high_value_products that returns products with list_price 
--> 2000. Then query the CTE to return only Mountain Bikes from that list, 
--joining to production.categories.

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
    p.product_id,
    p.product_name,
    c.category_name,
    p.list_price
FROM cte_high_value_products p
JOIN production.categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';


-- 6.3  — Write two CTEs in one WITH clause: one that counts orders per customer, and one that sums revenue per customer. Join them in the outer 
--query to return customer_id, order_count, and total_revenue side by side.
WITH customer_order_counts AS (
    SELECT 
        customer_id,
        COUNT(order_id) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
customer_revenues AS (
    SELECT 
        o.customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT 
    coc.customer_id,
    coc.order_count,
    cr.total_revenue
FROM customer_order_counts coc
JOIN customer_revenues cr ON coc.customer_id = cr.customer_id;


-- 6.4 --Using a recursive CTE, generate a list of numbers from 1 to 10. Each row should have
--the number and its square (n * n).


WITH NumberSequence AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM NumberSequence
    WHERE n < 10
)
SELECT 
    n, 
    n * n AS square
FROM NumberSequence;


-- 6.5 Using the recursive CTE org chart from section 9.6.2 as a starting point, modify it to also show the manager's first_name alongside each employee. Add a level column (0 for the top manager, 1 for their direct reports, 
--2 for the next level down).
WITH OrgChart AS (
    -- Anchor member: top-level manager (manager_id IS NULL)
    SELECT 
        staff_id,
        first_name,
        last_name,
        manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_first_name,
        0 AS level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive member: direct reports
    SELECT 
        s.staff_id,
        s.first_name,
        s.last_name,
        s.manager_id,
        CAST(m.first_name AS VARCHAR(50)) AS manager_first_name,
        m.level + 1 AS level
    FROM sales.staffs s
    JOIN OrgChart m ON s.manager_id = m.staff_id
)
SELECT 
    staff_id,
    first_name,
    last_name,
    manager_id,
    manager_first_name,
    level
FROM OrgChart
ORDER BY level, staff_id;