/* 6.1 — Rewrite this derived table query as a CTE:

SELECT AVG(order_count) AS avg_orders
FROM (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
) AS store_counts; */

WITH store_count AS (
 SELECT
	store_id,
	count(*) AS order_count
FROM sales.orders
GROUP BY store_id
)
SELECT avg(order_count) AS avg_orders
FROM store_count;

/* 6.2 — Write a CTE called cte_high_value_products that returns products with list_price > 2000. 
Then query the CTE to return only Mountain Bikes from that list, joining to production.categories.*/

with cte_high_value_products AS (
    select 
        product_id,
        product_name,
        category_id,
        list_price
    from production.products
    where list_price > 2000
)
select * from cte_high_value_products as hvp
inner join production.categories as c on hvp.category_id = c.category_id
where c.category_name = 'Mountain Bikes'

-- 6.3

WITH customer_orders AS (
    SELECT 
        customer_id, 
        COUNT(order_id) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
customer_revenue AS (
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
ORDER BY cr.total_revenue DESC;

