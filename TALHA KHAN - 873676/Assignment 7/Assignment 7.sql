-- 7.1  Assign a sequential row number to each product ordered by list_price descending. Then assign a second row number partitioned by category_id, 
--resetting within each category.
SELECT 
    product_id,
    product_name,
    category_id,
    list_price,
    ROW_NUMBER() OVER (ORDER BY list_price DESC) AS overall_rn,
    ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS category_rn
FROM production.products;


-- 7.2 Write a query that returns each product with its RANK() and DENSE_RANK() 
--by list_price descending within its category. Show a product where the two rankings differ.
WITH RankedProducts AS (
    SELECT 
        product_name,
        category_id,
        list_price,
        RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS price_rank,
        DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS price_dense_rank
    FROM production.products
)
SELECT 
    product_name,
    category_id,
    list_price,
    price_rank,
    price_dense_rank
FROM RankedProducts
WHERE price_rank <> price_dense_rank;


-- 7.3 --Use LAG() to calculate the month-over-month revenue 
--change for each store. Show the current month revenue, the previous month revenue, and the difference.


WITH MonthlyStoreSales AS (
    SELECT 
        s.store_name,
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS current_month_rev
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN sales.stores s ON o.store_id = s.store_id
    WHERE o.order_status = 4
    GROUP BY s.store_name, YEAR(o.order_date), MONTH(o.order_date)
)
SELECT 
    store_name,
    sales_year,
    sales_month,
    current_month_rev,
    LAG(current_month_rev) OVER (
        PARTITION BY store_name 
        ORDER BY sales_year, sales_month
    ) AS prev_month_rev,
    current_month_rev - LAG(current_month_rev) OVER (
        PARTITION BY store_name 
        ORDER BY sales_year, sales_month
    ) AS rev_difference
FROM MonthlyStoreSales
ORDER BY store_name, sales_year, sales_month;


-- 7.4 Use NTILE(5) to divide all products into five price bands. Return the product
 --name, price, and band number.
SELECT 
    product_name,
    list_price,
    NTILE(5) OVER (ORDER BY list_price DESC) AS price_band
FROM production.products;


-- 7.5 -- Write a query that shows each order with a running total of revenue ordered 
--by order_date. Use ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.

WITH OrderTotals AS (
    SELECT 
        o.order_id,
        o.order_date,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS order_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.order_date
)
SELECT 
    order_id,
    order_date,
    order_revenue,
    SUM(order_revenue) OVER (
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_revenue_total
FROM OrderTotals
ORDER BY order_date, order_id;