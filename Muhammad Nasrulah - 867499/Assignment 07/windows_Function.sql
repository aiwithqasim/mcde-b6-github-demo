-- Chapter 7: Window Functions


-- 7.1
-- Assign a sequential row number to each product by list_price descending.Then assign another row number that resets within each category.

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

-- 7.2
-- Return each product with RANK() and DENSE_RANK()
-- by list_price descending within its category.

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
    ) AS price_dense_rank

FROM production.products;


-- Show products where RANK() and DENSE_RANK() are different

WITH ProductRanks AS
(
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
        ) AS price_dense_rank

    FROM production.products
)

SELECT *
FROM ProductRanks
WHERE price_rank <> price_dense_rank;


-- =============================================
-- 7.3
-- Use LAG() to calculate month-over-month
-- revenue change for each store.
-- =============================================

WITH MonthlyRevenue AS
(
    SELECT
        o.store_id,
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,

        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        ) AS monthly_revenue

    FROM sales.orders AS o
    JOIN sales.order_items AS oi
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

    monthly_revenue -
    LAG(monthly_revenue) OVER (
        PARTITION BY store_id
        ORDER BY order_year, order_month
    ) AS revenue_difference

FROM MonthlyRevenue

ORDER BY
    store_id,
    order_year,
    order_month;



-- 7.4
-- Use NTILE(5) to divide all products into five price bands.


SELECT
    product_name,
    list_price,

    NTILE(5) OVER (
        ORDER BY list_price
    ) AS price_band

FROM production.products;


-- 7.5
-- Show each order with a running total of revenue ordered by order_date.

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

-- 7.6
-- Think About It

-- When ORDER BY is specified, the default window frame is:
--
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--
-- FIRST_VALUE() works correctly with the default frame
-- because the first row of the frame is also the first
-- row of the partition.
--
-- LAST_VALUE() does not return the actual last value
-- because the default frame ends at the current row.
--
-- Therefore, LAST_VALUE() requires:
--
-- RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING This makes the window frame include the entire partition,so LAST_VALUE() can return the actual last value.