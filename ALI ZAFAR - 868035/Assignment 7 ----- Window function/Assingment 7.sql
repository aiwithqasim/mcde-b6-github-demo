--Window Functions
--TAsk 7.1
SELECT
    product_id,
    product_name,
    category_id,
    list_price,
    ROW_NUMBER() OVER (
        ORDER BY list_price DESC
    ) AS overall_row_num,
    ROW_NUMBER() OVER (
        PARTITION BY category_id
        ORDER BY list_price DESC
    ) AS category_row_num
FROM production.products
ORDER BY list_price DESC;



--task 7.2
WITH ranked AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        p.list_price,
        RANK()       OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS rnk,
        DENSE_RANK() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS dense_rnk
    FROM production.products p
)
SELECT *
FROM ranked
WHERE rnk <> dense_rnk          -- only rows after a tie
ORDER BY category_id, list_price DESC;



--Task 7.3
WITH monthly AS (
    SELECT
        o.store_id,
        DATETRUNC(month, o.order_date)               AS month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status IS NOT NULL                 -- optional filter (e.g., exclude cancelled)
    GROUP BY o.store_id, DATETRUNC(month, o.order_date)
)
SELECT
    store_id,
    month,
    revenue                                              AS current_month_revenue,
    LAG(revenue) OVER (
        PARTITION BY store_id
        ORDER BY month
    )                                                    AS previous_month_revenue,
    revenue - LAG(revenue) OVER (
        PARTITION BY store_id
        ORDER BY month
    )                                                    AS mom_change
FROM monthly
ORDER BY store_id, month;




--Task 7.4
SELECT
    product_name,
    list_price,
    NTILE(5) OVER (ORDER BY list_price DESC) AS price_band
FROM production.products
ORDER BY price_band, list_price DESC;


--Task 7.5
WITH order_rev AS (
    SELECT
        o.order_id,
        o.order_date,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS order_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON oi.order_id = o.order_id
    GROUP BY o.order_id, o.order_date
)
SELECT
    order_id,
    order_date,
    order_revenue,
    SUM(order_revenue) OVER (
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM order_rev
ORDER BY order_date, order_id;


