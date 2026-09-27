
--- Assignment 7 - Window Functions (tasks 7.1 - 7.6) ---

-- 7.1 - Assign a sequential row number to each product ordered by list_price descending. Then assign a second row number partitioned by category_id, resetting within each category.

SELECT 
    product_id,
    product_name,
    category_id,
    list_price,
    ROW_NUMBER() OVER (ORDER BY list_price DESC) AS overall_row_num,
    ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS category_row_num
FROM production.products;


-- 7.2 - Write a query that returns each product with its RANK() and DENSE_RANK() by list_price descending within its category. Show a product where the two rankings differ.

WITH ranked_products AS (
    SELECT 
        product_id,
        product_name,
        category_id,
        list_price,
        RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS price_rank,
        DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS price_dense_rank
    FROM production.products
)
SELECT 
    product_id,
    product_name,
    category_id,
    list_price,
    price_rank,
    price_dense_rank
FROM ranked_products
WHERE price_rank <> price_dense_rank;


-- 7.3 - Use LAG() to calculate the month-over-month revenue change for each store. Show the current month revenue, the previous month revenue, and the difference.


WITH monthly_revenue AS (
    SELECT 
    o.store_id,
    DATEFROMPARTS(YEAR(o.order_date), MONTH(o.order_date), 1) AS revenue_month,
    SUM(i.quantity * i.list_price * (1 - i.discount)) AS current_month_revenue
    FROM sales.orders o
    JOIN sales.order_items i ON o.order_id = i.order_id
    GROUP BY o.store_id, YEAR(o.order_date), MONTH(o.order_date)
)
SELECT 
    store_id,
    revenue_month,
    ROUND(current_month_revenue, 2) AS current_month_revenue,
    ROUND(LAG(current_month_revenue) OVER (PARTITION BY store_id ORDER BY revenue_month), 2) AS previous_month_revenue,
    ROUND(
    current_month_revenue - LAG(current_month_revenue) OVER (PARTITION BY store_id ORDER BY revenue_month), 
    2
    ) AS mom_difference
FROM monthly_revenue
ORDER BY store_id, revenue_month;


-- 7.4 - Use NTILE(5) to divide all products into five price bands. Return the product name, price, and band number.

SELECT 
    product_name,
    list_price,
    NTILE(5) OVER (ORDER BY list_price DESC) AS price_band
FROM production.products;


-- 7.5 - Write a query that shows each order with a running total of revenue ordered by order_date. Use ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.

WITH order_totals AS (
    SELECT 
    o.order_id,
    o.order_date,
    SUM(i.quantity * i.list_price * (1 - i.discount)) AS order_revenue
    FROM sales.orders o
    JOIN sales.order_items i ON o.order_id = i.order_id
    GROUP BY o.order_id, o.order_date
)
SELECT 
    order_id,
    order_date,
    ROUND(order_revenue, 2) AS order_revenue,
    ROUND(
    SUM(order_revenue) OVER (
    ORDER BY order_date, order_id 
     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 
        2
    ) AS running_total_revenue
FROM order_totals
ORDER BY order_date, order_id;


/*
7.6 - Think About It: Why does LAST_VALUE() require RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING to return the actual last value in the partition, while FIRST_VALUE() works correctly with the default frame? What is the default window frame when ORDER BY is specified, and how does that explain the behavior?

Answer:

1. Default Window Frame:
When ORDER BY is used, the default frame is:
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.

2. Why FIRST_VALUE() works:
The start boundary (UNBOUNDED PRECEDING) always points to the first row of the partition, so FIRST_VALUE() easily returns the correct initial value.

3. Why LAST_VALUE() requires UNBOUNDED FOLLOWING:
Because the default frame stops at the CURRENT ROW, LAST_VALUE() only evaluates up to the current row rather than the end of the partition. We must explicitly specify UNBOUNDED FOLLOWING to extend the frame to the final row of the entire partition.
*/