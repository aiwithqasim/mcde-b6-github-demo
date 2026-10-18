
-- 6.1 — Rewrite this derived table query as a CTE:
WITH order_summary AS (
    SELECT store_id, COUNT(*) AS total_orders
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(total_orders) AS average_orders
FROM order_summary;


-- 6.2 — Return products with list_price > 2000,
-- then return only Mountain Bikes from that list.

WITH expensive_products AS (
    SELECT 
        product_id,
        product_name,
        category_id,
        list_price
    FROM production.products
    WHERE list_price > 2000
)
SELECT 
    ep.product_name,
    ep.list_price,
    cat.category_name
FROM expensive_products ep
JOIN production.categories cat 
    ON ep.category_id = cat.category_id
WHERE cat.category_name = 'Mountain Bikes';


-- 6.3 — Create two CTEs:
-- One counts orders per customer.
-- The other calculates total revenue per customer.

WITH customer_order_totals AS (
    SELECT 
        customer_id,
        COUNT(*) AS number_of_orders
    FROM sales.orders
    GROUP BY customer_id
),
customer_sales AS (
    SELECT 
        ord.customer_id,
        SUM(
            item.quantity * item.list_price * (1 - item.discount)
        ) AS revenue_amount
    FROM sales.orders ord
    JOIN sales.order_items item 
        ON ord.order_id = item.order_id
    GROUP BY ord.customer_id
)
SELECT 
    cot.customer_id,
    cot.number_of_orders,
    cs.revenue_amount
FROM customer_order_totals cot
JOIN customer_sales cs 
    ON cot.customer_id = cs.customer_id;


-- 6.4 — Generate numbers from 1 to 10
-- and calculate the square of each number.

WITH number_generator AS (
    SELECT 1 AS number_value

    UNION ALL

    SELECT number_value + 1
    FROM number_generator
    WHERE number_value < 10
)
SELECT 
    number_value,
    number_value * number_value AS squared_value
FROM number_generator
OPTION (MAXRECURSION 10);


-- 6.5 — Recursive CTE for the organization chart.
-- Also display the manager's first name and hierarchy level.

WITH staff_hierarchy AS (
    -- Anchor: employees who do not have a manager
    SELECT
        staff_id,
        first_name,
        manager_id,
        CAST(NULL AS VARCHAR(50)) AS supervisor_name,
        0 AS hierarchy_level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive part: find each employee's direct reports
    SELECT
        employee.staff_id,
        employee.first_name,
        employee.manager_id,
        hierarchy.first_name AS supervisor_name,
        hierarchy.hierarchy_level + 1 AS hierarchy_level
    FROM sales.staffs employee
    JOIN staff_hierarchy hierarchy 
        ON employee.manager_id = hierarchy.staff_id
)
SELECT 
    staff_id,
    first_name,
    supervisor_name,
    hierarchy_level
FROM staff_hierarchy
ORDER BY hierarchy_level, staff_id;


-- 6.6 — Think About It:
-- A CTE is not guaranteed to be calculated only once.
-- If the same CTE is referenced multiple times, SQL Server may
-- evaluate it multiple times.
--
-- If the result genuinely needs to be calculated once and reused,
-- use a temporary table such as #temp_table.

No. A CTE does not always execute only once. If you use the same CTE multiple times, SQL Server may run its query again.
If you want to calculate the result once and use it multiple times, you can store the result in a temporary table (#temp).
For smaller amounts of data, a table variable can also be used.