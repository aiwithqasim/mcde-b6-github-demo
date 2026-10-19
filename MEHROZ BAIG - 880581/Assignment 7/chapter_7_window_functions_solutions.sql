-- =========================================================================
-- Chapter 7: Window Functions - Exercise Solutions
-- Dataset: BikeStores
-- Dialect: T-SQL (Microsoft SQL Server)
-- =========================================================================

-- -------------------------------------------------------------------------
-- Exercise 7.1
-- -------------------------------------------------------------------------
SELECT 
    product_id,
    product_name,
    category_id,
    list_price,
    ROW_NUMBER() OVER (ORDER BY list_price DESC) AS overall_row_num,
    ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS category_row_num
FROM production.products
ORDER BY list_price DESC;

GO
-- -------------------------------------------------------------------------
-- Exercise 7.2
-- -------------------------------------------------------------------------
WITH RankedProducts AS (
    SELECT 
        product_name,
        category_id,
        list_price,
        RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS rank_val,
        DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price DESC) AS dense_rank_val
    FROM production.products
)
-- Filtering to only show where the gap caused by RANK() creates a difference
SELECT * 
FROM RankedProducts
WHERE rank_val <> dense_rank_val;

GO
-- -------------------------------------------------------------------------
-- Exercise 7.3
-- -------------------------------------------------------------------------
WITH MonthlyStoreRevenue AS (
    SELECT 
        o.store_id,
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS current_month_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.store_id, YEAR(o.order_date), MONTH(o.order_date)
),
RevenueWithLag AS (
    SELECT 
        store_id,
        order_year,
        order_month,
        current_month_revenue,
        LAG(current_month_revenue) OVER (
            PARTITION BY store_id 
            ORDER BY order_year, order_month
        ) AS previous_month_revenue
    FROM MonthlyStoreRevenue
)
SELECT 
    store_id,
    order_year,
    order_month,
    current_month_revenue,
    previous_month_revenue,
    (current_month_revenue - previous_month_revenue) AS revenue_difference
FROM RevenueWithLag
ORDER BY store_id, order_year, order_month;

GO
-- -------------------------------------------------------------------------
-- Exercise 7.4
-- -------------------------------------------------------------------------
SELECT 
    product_name,
    list_price,
    -- NTILE(5) distributes rows into 5 approximately equal buckets
    NTILE(5) OVER (ORDER BY list_price DESC) AS price_band
FROM production.products
ORDER BY list_price DESC;

GO
-- -------------------------------------------------------------------------
-- Exercise 7.5
-- -------------------------------------------------------------------------
WITH OrderRevenue AS (
    SELECT 
        o.order_id,
        o.order_date,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS order_total
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.order_date
)
SELECT 
    order_id,
    order_date,
    order_total,
    SUM(order_total) OVER (
        ORDER BY order_date, order_id 
        -- This frame dictates that the sum starts at the first row and ends at the current row
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_revenue_total
FROM OrderRevenue
ORDER BY order_date, order_id;

GO
-- -------------------------------------------------------------------------
