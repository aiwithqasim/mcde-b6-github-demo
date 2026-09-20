--  TASK=1 
-- Assign a sequential row number to each product ordered by list_price descending. Then assign a second row number partitioned by category_id, resetting within each category.
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

-- TASK=2
-- Write a query that returns each product with its RANK() and DENSE_RANK() by list_price descending within its category. Show a product where the two rankings differ.
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

FROM production.products;

-- TASK=3
-- Use LAG() to calculate the month-over-month revenue change for each store. Show the current month revenue, the previous month revenue, and the difference
WITH monthly_revenue AS (
    SELECT
        store_id,
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        SUM(oi.quantity * oi.list_price) AS current_month_revenue
    FROM sales.orders o
    INNER JOIN sales.order_items oi
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
    current_month_revenue,

    LAG(current_month_revenue) OVER (
        PARTITION BY store_id
        ORDER BY order_year, order_month
    ) AS previous_month_revenue,

    current_month_revenue
    - LAG(current_month_revenue) OVER (
        PARTITION BY store_id
        ORDER BY order_year, order_month
    ) AS revenue_difference

FROM monthly_revenue
ORDER BY store_id, order_year, order_month;

-- TASK=4
-- Use NTILE(5) to divide all products into five price bands. Return the product name, price, and band number.\
SELECT
    product_id,
    product_name,
    list_price,

    NTILE(5) OVER (
        ORDER BY list_price
    ) AS price_band

FROM production.products
ORDER BY list_price;

-- TASK=5
--  Write a query that shows each order with a running total of revenue ordered by order_date. Use ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.
SELECT
    o.order_id,
    o.order_date,
    SUM(oi.quantity * oi.list_price) AS order_revenue,

    SUM(SUM(oi.quantity * oi.list_price)) OVER (
        ORDER BY o.order_date, o.order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue

FROM sales.orders o
INNER JOIN sales.order_items oi
    ON o.order_id = oi.order_id

GROUP BY
    o.order_id,
    o.order_date

ORDER BY
    o.order_date,
    o.order_id;


-- Task=6 
-- Think About It: Why does LAST_VALUE() require RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING to return the actual last value in the partition, while FIRST_VALUE() works correctly with the default frame? What is the default window frame when ORDER BY is specified, and how does that explain the behavior
SELECT
    product_id,
    product_name,
    category_id,
    list_price,

    FIRST_VALUE(list_price) OVER (
        PARTITION BY category_id
        ORDER BY list_price DESC
    ) AS highest_price,

    LAST_VALUE(list_price) OVER (
        PARTITION BY category_id
        ORDER BY list_price DESC
        RANGE BETWEEN UNBOUNDED PRECEDING
              AND UNBOUNDED FOLLOWING
    ) AS lowest_price

FROM production.products;