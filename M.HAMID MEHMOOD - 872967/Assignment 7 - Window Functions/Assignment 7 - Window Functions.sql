--7.1

SELECT
    product_name,
    category_id,
    list_price,
    ROW_NUMBER() OVER (ORDER BY list_price DESC) AS overall_row_num,
    ROW_NUMBER() OVER (PARTITION BY category_id 
    ORDER BY list_price DESC) AS category_row_num
FROM production.products;

--7.2

SELECT
    product_name,
    category_id,
    list_price,
    RANK() OVER (PARTITION BY category_id 
    ORDER BY list_price DESC) AS price_rank,
    DENSE_RANK() OVER (PARTITION BY category_id 
    ORDER BY list_price DESC) AS price_dense_rank
FROM production.products;

--7.3

WITH monthly_store_revenue AS (
    SELECT
        o.store_id,
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS current_month_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.store_id, YEAR(o.order_date), MONTH(o.order_date)
)
SELECT
    store_id,
    order_year,
    order_month,
    current_month_revenue,
    LAG(current_month_revenue, 1) OVER (PARTITION BY store_id 
    ORDER BY order_year, order_month) AS prev_month_revenue,
    current_month_revenue - LAG(current_month_revenue, 1) 
    OVER (PARTITION BY store_id 
    ORDER BY order_year, order_month) AS revenue_difference
FROM monthly_store_revenue;

--7.4

SELECT
    product_name,
    list_price,
    NTILE(5) OVER (ORDER BY list_price) AS price_band
FROM production.products;

--7.5

SELECT
    o.order_id,
    o.order_date,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS order_revenue,
    SUM(SUM(oi.quantity * oi.list_price * (1 - oi.discount))) OVER (
        ORDER BY o.order_date, o.order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date;

