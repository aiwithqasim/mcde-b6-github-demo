-- =========================================
-- 7.1 — ROW_NUMBER()
-- =========================================

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


-- =========================================
-- 7.2 — RANK() vs DENSE_RANK()
-- =========================================

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
ORDER BY category_id, list_price DESC;


-- =========================================
-- 7.3 — LAG() Month-over-Month Revenue
-- =========================================

WITH monthly_revenue AS (
    SELECT
        o.store_id,
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        ) AS monthly_revenue
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.store_id,
        YEAR(o.order_date),
        MONTH(o.order_date)
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
    - LAG(monthly_revenue) OVER (
        PARTITION BY store_id
        ORDER BY order_year, order_month
    ) AS revenue_change

FROM monthly_revenue
ORDER BY
    store_id,
    order_year,
    order_month;


-- =========================================
-- 7.4 — NTILE(5)
-- =========================================

SELECT
    product_name,
    list_price,

    NTILE(5) OVER (
        ORDER BY list_price
    ) AS price_band

FROM production.products;


-- =========================================
-- 7.5 — Running Total of Revenue
-- =========================================

WITH order_revenue AS (
    SELECT
        o.order_id,
        o.order_date,
        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        ) AS order_revenue
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.order_id,
        o.order_date
)
SELECT
    order_id,
    order_date,
    order_revenue,

    SUM(order_revenue) OVER (
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue

FROM order_revenue
ORDER BY order_date, order_id;


-- =========================================
-- 7.6 — Think About It
-- =========================================

-- FIRST_VALUE() with the default frame:
--
-- ORDER BY ke saath default window frame generally:
--
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--
-- FIRST_VALUE() ko partition ki first value chahiye.
-- Default frame already first row se current row tak hota hai,
-- isliye first value available hoti hai.
--
--
-- LAST_VALUE() ke case mein problem hoti hai.
--
-- Default frame:
--
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--
-- Iska matlab LAST_VALUE() current row tak hi dekh sakta hai.
-- Isliye woh aksar current row ki value return karta hai,
-- partition ki actual last value nahi.
--
-- Actual last value ke liye frame ko poore partition tak extend karna hota hai:
--
-- RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
--
-- Example:
--
-- LAST_VALUE(list_price) OVER (
--     PARTITION BY category_id
--     ORDER BY list_price
--     RANGE BETWEEN UNBOUNDED PRECEDING
--     AND UNBOUNDED FOLLOWING
-- )