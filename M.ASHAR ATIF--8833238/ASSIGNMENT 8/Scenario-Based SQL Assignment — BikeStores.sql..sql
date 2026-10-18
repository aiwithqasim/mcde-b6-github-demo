SELECT * FROM
sales.customers;

SELECT * FROM
production.products;

-- Task 1 — Build the Sales Detail Dataset (6 marks)

SELECT
o.order_id,
o.order_date,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
s.store_name,
CONCAT(st.first_name, ' ', st.last_name) AS staff_name,
p.product_name,
cat.category_name,
b.brand_name,
oi.quantity,
oi.list_price,
oi.discount,
CAST(oi.quantity * oi.list_price * (1 - oi.discount) AS DECIMAL(18, 2)) AS net_line_revenue
FROM sales.orders o
JOIN sales.customers c ON o.customer_id = c.customer_id
JOIN sales.stores s ON o.store_id = s.store_id
JOIN sales.staffs st ON o.staff_id = st.staff_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN production.products p ON oi.product_id = p.product_id
JOIN production.categories cat ON p.category_id = cat.category_id
JOIN production.brands b ON p.brand_id = b.brand_id
WHERE o.order_status = 4 -- Completed orders only
ORDER BY o.order_date DESC, o.order_id DESC;


-- Task 2 — Store Performance Summary (5 marks)

SELECT
s.store_name,
COUNT(DISTINCT o.order_id) AS total_orders,
SUM(oi.quantity) AS total_units_sold,
CAST(SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS DECIMAL(18, 2)) AS total_net_revenue,
CAST(SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / COUNT(DISTINCT o.order_id) AS DECIMAL(18, 2)) AS avg_order_value
FROM sales.stores s
JOIN sales.orders o ON s.store_id = o.store_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 4
GROUP BY s.store_id, s.store_name
ORDER BY total_net_revenue DESC;


-- Task 3 — High-Value Customers (5 marks)

WITH CustomerSpending AS (
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
)
SELECT
customer_id,
customer_name,
completed_order_count,
CAST(total_spending AS DECIMAL(18, 2)) AS total_spending
FROM CustomerSpending
WHERE total_spending > (SELECT AVG(total_spending) FROM CustomerSpending)
ORDER BY total_spending DESC;


-- Task 4 — Inventory Risk Report (5 marks)

SELECT
p.product_name,
s.store_name,
stk.quantity AS current_quantity,
cat.category_name,
b.brand_name
FROM production.stocks stk
JOIN production.products p ON stk.product_id = p.product_id
JOIN sales.stores s ON stk.store_id = s.store_id
JOIN production.categories cat ON p.category_id = cat.category_id
JOIN production.brands b ON p.brand_id = b.brand_id
WHERE stk.quantity < 5
ORDER BY stk.quantity ASC, p.product_name ASC;

-- Task 5 — Top Products Within Each Category (6 marks)

WITH ProductCategoryRevenue AS (
SELECT
cat.category_name,
p.product_name,
SUM(oi.quantity) AS total_units_sold,
SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_net_revenue,
DENSE_RANK() OVER (
PARTITION BY cat.category_id
ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount)) DESC
) AS product_position
FROM production.categories cat
JOIN production.products p ON cat.category_id = p.category_id
JOIN sales.order_items oi ON p.product_id = oi.product_id
JOIN sales.orders o ON oi.order_id = o.order_id
WHERE o.order_status = 4
GROUP BY cat.category_id, cat.category_name, p.product_id, p.product_name
)
SELECT
category_name,
product_name,
total_units_sold,
CAST(total_net_revenue AS DECIMAL(18, 2)) AS total_net_revenue,
product_position
FROM ProductCategoryRevenue
WHERE product_position <= 3
ORDER BY category_name, product_position;


-- Task 6 — Monthly Sales Trend (6 marks)

WITH MonthlySales AS (
SELECT
YEAR(o.order_date) AS [year],
MONTH(o.order_date) AS [month],
SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_net_revenue
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 4
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
),
MonthlySalesWithLag AS (
SELECT
[year],
[month],
total_net_revenue,
LAG(total_net_revenue) OVER (ORDER BY [year], [month]) AS prev_month_net_revenue
FROM MonthlySales
)
SELECT
[year],
[month],
CAST(total_net_revenue AS DECIMAL(18, 2)) AS total_net_revenue,
CAST(prev_month_net_revenue AS DECIMAL(18, 2)) AS prev_month_net_revenue,
CAST(total_net_revenue - prev_month_net_revenue AS DECIMAL(18, 2)) AS revenue_change
FROM MonthlySalesWithLag
ORDER BY [year], [month];


-- Task 7 — Reusable Reporting View (4 marks)

-- Create or replace the view
CREATE OR ALTER VIEW sales.vw_customer_sales_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS total_completed_orders,
    ISNULL(SUM(oi.quantity), 0) AS total_units_purchased,
    CAST(ISNULL(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 0) AS DECIMAL(18, 2)) AS total_net_revenue,
    MAX(o.order_date) AS most_recent_completed_order_date
FROM sales.customers c
LEFT JOIN sales.orders o 
    ON c.customer_id = o.customer_id AND o.order_status = 4
LEFT JOIN sales.order_items oi 
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name;
GO

SELECT 
    customer_id,
    customer_name,
    total_completed_orders,
    total_units_purchased,
    total_net_revenue,
    most_recent_completed_order_date
FROM sales.vw_customer_sales_summary
ORDER BY total_net_revenue DESC;
GO

-- Task 8 — Safe Data Modification (4 marks)

BEGIN TRANSACTION;

-- Perform targeted phone number update
UPDATE sales.customers
SET phone = '(999) 555-0101'
WHERE customer_id = 1;

-- Validation query to check updated phone number
SELECT customer_id, first_name, last_name, phone
FROM sales.customers
WHERE customer_id = 1;

-- Rollback during testing to prevent permanent changes
ROLLBACK TRANSACTION;

-- Task 9 — Store Sales Procedure (6 marks)
-- Create or replace the stored procedure
CREATE OR ALTER PROCEDURE sales.usp_store_sales_report
    @store_id INT,
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Date range validation check
    IF @start_date > @end_date
    BEGIN
        RAISERROR('Invalid Date Range: @start_date cannot be later than @end_date.', 16, 1);
        RETURN;
    END;

    SELECT 
        p.product_name,
        SUM(oi.quantity) AS total_units_sold,
        CAST(SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS DECIMAL(18, 2)) AS total_net_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    WHERE o.store_id = @store_id
      AND o.order_status = 4
      AND o.order_date >= @start_date
      AND o.order_date <= @end_date
    GROUP BY p.product_id, p.product_name
    ORDER BY total_net_revenue DESC;
END;
GO

-- EXECUTOIN
EXEC sales.usp_store_sales_report 
    @store_id = 1, 
    @start_date = '2017-01-01', 
    @end_date = '2017-12-31';
GO


-- Task 10 — Management Insight Query (3 marks)

SELECT
st.staff_id,
CONCAT(st.first_name, ' ', st.last_name) AS staff_name,
s.store_name,
COUNT(DISTINCT o.order_id) AS total_orders_processed,
CAST(SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS DECIMAL(18, 2)) AS total_revenue_generated
FROM sales.staffs st
JOIN sales.stores s ON st.store_id = s.store_id
JOIN sales.orders o ON st.staff_id = o.staff_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 4
GROUP BY st.staff_id, st.first_name, st.last_name, s.store_name
ORDER BY total_revenue_generated DESC;
