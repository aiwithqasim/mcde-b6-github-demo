

-- Task 7.1 is completed --

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

--------------------------------------------

-- Task 7.2 is completed --

WITH ranked_products AS
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
        ) AS dense_price_rank

    FROM production.products
)
SELECT
    product_id,
    product_name,
    category_id,
    list_price,
    price_rank,
    dense_price_rank
FROM ranked_products
WHERE price_rank <> dense_price_rank;

-----------------------------------------------------

-- Task 7.3 is completed --

WITH monthly_revenue AS
(
    SELECT
        o.store_id,
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,

        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        ) AS current_month_revenue

    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id

    GROUP BY
        o.store_id,
        YEAR(o.order_date),
        MONTH(o.order_date)
),
revenue_with_previous AS
(
    SELECT
        store_id,
        order_year,
        order_month,
        current_month_revenue,

        LAG(current_month_revenue) OVER (
            PARTITION BY store_id
            ORDER BY order_year, order_month
        ) AS previous_month_revenue

    FROM monthly_revenue
)
SELECT
    store_id,
    order_year,
    order_month,
    current_month_revenue,
    previous_month_revenue,

    current_month_revenue - previous_month_revenue
        AS revenue_difference

FROM revenue_with_previous
ORDER BY
    store_id,
    order_year,
    order_month;

------------------------------------------------------------------

-- Task 7.4 is completed --

SELECT
    product_name,
    list_price,

    NTILE(5) OVER (
        ORDER BY list_price
    ) AS price_band

FROM production.products;

----------------------------------------------------------------

-- Task 7.5 is completed --

WITH order_revenue AS
(
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
ORDER BY
    order_date,
    order_id;

------------------------------------------------------------------


