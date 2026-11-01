-- Assignment: windows functions
-- Student: Talha
-- Saylani ID: [CDE-884628]

Exercise 7.1 Assign a sequential row number to each product ordered by list_price descending. Then assign a second row number partitioned by category_id, resetting within each category.
Solution:
SELECT
    product_name,
    category_id,
    list_price,
    ROW_NUMBER() OVER (ORDER BY list_price DESC) AS row_num,
    ROW_NUMBER() OVER (
        PARTITION BY category_id
        ORDER BY list_price DESC
    ) AS category_row_num
FROM production.products;
Exercise 7.2 Write a query that returns each product with its RANK() and DENSE_RANK() by list_price descending within its category. Show a product where the two rankings differ.
Solution:
WITH ranked_products AS (
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
        ) AS dense_price_rank
    FROM production.products
)
SELECT
    product_name,
    category_id,
    list_price,
    price_rank,
    dense_price_rank
FROM ranked_products
WHERE price_rank <> dense_price_rank;
Exercise 7.3 Use LAG() to calculate the month-over-month revenue change for each store. Show the current month revenue, the previous month revenue, and the difference.
Solution:
WITH monthly_revenue AS (
    SELECT
        o.store_id,
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS current_revenue
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.store_id, YEAR(o.order_date), MONTH(o.order_date)
)
SELECT
    store_id,
    order_year,
    order_month,
    current_revenue,
    LAG(current_revenue) OVER (
        PARTITION BY store_id
        ORDER BY order_year, order_month
    ) AS previous_revenue,
    current_revenue -
    LAG(current_revenue) OVER (
        PARTITION BY store_id
        ORDER BY order_year, order_month
    ) AS revenue_change
FROM monthly_revenue
ORDER BY store_id, order_year, order_month;
Exercise 7.4
Question: Use NTILE(5) to divide all products into five price bands. Return the product name, price, and band number.
Solution:
SELECT
    product_name,
    list_price,
    NTILE(5) OVER (ORDER BY list_price) AS price_band
FROM production.products
ORDER BY list_price;
Exercise 7.5 Write a query that shows each order with a running total of revenue ordered by order_date. Use ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.
Solution:
SELECT
    o.order_id,
    o.order_date,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS order_revenue,
    SUM(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount))
    ) OVER (
        ORDER BY o.order_date, o.order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date
ORDER BY o.order_date, o.order_id;
Exercise 7.6 Why does LAST_VALUE() require RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING to return the actual last value in the partition, while FIRST_VALUE() works correctly with the default frame? What is the default window frame when ORDER BY is specified, and how does that explain the behavior?
Solution:
SELECT
    product_name,
    category_id,
    list_price,
    FIRST_VALUE(product_name) OVER (
        PARTITION BY category_id
        ORDER BY list_price
    ) AS cheapest_product,
    LAST_VALUE(product_name) OVER (
        PARTITION BY category_id
        ORDER BY list_price
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS most_expensive_product
FROM production.products;
