-- 7.1
SELECT
    product_name,
    category_id,
    list_price,
    ROW_NUMBER() OVER (
        ORDER BY list_price DESC
    ) AS overall_row_number,
    ROW_NUMBER() OVER (
        PARTITION BY category_id
        ORDER BY list_price DESC
    ) AS category_row_number
FROM production.products;


-- 7.2
SELECT
    product_name,
    category_id,
    list_price,
    RANK() OVER (
        PARTITION BY category_id
        ORDER BY list_price DESC
    ) AS price_rank,
    DENSE_RANK() OVER (
        PARTITION BY category_id
        ORDER BY list_price DESC
    ) AS price_dense_rank
FROM production.products
WHERE list_price IN (
    SELECT list_price
    FROM production.products
    GROUP BY list_price
    HAVING COUNT(*) > 1
);


-- 7.3
WITH monthly_revenue AS (
    SELECT
        store_id,
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM sales.orders o
    JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        store_id,
        YEAR(o.order_date),
        MONTH(o.order_date)
)
SELECT
    store_id,
    order_year,
    order_month,
    revenue AS current_month_revenue,
    LAG(revenue) OVER (
        PARTITION BY store_id
        ORDER BY order_year, order_month
    ) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (
        PARTITION BY store_id
        ORDER BY order_year, order_month
    ) AS revenue_difference
FROM monthly_revenue
ORDER BY
    store_id,
    order_year,
    order_month;


-- 7.4
SELECT
    product_name,
    list_price,
    NTILE(5) OVER (
        ORDER BY list_price
    ) AS price_band
FROM production.products;


-- 7.5
SELECT
    o.order_id,
    o.order_date,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS order_revenue,
    SUM(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount))
    ) OVER (
        ORDER BY o.order_date, o.order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue
FROM sales.orders o
JOIN sales.order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.order_date
ORDER BY
    o.order_date,
    o.order_id;


-- 7.6
-- FIRST_VALUE() works with the default frame because the first row
-- is already included in the frame.
--
-- LAST_VALUE() does not return the actual last row by default because
-- the default frame ends at the CURRENT ROW.
--
-- When ORDER BY is specified, the default frame is:
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--
-- Therefore, LAST_VALUE() needs:
-- RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
--
-- to extend the frame all the way to the final row of the partition.