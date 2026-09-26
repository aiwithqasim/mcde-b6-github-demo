-- =============================================
-- Chapter 6: Common Table Expressions (CTEs)
-- Assignment 6.1 - 6.6
-- =============================================


-- =============================================
-- 6.1
-- First count the orders for each store,
-- then calculate the average number of orders.
-- =============================================

WITH store_counts AS
(
    SELECT
        store_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)

SELECT
    AVG(order_count) AS avg_orders
FROM store_counts;


-- =============================================
-- 6.2
-- Get products with a price greater than 2000.
-- Then return only Mountain Bikes from those products.
-- =============================================

WITH cte_high_value_products AS
(
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
    p.list_price,
    c.category_name
FROM cte_high_value_products AS p
JOIN production.categories AS c
    ON p.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';


-- =============================================
-- 6.3
-- Count orders and total revenue for each customer.
-- Then join both results together.
-- =============================================

WITH customer_orders AS
(
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),

customer_revenue AS
(
    SELECT
        o.customer_id,
        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        ) AS total_revenue
    FROM sales.orders AS o
    JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)

SELECT
    co.customer_id,
    co.order_count,
    cr.total_revenue
FROM customer_orders AS co
JOIN customer_revenue AS cr
    ON co.customer_id = cr.customer_id
ORDER BY co.customer_id;


-- =============================================
-- 6.4
-- Start with 1 and keep adding 1 until we reach 10.
-- The recursive part also calculates the square.
-- =============================================

WITH Numbers AS
(
    SELECT
        1 AS n,
        1 * 1 AS square

    UNION ALL

    SELECT
        n + 1,
        (n + 1) * (n + 1)
    FROM Numbers
    WHERE n < 10
)

SELECT
    n,
    square
FROM Numbers
OPTION (MAXRECURSION 10);


-- 6.5
-- Start with the top manager and then move down
-- through the employees using the manager_id.
-- Level 0 is the top manager.

WITH EmployeeHierarchy AS
(
    -- Start with employees who have no manager
    SELECT
        s.staff_id,
        s.first_name,
        s.last_name,
        s.manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_first_name,
        0 AS level

    FROM sales.staffs AS s
    WHERE s.manager_id IS NULL

    UNION ALL

    -- Find employees who report to the previous level
    SELECT
        s.staff_id,
        s.first_name,
        s.last_name,
        s.manager_id,
        e.first_name AS manager_first_name,
        e.level + 1 AS level

    FROM sales.staffs AS s
    JOIN EmployeeHierarchy AS e
        ON s.manager_id = e.staff_id
)

SELECT
    staff_id,
    first_name,
    last_name,
    manager_id,
    manager_first_name,
    level
FROM EmployeeHierarchy
ORDER BY
    level,
    staff_id
OPTION (MAXRECURSION 100);


-- =============================================
-- 6.6
-- A CTE is not automatically calculated once
-- and stored for later use.
--
-- The database optimizer decides how the CTE
-- should be executed. A CTE is mainly a way to
-- make the query easier to read and organize.
--
-- If we really need the result to be calculated
-- once and reused, we can store the result in a
-- temporary table such as #TempTable and then
-- use that table multiple times.
-- =============================================