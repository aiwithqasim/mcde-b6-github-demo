--ASSIGNMENT 7 (WINDOW FUNCTIONS)

-----QUERY 1;

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


-----QUERY 2;

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
SELECT
    product_id,
    product_name,
    category_id,
    list_price,
    price_rank,
    dense_price_rank
FROM ranked_products
WHERE price_rank <> dense_price_rank
ORDER BY category_id, list_price DESC;


----QUERY 3;

WITH monthly_revenue AS (
    SELECT
        o.store_id,
        DATEFROMPARTS(
            YEAR(o.order_date),
            MONTH(o.order_date),
            1
        ) AS revenue_month,
        SUM(
            oi.quantity * oi.list_price * (1 - oi.discount)
        ) AS current_month_revenue
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.store_id,
        DATEFROMPARTS(
            YEAR(o.order_date),
            MONTH(o.order_date),
            1
        )
),
revenue_with_previous AS (
    SELECT
        store_id,
        revenue_month,
        current_month_revenue,
        LAG(current_month_revenue) OVER (
            PARTITION BY store_id
            ORDER BY revenue_month
        ) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    store_id,
    revenue_month,
    current_month_revenue,
    previous_month_revenue,
    current_month_revenue - previous_month_revenue
        AS revenue_change
FROM revenue_with_previous
ORDER BY store_id, revenue_month;


----QUERY 4;

SELECT
    product_name,
    list_price,
    NTILE(5) OVER (
        ORDER BY list_price
    ) AS price_band
FROM production.products
ORDER BY list_price, product_name;


----QUERY 5;

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
