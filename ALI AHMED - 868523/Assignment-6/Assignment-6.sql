

--6.1 — Rewrite this derived table query as a CTE:

--SELECT AVG(order_count) AS avg_orders
--FROM (
 --   SELECT store_id, COUNT(*) AS order_count
 --   FROM sales.orders
  --  GROUP BY store_id
--) AS store_counts;

WITH Cte_AvgOrder as(
 SELECT store_id, COUNT(*) AS order_count
   FROM sales.orders
    GROUP BY store_id
)
SELECT avg(order_count) as AvgOrder from Cte_AvgOrder 


--6.2 — Write a CTE called cte_high_value_products that returns products with list_price > 2000. 
--Then query the CTE to return only Mountain Bikes from that list, joining to production.categories.

WITH cte_high_value_products as (
    SELECT product_id,product_name,category_id,list_price
    FROM production.products
    WHERE list_price >5000

)
    SELECT cte.product_id,cte.product_name,cte.list_price,c.category_name
    FROM cte_high_value_products cte
    INNER JOIN production.categories c
    ON cte.category_id=c.category_id
    WHERE c.category_name = 'Mountain Bikes';


    --6.3 — Write two CTEs in one WITH clause: one that counts orders per customer, and one that sums revenue per customer.
    --Join them in the outer query to return customer_id, order_count, and total_revenue side by side.

    WITH cte_count as (
    select o.customer_id,c.first_name,Count(*) as order_count
    from sales.orders o
    INNER JOIN sales.customers c
    on o.customer_id=c.customer_id
    group by o.customer_id,c.first_name
    ),
    cte_sum as (
    SELECT o.customer_id,SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.orders o
    INNER JOIN sales.order_items oi
    ON o.order_id=oi.order_id
    GROUP BY o.customer_id
    )
        SELECT cc.customer_id,cc.first_name,cc.order_count,cs.total_revenue
        FROM cte_count cc
        INNER JOIN
        cte_sum cs
        ON cc.customer_id=cs.customer_id
        ORDER BY cc.customer_id

--6.4 — Using a recursive CTE, generate a list of numbers from 1 to 10. 
--Each row should have the number and its square (n * n).

WITH cte_number AS (
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM cte_number
    WHERE n < 10
)
SELECT 
    n,
    (n * n) AS square
FROM cte_number;

--6.5 — Using the recursive CTE org chart from section 9.6.2 as a starting point, modify it to also show the manager's first_name alongside each employee. 
--Add a level column (0 for the top manager, 1 for their direct reports, 2 for the next level down). took help from AI in this

WITH cte_org AS (
    
    SELECT
        staff_id,
        first_name,
        manager_id,
        0 AS level                   
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.staff_id,
        e.first_name,
        e.manager_id,
        o.level + 1                  
    FROM sales.staffs e
    INNER JOIN cte_org o 
        ON e.manager_id = o.staff_id
)
SELECT 
    c.staff_id,
    c.first_name,
    c.manager_id,
    m.first_name AS manager_first_name, 
    c.level
FROM cte_org c
LEFT JOIN sales.staffs m 
    ON c.manager_id = m.staff_id;

   -- 6.6 — Think About It: A CTE is defined once but referenced twice in the same outer query.
   --A colleague says "CTEs are faster than subqueries because the database computes the result once and reuses it." 
   --Is this claim accurate? What would you need to do if you genuinely needed the result computed only once and reused?

   --ANSWER: CTEs does not computes the result once and reuse it. Its not like Stored Procedure.
   --CTE reference twice will executes the logic twice, we use CTEs fro readability and small datasets