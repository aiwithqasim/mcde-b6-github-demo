-- 7.1 - Assign a sequential row number to each product ordered by list_price descending. Then assign a second row number partitioned by category_id, resetting within each category.

SELECT 
    product_id,
    product_name,
    category_id,
    list_price,
    ROW_NUMBER() OVER (ORDER BY list_price DESC) AS row_num_global,
    ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS row_num_per_category
FROM production.products;

-- 7.2 - Write a query that returns each product with its RANK() and DENSE_RANK() by list_price descending within its category. Show a product where the two rankings differ.

SELECT 
    product_id,
    product_name,
    category_id,
    list_price,
    RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS rank_num,
    DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS dense_rank_num
FROM production.products
ORDER BY category_id, list_price DESC;

-- 7.3 - Use LAG() to calculate the month-over-month revenue change for each store. Show the current month revenue, the previous month revenue, and the difference.

WITH monthly_revenue AS (
    SELECT 
        st.store_id,
        st.store_name,
        MONTH(o.order_date) AS month,
        YEAR(o.order_date) AS year,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM sales.stores st
    INNER JOIN sales.orders o ON st.store_id = o.store_id
    INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY st.store_id, st.store_name, YEAR(o.order_date), MONTH(o.order_date)
)
SELECT 
    store_name,
    year,
    month,
    revenue AS current_month_revenue,
    LAG(revenue) OVER (PARTITION BY store_id ORDER BY year, month) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (PARTITION BY store_id ORDER BY year, month) AS revenue_change
FROM monthly_revenue
ORDER BY store_name, year, month;

-- 7.4 - Use NTILE(5) to divide all products into five price bands. Return the product name, price, and band number.

SELECT 
    product_name,
    list_price,
    NTILE(5) OVER (ORDER BY list_price DESC) AS price_band
FROM production.products
ORDER BY list_price DESC;

-- 7.5 - Write a query that shows each order with a running total of revenue ordered by order_date. Use ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.

SELECT 
    o.order_id,
    o.order_date,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS order_revenue,
    SUM(SUM(oi.quantity * oi.list_price * (1 - oi.discount))) 
        OVER (ORDER BY o.order_date 
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM sales.orders o
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date
ORDER BY o.order_date;

-- 7.6 - Think About It: Why does LAST_VALUE() require RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING to return the actual last value in the partition, while FIRST_VALUE() works correctly with the default frame? What is the default window frame when ORDER BY is specified, and how does that explain the behavior?

-- Answer:
-- The default window frame when ORDER BY is specified is:
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--
-- This means the window only includes rows from the start of the partition
-- up to the current row. So:
--   FIRST_VALUE() returns the first row of the partition (correct).
--   LAST_VALUE() returns the current row, not the actual last row of the
--   partition, because the frame ends at the current row.
--
-- To make LAST_VALUE() return the true last value of the partition,
-- you must extend the frame to the end:
-- RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING