--ASSIGNMENT 6 (CTE'S)
--QUERY 1;

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


----QUERY 2;

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
    p.list_price,
    c.category_name
FROM cte_high_value_products AS p
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';


----QUERY 3;

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        ) AS total_revenue
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    co.customer_id,
    co.order_count,
    cr.total_revenue
FROM customer_orders AS co
INNER JOIN customer_revenue AS cr
    ON co.customer_id = cr.customer_id;

----QUERY 4;

WITH numbers AS (
    SELECT
        1 AS n

    UNION ALL

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


---QUERY 5;

WITH org_chart AS (
    -- Top manager
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

    -- Employees
    SELECT
        s.staff_id,
        s.first_name,
        s.last_name,
        s.manager_id,
        m.first_name AS manager_first_name,
        oc.level + 1 AS level
    FROM sales.staffs AS s
    INNER JOIN org_chart AS oc
        ON s.manager_id = oc.staff_id
    INNER JOIN sales.staffs AS m
        ON s.manager_id = m.staff_id
)
SELECT
    staff_id,
    first_name,
    last_name,
    manager_id,
    manager_first_name,
    level
FROM org_chart
ORDER BY level, staff_id;
