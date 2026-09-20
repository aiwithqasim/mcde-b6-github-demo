-- TASK=1
-- Rewrite this derived table query as a CTE:
/*SELECT AVG(order_count) AS avg_orders
FROM (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
) AS store_counts;*/
WITH store_counts AS
(
    SELECT
        store_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT
    AVG(CAST(order_count AS DECIMAL(10,2))) AS avg_orders
FROM store_counts;


-- TASK=3
-- Write a CTE called cte_high_value_products that returns products with list_price > 2000. Then query the CTE to return only Mountain Bikes from that list, joining to production.categories.
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
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes'
ORDER BY p.list_price DESC;

-- TASK=3
-- Write two CTEs in one WITH clause: one that counts orders per customer, and one that sums revenue per customer. Join them in the outer query to return customer_id, order_count, and total_revenue side by side.
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
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
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
    ON co.customer_id = cr.customer_id
ORDER BY co.customer_id;

-- TASK=4
-- Using a recursive CTE, generate a list of numbers from 1 to 10. Each row should have the number and its square (n * n).
WITH NumberSequence AS
(
    -- Anchor member
    SELECT
        1 AS n

    UNION ALL

    -- Recursive member
    SELECT
        n + 1
    FROM NumberSequence
    WHERE n < 10
)
SELECT
    n,
    n * n AS square
FROM NumberSequence
OPTION (MAXRECURSION 10);


-- TASK=5
--Using the recursive CTE org chart from section 9.6.2 as a starting point, modify it to also show the manager's first_name alongside each employee. Add a level column (0 for the top manager, 1 for their direct reports, 2 for the next level down).
WITH OrgChart AS
(
    -- Top-level manager
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

    -- Employees under each manager
    SELECT
        s.staff_id,
        s.first_name,
        s.last_name,
        s.manager_id,
        m.first_name AS manager_first_name,
        oc.level + 1 AS level
    FROM sales.staffs AS s
    INNER JOIN OrgChart AS oc
        ON s.manager_id = oc.staff_id
    INNER JOIN sales.staffs AS m
        ON s.manager_id = m.staff_id
)
SELECT
    staff_id,
    first_name,
    last_name,
    manager_first_name,
    level
FROM OrgChart
ORDER BY level, staff_id
OPTION (MAXRECURSION 100);


-- TASK=6
-- Think About It: A CTE is defined once but referenced twice in the same outer query. A colleague says "CTEs are faster than subqueries because the database computes the result once and reuses it." Is this claim accurate? What would you need to do if you genuinely needed the result computed only once and reused?
WITH HighValueProducts AS
(
    SELECT
        product_id,
        product_name,
        list_price
    FROM production.products
    WHERE list_price > 2000
)
SELECT
    p1.product_name,
    p2.product_name
FROM HighValueProducts AS p1
INNER JOIN HighValueProducts AS p2
    ON p1.product_id <> p2.product_id;