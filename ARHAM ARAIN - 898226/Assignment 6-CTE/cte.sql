
---------------------------TASK #01------------------------------------------------
WITH store_counts AS (
    SELECT 
        store_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT 
    AVG(order_count) AS avg_orders
FROM store_counts;


---------------------------TASK #02------------------------------------------------
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
    h.product_id,
    h.product_name,
    h.list_price,
    c.category_name
FROM cte_high_value_products h
INNER JOIN production.categories c
    ON h.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';

---------------------------TASK #03--------------------------------------------------------------------------------------
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        ) AS total_revenue
    FROM sales.orders o
    INNER JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    co.customer_id,
    co.order_count,
    cr.total_revenue
FROM customer_orders co
INNER JOIN customer_revenue cr
    ON co.customer_id = cr.customer_id;


-------TASK #04---------------------------------------

WITH numbers AS (
    -- Anchor
    SELECT 
        1 AS n

    UNION ALL

    -- Recursive part
    SELECT 
        n + 1
    FROM numbers
    WHERE n < 10
)
SELECT
    n,
    n * n AS square
FROM numbers
OPTION (MAXRECURSION 10);




---------------------------TASK #05-------------------------------------


WITH org_chart AS (
    -- Anchor: top-level manager
    SELECT
        s.staff_id,
        s.first_name,
        s.last_name,
        s.manager_id,
        CAST(NULL AS VARCHAR(100)) AS manager_first_name,
        0 AS level
    FROM sales.staffs s
    WHERE s.manager_id IS NULL

    UNION ALL

    -- Recursive part
    SELECT
        s.staff_id,
        s.first_name,
        s.last_name,
        s.manager_id,
        oc.first_name AS manager_first_name,
        oc.level + 1 AS level
    FROM sales.staffs s
    INNER JOIN org_chart oc
        ON s.manager_id = oc.staff_id
)
SELECT
    staff_id,
    first_name,
    last_name,
    manager_first_name,
    level
FROM org_chart
ORDER BY level, staff_id
OPTION (MAXRECURSION 100);


---------------------------TASK #06--------------------------------------------------


----------------------------------ANSWERS---------------------------------------------------



------CTEs are faster than subqueries because the database computes the result once and reuses it

----------------Ye claim generally accurate nahi hai.-------------------------------------------

--CTE ka purpose mainly query ko:--

--readable
--organized
--eusable within the statement;



WITH customer_data AS (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
)
SELECT ...
FROM customer_data c1
JOIN customer_data c2
    ON c1.customer_id = c2.customer_id;
