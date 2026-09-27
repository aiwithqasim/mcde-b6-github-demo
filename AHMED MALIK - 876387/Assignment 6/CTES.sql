

----  Common Table Expressions (CTEs) ----

-- TASK is 6.1 is Completed!! --


WITH cte_store_counts AS (
    SELECT 
        store_id, 
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT 
    AVG(order_count) AS avg_orders 
FROM cte_store_counts;


---------------------------------------------


-- TASK is 6.2 is Completed!! --


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
INNER JOIN production.categories c 
    ON p.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';


----------------------------------------------------------


-- TASK is 6.3 is Completed!! --


WITH cte_customer_orders AS (
    SELECT 
        customer_id, 
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
cte_customer_revenue AS (
    SELECT 
        o.customer_id, 
        SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_revenue
    FROM sales.orders o
    INNER JOIN sales.order_items i 
        ON o.order_id = i.order_id
    GROUP BY o.customer_id
)
SELECT 
    co.customer_id,
    co.order_count,
    cr.total_revenue
FROM cte_customer_orders co
INNER JOIN cte_customer_revenue cr 
    ON co.customer_id = cr.customer_id;


----------------------------------------------------


-- TASK is 6.4 is Completed!! --


WITH cte_numbers (n, square) AS (
    -- Anchor Member
    SELECT 1, 1 * 1
    
    UNION ALL
    
    -- Recursive Member
    SELECT n + 1, (n + 1) * (n + 1)
    FROM cte_numbers
    WHERE n < 10 -- Termination Condition
)
SELECT 
    n, 
    square 
FROM cte_numbers;


------------------------------------------------


-- TASK is 6.5 is Completed!! --


WITH cte_org AS (

    SELECT 
        staff_id, 
        first_name AS employee_name, 
        manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_name,
        0 AS level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

 
    SELECT 
        e.staff_id, 
        e.first_name AS employee_name, 
        e.manager_id,
        m.employee_name AS manager_name,
        m.level + 1 AS level
    FROM sales.staffs e
    INNER JOIN cte_org m 
        ON e.manager_id = m.staff_id
)
SELECT 
    staff_id,
    employee_name,
    manager_name,
    level
FROM cte_org;