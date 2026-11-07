Use BikeStores
Go


--6.1 — Rewrite this derived table query as a CTE:

WITH Store_Counts AS (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count) AS Avg_Orders
FROM Store_Counts;


--6.2 — Write a CTE called cte_high_value_products that
--returns products with list_price > 2000. Then query 
--the CTE to return only Mountain Bikes from that list, 
--joining to production.categories.

with cte_high_value_products as (
    select p.* from production.products as p
    inner join production.categories as c
    on p.category_id = c.category_id
    where p.list_price > 2000 
    )
select * from cte_high_value_products as h
inner join production.categories as c
on h.category_id = c.category_id
where c.category_name = 'Mountain Bikes'; 



--6.3 — Write two CTEs in one WITH clause: 
--one that counts orders per customer, 
--and one that sums revenue per customer. 
--Join them in the outer query to return customer_id, 
--order_count, and total_revenue side by side.

WITH Order_Counts AS (
    SELECT customer_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
Customer_Revenue AS (
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



--6.4 — Using a recursive CTE, generate a list of
--numbers from 1 to 10. Each row should have the number 
--and its square (n * n).

with Number_list as(
    SELECT 1 as Numbers
    UNION ALL 
    SELECT Numbers + 1
    from Number_list
    where Numbers < 10
)
SELECT 
    Numbers, 
    Numbers * Numbers AS Squares
FROM Number_list;



-- 6.5 — Using the recursive CTE org chart from 
-- section 9.6.2 as a starting point, modify it to also 
-- show the manager's first_name alongside each employee. 
-- Add a level column (0 for the top manager, 1 for their 
-- direct reports, 2 for the next level down).

WITH Org_Chart AS (
    SELECT 
    staff_id, 
    first_name, 
    last_name, 
    manager_id, 0 AS Level
    FROM sales.staffs
    WHERE manager_id IS NULL

UNION ALL

    SELECT 
    s.staff_id, 
    s.first_name, 
    s.last_name, 
    s.manager_id, oc.Level + 1
    FROM sales.staffs AS s
    INNER JOIN Org_Chart AS oc
        ON s.manager_id = oc.staff_id
)
SELECT 
       oc.staff_id,
       oc.first_name,
       oc.last_name,
       m.first_name AS Manager_First_Name,
       oc.Level
FROM Org_Chart AS oc
LEFT JOIN sales.staffs AS m
    ON m.staff_id = oc.manager_id
ORDER BY oc.Level, oc.staff_id;
