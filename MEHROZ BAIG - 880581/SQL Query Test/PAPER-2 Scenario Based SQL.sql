-- =========================================================================
-- Scenario-Based SQL Assignment - BikeStores
-- =========================================================================

-- -------------------------------------------------------------------------
-- Task 1: Build the Sales Detail Dataset
-- -------------------------------------------------------------------------
-- Returns a detailed row per order item for completed orders, sorted newest to oldest.
SELECT 
    o.order_id, 
    o.order_date,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    st.store_name,
    CONCAT(sf.first_name, ' ', sf.last_name) AS staff_name,
    p.product_name, 
    cat.category_name, 
    b.brand_name,
    oi.quantity, 
    oi.list_price, 
    oi.discount,
    (oi.quantity * oi.list_price * (1 - oi.discount)) AS net_line_revenue
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN sales.customers c ON o.customer_id = c.customer_id
JOIN sales.stores st ON o.store_id = st.store_id
JOIN sales.staffs sf ON o.staff_id = sf.staff_id
JOIN production.products p ON oi.product_id = p.product_id
JOIN production.categories cat ON p.category_id = cat.category_id
JOIN production.brands b ON p.brand_id = b.brand_id
WHERE o.order_status = 4
ORDER BY o.order_date DESC;

-- -------------------------------------------------------------------------
-- Task 2: Store Performance Summary
-- -------------------------------------------------------------------------
-- Aggregates metrics at the store level for completed orders.
SELECT 
    st.store_name,
    COUNT(DISTINCT o.order_id) AS distinct_orders,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_net_revenue,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / COUNT(DISTINCT o.order_id) AS average_order_value
FROM sales.stores st
JOIN sales.orders o ON st.store_id = o.store_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 4
GROUP BY st.store_name
ORDER BY total_net_revenue DESC;

-- -------------------------------------------------------------------------
-- Task 3: High-Value Customers
-- -------------------------------------------------------------------------
-- Identifies customers spending more than the average completed-order customer.
WITH CustomerSpend AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        COUNT(DISTINCT o.order_id) AS completed_order_count,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spending
    FROM sales.customers c
    JOIN sales.orders o ON c.customer_id = o.customer_id
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 4
    GROUP BY c.customer_id, c.first_name, c.last_name
),
AvgSpend AS (
    SELECT AVG(total_spending) AS avg_total_spend 
    FROM CustomerSpend
)
SELECT 
    cs.customer_id, 
    cs.customer_name, 
    cs.completed_order_count, 
    cs.total_spending
FROM CustomerSpend cs
CROSS JOIN AvgSpend a
WHERE cs.total_spending > a.avg_total_spend
ORDER BY cs.total_spending DESC;

-- -------------------------------------------------------------------------
-- Task 4: Inventory Risk Report
-- -------------------------------------------------------------------------
-- Identifies products with critically low stock (< 5) in any store.
SELECT 
    p.product_name, 
    st.store_name, 
    s.quantity AS current_quantity,
    c.category_name, 
    b.brand_name
FROM production.stocks s
JOIN production.products p ON s.product_id = p.product_id
JOIN sales.stores st ON s.store_id = st.store_id
JOIN production.categories c ON p.category_id = c.category_id
JOIN production.brands b ON p.brand_id = b.brand_id
WHERE s.quantity < 5
ORDER BY s.quantity ASC;

-- -------------------------------------------------------------------------
-- Task 5: Top Products Within Each Category
-- -------------------------------------------------------------------------
-- Uses DENSE_RANK to find the top 3 products by revenue per category (no gaps in ties).
WITH ProductRevenue AS (
    SELECT 
        c.category_name, 
        p.product_name,
        SUM(oi.quantity) AS total_units_sold,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_net_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.categories c ON p.category_id = c.category_id
    WHERE o.order_status = 4
    GROUP BY c.category_name, p.product_name
),
RankedProducts AS (
    SELECT 
        category_name, 
        product_name, 
        total_units_sold, 
        total_net_revenue,
        DENSE_RANK() OVER(PARTITION BY category_name ORDER BY total_net_revenue DESC) AS category_position
    FROM ProductRevenue
)
SELECT 
    category_name, 
    product_name, 
    total_units_sold, 
    total_net_revenue, 
    category_position
