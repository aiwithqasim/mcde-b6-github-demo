
-- Windows Functions Exercises
-- 7.1 - 7.6
-- Muhammad Shehreyar
-- =========================================================


-- =========================================================
-- 7.1
-- Assign a sequential row number to each product ordered
-- by list_price descending.
-- Then assign a second row number partitioned by category_id.
-- =========================================================

SELECT
    product_id,
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


-- =========================================================
-- 7.2
-- Return each product with its RANK() and DENSE_RANK()
-- by list_price descending within its category.
-- =========================================================

SELECT
    product_id,
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
    ) AS dense_price_rank

FROM production.products

ORDER BY
    category_id,
    list_price DESC;


-- =========================================================
-- 7.3
-- Use LAG() to calculate the month-over-month revenue change
-- for each store.
-- Show current month revenue, previous month revenue,
-- and the difference.
-- =========================================================

WITH MonthlyRevenue AS
(
    SELECT
        store_id,
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,

        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        ) AS monthly_revenue

    FROM sales.orders AS o

    JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 4

    GROUP BY
        store_id,
        YEAR(order_date),
        MONTH(order_date)
)

SELECT
    store_id,
    order_year,
    order_month,
    monthly_revenue,

    LAG(monthly_revenue) OVER (
        PARTITION BY store_id
        ORDER BY order_year, order_month
    ) AS previous_month_revenue,

    monthly_revenue
    -
    LAG(monthly_revenue) OVER (
        PARTITION BY store_id
        ORDER BY order_year, order_month
    ) AS revenue_difference

FROM MonthlyRevenue

ORDER BY
    store_id,
    order_year,
    order_month;


-- =========================================================
-- 7.4
-- Use NTILE(5) to divide all products into five price bands.
-- =========================================================

SELECT
    product_name,
    list_price,

    NTILE(5) OVER (
        ORDER BY list_price
    ) AS price_band

FROM production.products

ORDER BY
    list_price;


-- =========================================================
-- 7.5
-- Show each order with a running total of revenue
-- ordered by order_date.
-- =========================================================

SELECT
    o.order_id,
    o.order_date,

    SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) AS order_revenue,

    SUM(
        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        )
    ) OVER (
        ORDER BY o.order_date, o.order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue

FROM sales.orders AS o

JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id

GROUP BY
    o.order_id,
    o.order_date

ORDER BY
    o.order_date,
    o.order_id;


-- =========================================================
-- 7.6
-- FIRST_VALUE() and LAST_VALUE()
--
-- When ORDER BY is specified, the default window frame is:
--
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--
-- FIRST_VALUE() works because the first row is included
-- in the default frame.
--
-- LAST_VALUE() normally returns the current row's value
-- because the default frame ends at the current row.
--
-- To get the actual last value in the partition, use:
--
-- RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
-- =========================================================

SELECT
    product_id,
    product_name,
    category_id,
    list_price,

    FIRST_VALUE(list_price) OVER (
        PARTITION BY category_id
        ORDER BY list_price
    ) AS first_price,

    LAST_VALUE(list_price) OVER (
        PARTITION BY category_id
        ORDER BY list_price
        RANGE BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS actual_last_price

FROM production.products

ORDER BY
    category_id,
    list_price;