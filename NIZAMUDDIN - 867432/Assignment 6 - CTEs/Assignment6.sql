----- Assignment 6 --------

-------- CTEs -------------

-- Ex 6.1

WITH avg_count AS(
	SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT 
	AVG(order_count) AS avg_orders
FROM avg_count

-- Ex 6.2

WITH high_value_products AS(
	SELECT p.product_name, p.list_price, p.category_id 
	FROM production.products p 
	WHERE p.list_price > 2000
)
SELECT hvp.product_name, hvp.list_price, c.category_name 
FROM production.categories c 
INNER JOIN high_value_products AS hvp
ON c.category_id  = hvp.category_id
WHERE c.category_name = 'Mountain Bikes';

-- Ex 6.3

WITH order_per_customer AS(
	SELECT
		o.customer_id,
		COUNT(order_id) as total_orders
	FROM sales.orders o 
	GROUP BY o.customer_id 
),
revenue_per_customer AS(
	SELECT 
		o.customer_id,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
	FROM sales.order_items oi 
	INNER JOIN sales.orders o 
	ON o.order_id = oi.order_id
	GROUP BY o.customer_id 
)
SELECT 
	ops.customer_id,
	ops.total_orders,
	rps.total_revenue
FROM order_per_customer ops
INNER JOIN revenue_per_customer rps
ON ops.customer_id = rps.customer_id 

-- Ex 6.4

WITH Numbers AS (
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM Numbers
    WHERE n < 10
)
SELECT
    n,
    n * n AS square
FROM Numbers
OPTION (MAXRECURSION 10);

-- Ex 6.5

WITH OrgChart AS (
    SELECT
        staff_id,
        first_name,
        manager_id,
        first_name AS manager_first_name,
        0 AS level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        s.staff_id,
        s.first_name,
        s.manager_id,
        oc.first_name AS manager_first_name,
        oc.level + 1
    FROM sales.staffs s
    INNER JOIN OrgChart oc
        ON s.manager_id = oc.staff_id
)
SELECT
    staff_id,
    first_name,
    manager_first_name,
    manager_id,
    level
FROM OrgChart
ORDER BY level, staff_id
OPTION (MAXRECURSION 100);

-- Ex 6.7
-- No, the claim is not accurate.
-- A CTE is mainly a query-writing/readability feature. SQL Server does not guarantee that a CTE is calculated once and reused when referenced multiple times.