FROM RankedProducts
WHERE category_position <= 3
ORDER BY category_name, category_position;

-- -------------------------------------------------------------------------
-- Task 6: Monthly Sales Trend
-- -------------------------------------------------------------------------
-- Uses LAG to calculate month-over-month revenue changes.
WITH MonthlySales AS (
    SELECT 
        YEAR(o.order_date) AS sales_year,
        MONTH(o.order_date) AS sales_month,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_net_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 4
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT 
    sales_year AS [year], 
    sales_month AS [month], 
    total_net_revenue,
    LAG(total_net_revenue) OVER(ORDER BY sales_year, sales_month) AS prev_month_revenue,
    total_net_revenue - LAG(total_net_revenue) OVER(ORDER BY sales_year, sales_month) AS revenue_change
FROM MonthlySales
ORDER BY sales_year, sales_month;

GO
-- -------------------------------------------------------------------------
-- Task 7: Reusable Reporting View
-- -------------------------------------------------------------------------
-- Summary of customer sales, gracefully handling customers with zero completed orders.
CREATE OR ALTER VIEW sales.vw_customer_sales_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS total_completed_orders,
    COALESCE(SUM(oi.quantity), 0) AS total_units_purchased,
    COALESCE(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 0) AS total_net_revenue,
    MAX(o.order_date) AS most_recent_completed_order_date
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id AND o.order_status = 4
LEFT JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name;

GO
-- -------------------------------------------------------------------------
-- Task 8: Safe Data Modification
-- -------------------------------------------------------------------------
-- Updates customer 1's phone number safely inside a transaction for testing.
BEGIN TRAN;

-- 1. Perform the update
UPDATE sales.customers
SET phone = '(999) 555-0101'
WHERE customer_id = 1;

-- 2. Validation query
SELECT 
    customer_id, 
    first_name, 
    last_name, 
    phone
FROM sales.customers
WHERE customer_id = 1;

-- 3. Rollback the transaction to prevent permanent DB alteration during assessment
ROLLBACK TRAN;

GO
-- -------------------------------------------------------------------------
-- Task 9: Store Sales Procedure
-- -------------------------------------------------------------------------
-- Retrieves completed order sales by product for a specific store and date range.
CREATE OR ALTER PROCEDURE sales.usp_store_sales_report
    @store_id INT,
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Error Handling: Verify start date is not after end date
    IF @start_date > @end_date
    BEGIN
        THROW 50001, 'Invalid Date Range: @start_date cannot be later than @end_date.', 1;
        RETURN;
    END

    SELECT 
        p.product_name,
        SUM(oi.quantity) AS total_units_sold,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_net_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    WHERE o.store_id = @store_id
      AND o.order_date >= @start_date
      AND o.order_date <= @end_date
      AND o.order_status = 4
    GROUP BY p.product_name
    ORDER BY total_net_revenue DESC;
END;

GO
-- -------------------------------------------------------------------------
-- Task 10: Management Insight Query
-- -------------------------------------------------------------------------
-- 1. Business Question: Which staff members generate the highest revenue, and are they over-discounting to achieve it?
-- 2. Measures: Total net revenue generated and the average discount applied per staff member.
-- 3. Why Care: Management needs to ensure top sellers are maintaining profit margins, not just giving away products to close deals.
SELECT 
    st.store_name,
    CONCAT(sf.first_name, ' ', sf.last_name) AS staff_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
    AVG(oi.discount) AS avg_discount_given
FROM sales.staffs sf
JOIN sales.orders o ON sf.staff_id = o.staff_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN sales.stores st ON sf.store_id = st.store_id
WHERE o.order_status = 4
GROUP BY st.store_name, sf.first_name, sf.last_name
ORDER BY total_revenue DESC;
```eof

All ten assignments have been completed using Microsoft SQL Server syntax, keeping with the structure and standard constraints of the dataset. I used standard batch separators (`GO`) to make sure your view and stored procedure definitions run perfectly when pasted into a management tool like SSMS or Azure Data Studio.