-- Assignment: (CTEs)
-- Student: Talha
-- Saylani ID: [CDE-884628]
SQL Server – Chapter 6: Common Table Expressions 

---Solved Exercises

Exercise 6.1 Rewrite this derived table query as a CTE:

SELECT AVG(order_count) AS avg_orders
FROM (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
) AS store_counts;
Solution:
WITH store_counts AS (
    SELECT
        store_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count) AS avg_orders
FROM store_counts;
Exercise 6.2 Write a CTE called cte_high_value_products that returns products with list_price > 2000. Then query the CTE to return only Mountain Bikes from that list, joining to production.categories.
Solution:
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
FROM cte_high_value_products AS h
INNER JOIN production.categories AS c
    ON h.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';
Exercise 6.3 Create two CTEs: one that calculates each customer's total number of orders and another that calculates each customer's total revenue. Combine the two CTEs to display the customer ID, first name, last name, order count, and total revenue.
Solution:
WITH customer_order_counts AS (
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
    c.customer_id,
    c.first_name,
    c.last_name,
    oc.order_count,
    cr.total_revenue
FROM sales.customers AS c
INNER JOIN customer_order_counts AS oc
    ON c.customer_id = oc.customer_id
INNER JOIN customer_revenue AS cr
    ON c.customer_id = cr.customer_id
ORDER BY c.customer_id;
Exercise 6.4 Use a recursive CTE to generate the numbers 1 through 10 and display each number together with its square.
Solution:
WITH numbers AS (
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM numbers
    WHERE n < 10
)
SELECT
    n,
    n * n AS square
FROM numbers
OPTION (MAXRECURSION 10);
Exercise 6.5 Use a recursive CTE to display an organization chart from staff members. Show each staff member's first name, their manager's first name, and their level in the organization.
Solution:
WITH staff_hierarchy AS (
    SELECT
        s.staff_id,
        s.first_name,
        s.manager_id,
        CAST(NULL AS VARCHAR(100)) AS manager_first_name,
        0 AS organization_level
    FROM sales.staffs AS s
    WHERE s.manager_id IS NULL

    UNION ALL

    SELECT
        s.staff_id,
        s.first_name,
        s.manager_id,
        h.first_name AS manager_first_name,
        h.organization_level + 1
    FROM sales.staffs AS s
    INNER JOIN staff_hierarchy AS h
        ON s.manager_id = h.staff_id
)
SELECT
    first_name,
    manager_first_name,
    organization_level
FROM staff_hierarchy
ORDER BY organization_level, first_name
OPTION (MAXRECURSION 100);
Exercise 6.6 Demonstrate the use of a CTE and a temporary table for an intermediate result that can be reused.
Solution:
WITH high_value_products AS (
    SELECT
        product_id,
        product_name,
        brand_id,
        category_id,
        list_price
    FROM production.products
    WHERE list_price > 2000
)
SELECT COUNT(*) AS product_count
FROM high_value_products;

SELECT
    product_id,
    product_name,
    brand_id,
    category_id,
    list_price
INTO #high_value_products
FROM production.products
WHERE list_price > 2000;

SELECT COUNT(*) AS product_count
FROM #high_value_products;

SELECT AVG(list_price) AS average_price
FROM #high_value_products;

DROP TABLE #high_value_products;
