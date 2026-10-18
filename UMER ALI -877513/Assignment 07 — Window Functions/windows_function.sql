-- Windows Funcions
--task 1

WITH ranked AS (
    SELECT
        product_name,
        category_id,
        list_price,
        row_number() OVER (
            PARTITION BY category_id
            ORDER BY list_price DESC
        ) AS partitioned_rank
    FROM production.products
)
SELECT *
FROM ranked;

--task 2

SELECT
    product_id,
    product_name,
    category_id,
    list_price,
    RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS price_rank,
    DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS price_dense_rank
FROM production.products
ORDER BY category_id, list_price DESC;


-- task 3

WITH monthly_revenue AS (
    SELECT
        store_id,
        DATETRUNC(month, order_date) AS revenue_month,
        SUM(quantity * list_price * (1 - discount)) AS revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON oi.order_id = o.order_id
    GROUP BY store_id, DATETRUNC(month, order_date)
)
SELECT
    store_id,
    revenue_month,
    revenue AS current_month_revenue,
    LAG(revenue) OVER (PARTITION BY store_id ORDER BY revenue_month) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (PARTITION BY store_id ORDER BY revenue_month) AS revenue_change
FROM monthly_revenue
ORDER BY store_id, revenue_month;


-- task 4
SELECT
    product_name,
    list_price,
    NTILE(5) OVER (ORDER BY list_price) AS price_band
FROM production.products
ORDER BY price_band, list_price;

-- task 5
WITH order_revenue AS (
    SELECT
        o.order_id,
        o.order_date,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS order_total
    FROM sales.orders o
    JOIN sales.order_items oi ON oi.order_id = o.order_id
    GROUP BY o.order_id, o.order_date
)
SELECT
    order_id,
    order_date,
    order_total,
    SUM(order_total) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM order_revenue
ORDER BY order_date;


--task 6
--The default window frame, when ORDER BY is present in the OVER() clause but no explicit frame is specified, is:
--RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--This means: for any given row, the window only "sees" rows from the start of the partition up to (and including, with ties handled by RANGE) the current row — it does not see rows that come after it.
--Why FIRST_VALUE() works fine with the default frame:
--FIRST_VALUE() needs the first row of the partition, which is always inside the range "start of partition → current row," no matter which row you're currently on. So the default frame always includes it.
--Why LAST_VALUE() breaks with the default frame:
--LAST_VALUE() needs the last row of the entire partition. But with the default frame, the window only extends up to the current row — so as far as the frame is concerned, the "last row" is just whatever row you're currently sitting on. That's why, without changing the frame, LAST_VALUE() appears to just return the current row's own value at every step, instead of the true last value in the partition.
