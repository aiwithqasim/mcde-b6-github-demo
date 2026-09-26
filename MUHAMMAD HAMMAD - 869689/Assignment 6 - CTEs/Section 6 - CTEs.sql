Use bikestores;
Go

--Assignment 6 - CTEs

--6.1 — Rewrite this derived table query as a CTE:

WITH store_counts AS
(
    SELECT 
        store_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count) AS avg_orders
FROM store_counts;

--6.2 — Write a CTE called cte_high_value_products that returns products with list_price > 2000. 
--Then query the CTE to return only Mountain Bikes from that list, joining to production.categories.


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
WHERE c.category_name = 'Mountain Bikes';


--6.3 — Write two CTEs in one WITH clause: one that counts orders per customer, 
--and one thatsums revenue per ustomer. Join them in the outer query to 
--return customer_id, order_count, and total_revenue side by side.

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
        SUM(oi.quantity * oi.list_price) AS total_revenue
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

--6.4 — Using a recursive CTE, generate a list of numbers from 1 to 10.
--Each row should have the number and its square (n * n).

    WITH numbers AS
(
    SELECT
        1 AS n,
        1 * 1 AS square

    UNION ALL

    SELECT
        n + 1,
        (n + 1) * (n + 1)
    FROM numbers
    WHERE n < 10
)
SELECT
    n,
    square
FROM numbers
OPTION (MAXRECURSION 10);

--6.5 — Using the recursive CTE org chart from section 9.6.2 as a starting point, modify 
--it to also show the manager's first_name alongside each employee. Add a level
--column (0 for the top manager, 1 for their direct reports, 2 for the next level down).

WITH org_chart AS
(
    -- Top Manager
    SELECT
        staff_id,
        first_name,
        manager_id,
        first_name AS manager_name,
        0 AS level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    -- Employees under each manager
    SELECT
        e.staff_id,
        e.first_name,
        e.manager_id,
        m.first_name AS manager_name,
        oc.level + 1 AS level
    FROM sales.staffs AS e
    INNER JOIN org_chart AS oc
        ON e.manager_id = oc.staff_id
    INNER JOIN sales.staffs AS m
        ON e.manager_id = m.staff_id
)
SELECT
    staff_id,
    first_name AS employee_name,
    manager_name,
    level
FROM org_chart
ORDER BY level, staff_id
OPTION (MAXRECURSION 100);


--6.6 — Think About It: A CTE is defined once but referenced twice in the same outer query. A colleague says
--"CTEs are faster than subqueries because the database computes the result once and reuses it." Is this
--claim accurate? What would you need to do if you genuinely needed the result computed only once and reused?

/*ANSWER : A CTE is not automatically faster than a subquery, and SQL Server does not guarantee that a CTE is computed
only once. If the result must genuinely be computed once and reused, a temporary table can be used to materialize the result.*/
