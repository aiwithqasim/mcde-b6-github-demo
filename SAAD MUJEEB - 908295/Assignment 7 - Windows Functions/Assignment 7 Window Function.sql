-- Assignment 7 - Window Functions
----------------------------------

-- EXCERCISE 7.1

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


-- EXCERCISE 7.2

WITH ranked_products AS (
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
)
SELECT *
FROM ranked_products
WHERE price_rank <> dense_price_rank;


-- EXCERCISE 7.3

WITH monthly_revenue AS (
    SELECT
        store_id,
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM sales.orders o
    JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        store_id,
        YEAR(order_date),
        MONTH(order_date)
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



-- EXCERCISE 7.4

SELECT
    product_name,
    list_price,
    NTILE(5) OVER (
        ORDER BY list_price
    ) AS price_band
FROM production.products
ORDER BY list_price;


-- EXCERCISE 7.5

SELECT
    o.order_id,
    o.order_date,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS order_revenue,

    SUM(SUM(oi.quantity * oi.list_price * (1 - oi.discount))) OVER (
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


-- EXCERCISE 7.6

-- FIRST_VALUE() can see the first row because the default frame starts at the beginning. 
-- LAST_VALUE() cannot see future rows because the default frame stops at the current row.