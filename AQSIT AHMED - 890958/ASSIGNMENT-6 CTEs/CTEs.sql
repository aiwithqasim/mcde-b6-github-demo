--Write a query using a Common Table Expression (CTE).

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS total_orders
    FROM sales.orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_orders
FROM customer_orders;

--This query returns total sales by staff member for 2018 using a CTE to separate the aggregation from the filtering.
WITH staff_sales AS (
    SELECT
        o.staff_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
    FROM sales.orders o
    INNER JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    WHERE YEAR(o.order_date) = 2018
    GROUP BY o.staff_id
)
SELECT
    s.staff_id,
    s.first_name,
    s.last_name,
    ss.total_sales
FROM staff_sales ss
INNER JOIN sales.staffs s
    ON ss.staff_id = s.staff_id;

    --This example uses a CTE to calculate the average number of orders per staff in 2018. The problem — you need to AVG a COUNT, which cannot be done in a single aggregation step.

WITH staff_orders AS (
    SELECT
        staff_id,
        COUNT(*) AS order_count
    FROM sales.orders
    WHERE YEAR(order_date) = 2018
    GROUP BY staff_id
)
SELECT
    AVG(order_count) AS average_orders_per_staff
FROM staff_orders;

--You can define multiple CTEs in a single WITH clause, separated by commas. Each CTE can reference the ones defined before it.
WITH staff_orders AS (
    SELECT
        staff_id,
        COUNT(*) AS total_orders
    FROM sales.orders
    GROUP BY staff_id
),
staff_sales AS (
    SELECT
        staff_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
    FROM sales.orders o
    INNER JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY staff_id
)
SELECT
    so.staff_id,
    so.total_orders,
    ss.total_sales
FROM staff_orders so
INNER JOIN staff_sales ss
    ON so.staff_id = ss.staff_id;

    --All three can solve the same problem. The choice affects readability and maintainability, not the result.

-- Using CTE
WITH staff_orders AS (
    SELECT
        staff_id,
        COUNT(*) AS total_orders
    FROM sales.orders
    GROUP BY staff_id
)
SELECT *
FROM staff_orders;

--A recursive CTE references itself. It executes repeatedly, each iteration feeding into the next, until a termination condition is met. It is the standard SQL mechanism for querying hierarchical data.
WITH staff_hierarchy AS (
    -- Anchor member
    SELECT
        staff_id,
        first_name,
        last_name,
        manager_id
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive member
    SELECT
        s.staff_id,
        s.first_name,
        s.last_name,
        s.manager_id
    FROM sales.staffs s
    INNER JOIN staff_hierarchy sh
        ON s.manager_id = sh.staff_id
)
SELECT
    staff_id,
    first_name,
    last_name,
    manager_id
FROM staff_hierarchy;

--CTEs are especially useful when window functions produce results that need further filtering — since window functions cannot appear in WHERE or HAVING (they run in SELECT, after those clauses). The CTE wraps the window function result, and the outer query filters on it.
WITH ranked_products AS (
    SELECT
        product_id,
        product_name,
        brand_id,
        list_price,
        ROW_NUMBER() OVER (
            PARTITION BY brand_id
            ORDER BY list_price DESC
        ) AS price_rank
    FROM production.products
)
SELECT
    product_id,
    product_name,
    brand_id,
    list_price
FROM ranked_products
WHERE price_rank <= 3;

--The sales director wants to compare each category's revenue against the overall average revenue — and flag categories that are either above average or below — using a clean, readable query.

WITH category_revenue AS (
    SELECT
        c.category_id,
        c.category_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM production.categories c
    INNER JOIN production.products p
        ON c.category_id = p.category_id
    INNER JOIN sales.order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        c.category_id,
        c.category_name
),
average_revenue AS (
    SELECT AVG(revenue) AS avg_revenue
    FROM category_revenue
)
SELECT
    cr.category_name,
    cr.revenue,
    ar.avg_revenue,
    CASE
        WHEN cr.revenue > ar.avg_revenue THEN 'Above Average'
        WHEN cr.revenue < ar.avg_revenue THEN 'Below Average'
        ELSE 'Average'
    END AS revenue_status
FROM category_revenue cr
CROSS JOIN average_revenue ar;