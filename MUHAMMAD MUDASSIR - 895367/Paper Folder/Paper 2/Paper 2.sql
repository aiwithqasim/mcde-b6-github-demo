--TASK-1
SELECT 
    o.order_id,
    o.order_date,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
    s.store_name,
    CONCAT(st.first_name, ' ', st.last_name) AS staff_full_name,
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
JOIN sales.stores s ON o.store_id = s.store_id
JOIN sales.staffs st ON o.staff_id = st.staff_id
JOIN production.products p ON oi.product_id = p.product_id
JOIN production.categories cat ON p.category_id = cat.category_id
JOIN production.brands b ON p.brand_id = b.brand_id
WHERE o.order_status = 4
ORDER BY o.order_date DESC;

--TASK-2
SELECT 
    s.store_name,
    COUNT(DISTINCT o.order_id) AS number_of_distinct_orders,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_net_revenue,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / COUNT(DISTINCT o.order_id) AS average_order_value
FROM sales.stores s
JOIN sales.orders o ON s.store_id = o.store_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 4
GROUP BY s.store_id, s.store_name
ORDER BY total_net_revenue DESC;

--TASK-3
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
    total_spending
FROM CustomerSpending
WHERE total_spending > (
    SELECT AVG(total_spending) 
    FROM CustomerSpending
)
ORDER BY total_spending DESC;

--TASK-4
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

--TASK-5
WITH RankedProducts AS (
    SELECT 
        cat.category_name,
        p.product_name,
        SUM(oi.quantity) AS total_units_sold,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_net_revenue,
        DENSE_RANK() OVER (
            PARTITION BY cat.category_id 
            ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount)) DESC
        ) AS product_position
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.categories cat ON p.category_id = cat.category_id
    WHERE o.order_status = 4
    GROUP BY cat.category_id, cat.category_name, p.product_id, p.product_name
)
SELECT 
    category_name,
    product_name,
    total_units_sold,
    total_net_revenue,
    product_position
FROM RankedProducts
WHERE product_position <= 3
ORDER BY category_name ASC, product_position ASC;

--TASK-6
WITH MonthlySales AS (
    SELECT 
        YEAR(o.order_date) AS [year],
        MONTH(o.order_date) AS [month],
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_net_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 4
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT 
    [year],
    [month],
    total_net_revenue,
    LAG(total_net_revenue) OVER (ORDER BY [year], [month]) AS previous_month_total_net_revenue,
    total_net_revenue - LAG(total_net_revenue) OVER (ORDER BY [year], [month]) AS revenue_change
FROM MonthlySales
ORDER BY [year] ASC, [month] ASC;
GO   -- <<< added

--TASK-7
CREATE OR ALTER VIEW sales.vw_customer_sales_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
    COUNT(DISTINCT o.order_id) AS total_number_of_completed_orders,
    ISNULL(SUM(oi.quantity), 0) AS total_units_purchased,
    ISNULL(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 0) AS total_net_revenue,
    MAX(o.order_date) AS most_recent_completed_order_date
FROM sales.customers c
LEFT JOIN sales.orders o 
    ON c.customer_id = o.customer_id 
   AND o.order_status = 4
LEFT JOIN sales.order_items oi 
    ON o.order_id = oi.order_id
GROUP BY 
    c.customer_id, 
    c.first_name, 
    c.last_name;
GO   -- <<< added (required)

--TASK-8
BEGIN TRANSACTION;

UPDATE sales.customers
SET phone = '(999) 555-0101'
WHERE customer_id = 1;

SELECT customer_id, first_name, last_name, phone 
FROM sales.customers
WHERE customer_id = 1;

ROLLBACK TRANSACTION;
GO   -- <<< added (required before the procedure)

--TASK-9
CREATE OR ALTER PROCEDURE sales.usp_store_sales_report
    @store_id INT,
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF @start_date > @end_date
    BEGIN
        RAISERROR('Invalid date range: @start_date cannot be later than @end_date.', 16, 1);
        RETURN;
    END;

    SELECT 
        p.product_name,
        SUM(oi.quantity) AS total_units_sold,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_net_revenue
    FROM sales.orders o
    INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
    INNER JOIN production.products p ON oi.product_id = p.product_id
    WHERE o.store_id = @store_id
      AND o.order_date BETWEEN @start_date AND @end_date
      AND o.order_status = 4
    GROUP BY p.product_id, p.product_name
    ORDER BY total_net_revenue DESC;
END;
GO
-- TASK-10
SELECT 
    s.store_name,
    SUM(oi.quantity * oi.list_price) AS gross_revenue,
    SUM(oi.quantity * oi.list_price * oi.discount) AS total_discount,
    CAST(100.0 * SUM(oi.quantity * oi.list_price * oi.discount)
         / SUM(oi.quantity * oi.list_price) AS DECIMAL(5,2)) AS discount_pct
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN sales.stores s ON o.store_id = s.store_id
WHERE o.order_status = 4
GROUP BY s.store_name
ORDER BY discount_pct DESC;

-- Business question: Which store gives away the largest share of its revenue in discounts?
-- Measures: total discount value and discount as a percentage of pre-discount revenue per store.
-- Why it matters: high discounting can erode margin, so management can review store pricing and promotions.