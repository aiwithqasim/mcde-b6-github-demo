--6.1

WITH store_counts AS (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count) AS avg_orders
FROM store_counts;

--6.2

WITH cte_high_value_products AS (
    SELECT product_id, product_name, category_id, list_price
    FROM production.products
    WHERE list_price > 2000
)
SELECT p.product_id, p.product_name, p.list_price, c.category_name
FROM cte_high_value_products p
JOIN production.categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';

--6.3

WITH customer_orders AS (
    SELECT customer_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
customer_revenue AS (
    SELECT customer_id, SUM(list_price * quantity) AS total_revenue
    FROM sales.order_items oi
    JOIN sales.orders o ON oi.order_id = o.order_id
    GROUP BY customer_id
)
SELECT 
    COALESCE(o.customer_id, r.customer_id) AS customer_id,
    COALESCE(o.order_count, 0) AS order_count,
    COALESCE(r.total_revenue, 0) AS total_revenue
FROM customer_orders o
FULL OUTER JOIN customer_revenue r ON o.customer_id = r.customer_id;

--6.4

WITH numbers AS (
    SELECT 1 AS n, 1 * 1 AS n_square
    
    UNION ALL
    
    SELECT n + 1, (n + 1) * (n + 1)
    FROM numbers
    WHERE n < 10
)
SELECT n, n_square
FROM numbers;

--6.5

WITH org_chart AS (
    -- Top manager (jiska manager_id NULL ho)
    SELECT
        staff_id AS employee_id,
        first_name,
        manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_first_name,
        0 AS level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    -- Staff members under each manager
    SELECT
        e.staff_id AS employee_id,
        e.first_name,
        e.manager_id,
        m.first_name AS manager_first_name,
        oc.level + 1 AS level
    FROM sales.staffs e
    JOIN org_chart oc
        ON e.manager_id = oc.employee_id
    JOIN sales.staffs m
        ON e.manager_id = m.staff_id
)
SELECT
    employee_id,
    first_name,
    manager_first_name,
    level
FROM org_chart
ORDER BY level, employee_id;
