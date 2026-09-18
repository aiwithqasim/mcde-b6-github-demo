use bikeStore

------- 6.1: Derived table rewritten as a CTE

WITH store_counts AS (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count * 1.0) AS avg_orders
FROM store_counts;

------- 6.2: cte_high_value_products

WITH cte_high_value_products AS (
    SELECT product_id, product_name, category_id, list_price
    FROM production.products
    WHERE list_price > 2000
)
SELECT h.product_id, h.product_name, c.category_name, h.list_price
FROM cte_high_value_products AS h
INNER JOIN production.categories AS c
    ON c.category_id = h.category_id
WHERE c.category_name = 'Mountain Bikes'
ORDER BY h.list_price DESC;


------ 6.3: Two CTEs in one WITH

WITH order_counts AS (
    SELECT customer_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
customer_revenue AS (
    SELECT o.customer_id,
           SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON oi.order_id = o.order_id
    GROUP BY o.customer_id
)
SELECT oc.customer_id, oc.order_count, cr.total_revenue
FROM order_counts AS oc
INNER JOIN customer_revenue AS cr
    ON cr.customer_id = oc.customer_id
ORDER BY cr.total_revenue DESC;



-------- 6.4: Recursive CTE for 1 to 10 and squares

WITH numbers AS (
    SELECT 1 AS n                       -- anchor
    UNION ALL
    SELECT n + 1                        -- recursive member
    FROM numbers
    WHERE n < 10                        -- termination condition
)
SELECT n, n * n AS square
FROM numbers;


------------ 6.5: Org chart with manager name and level
WITH org_chart AS (
    SELECT staff_id, first_name, last_name, manager_id, 0 AS level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    SELECT s.staff_id, s.first_name, s.last_name, s.manager_id, oc.level + 1
    FROM sales.staffs AS s
    INNER JOIN org_chart AS oc
        ON s.manager_id = oc.staff_id
)
SELECT oc.staff_id,
       oc.first_name,
       oc.last_name,
       m.first_name AS manager_first_name,
       oc.level
FROM org_chart AS oc
LEFT JOIN sales.staffs AS m
    ON m.staff_id = oc.manager_id
ORDER BY oc.level, oc.staff_id;
