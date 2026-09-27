

---Task 1

SELECT 
    o.order_id,
    o.order_date,
    c.first_name + ' ' + c.last_name AS Customer_name,
    s.store_name,
    st.first_name + ' ' + st.last_name AS Staff_name,
    p.product_name,
    cat.category_name,
    b.brand_name,
    i.quantity,
    i.list_price,
    i.discount,
    i.quantity * i.list_price * (1 - i.discount) AS net_line_revenue
FROM sales.orders o
Join sales.customers c ON o.customer_id = c.customer_id
join sales.stores s ON o.store_id = s.store_id
Join sales.staffs st ON o.staff_id = st.staff_id
Join sales.order_items i ON o.order_id = i.order_id
join production.products p ON i.product_id = p.product_id
Join production.categories cat ON p.category_id = cat.category_id
join production.brands b ON p.brand_id = b.brand_id
WHERE o.order_status = 4
Order By o.order_date Desc;


--Task 2
SELECT 
    s.store_name,
    COUNT(DISTINCT o.order_id) AS distinct_orders,
    SUM(i.quantity) AS total_units_sold,
    SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_net_revenue,
    SUM(i.quantity * i.list_price * (1 - i.discount)) / COUNT(DISTINCT o.order_id) AS avg_order_value
FROM sales.orders o
Join sales.order_items i ON o.order_id = i.order_id
Join sales.stores s ON o.store_id = s.store_id
WHERE o.order_status = 4
GROUP BY s.store_name
order by total_net_revenue Desc;

---Task 3
WITH customer_spending AS (
    SELECT 
        c.customer_id,
        c.first_name + ' ' + c.last_name AS customer_name,
        COUNT(DISTINCT o.order_id) AS completed_orders,
        SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_spending
    FROM sales.customers c
    Join sales.orders o ON c.customer_id = o.customer_id
    Join sales.order_items i ON o.order_id = i.order_id
    WHERE o.order_status = 4
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT *
FROM customer_spending
WHERE total_spending > (SELECT AVG(total_spending) FROM customer_spending)
order by total_spending DESC;

---Task 4
SELECT 
    p.product_name,
    s.store_name,
    st.quantity,
    c.category_name,
    b.brand_name
FROM production.stocks st
Join production.products p ON st.product_id = p.product_id
Join production.categories c ON p.category_id = c.category_id
Join production.brands b ON p.brand_id = b.brand_id
Join sales.stores s ON st.store_id = s.store_id
WHERE st.quantity < 5
order by st.quantity ASC;

--Task 5

WITH product_revenue AS (
    SELECT 
        cat.category_name,
        p.product_name,
        SUM(i.quantity) AS total_units_sold,
        SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_net_revenue
    FROM sales.orders o
    Join sales.order_items i ON o.order_id = i.order_id
    Join production.products p ON i.product_id = p.product_id
    Join production.categories cat ON p.category_id = cat.category_id
    WHERE o.order_status = 4
    GROUP BY cat.category_name, p.product_name
),
ranked_products AS (
    SELECT *,
           DENSE_RANK() OVER (Partition BY category_name Order BY total_net_revenue DESC) AS position
    FROM product_revenue
)
SELECT *
FROM ranked_products
WHERE position <= 3;



-- Task 6

WITH monthly_sales AS (
    SELECT 
        YEAR(o.order_date) AS year,
        MONTH(o.order_date) AS month,
        SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_net_revenue
    FROM sales.orders o
    Join sales.order_items i ON o.order_id = i.order_id
    WHERE o.order_status = 4
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT 
    year,
    month,
    total_net_revenue,
    LAG(total_net_revenue) OVER (ORDER BY year, month) AS prev_month_revenue,
    total_net_revenue - LAG(total_net_revenue) OVER (ORDER BY year, month) AS revenue_change
FROM monthly_sales
ORDER BY year, month;


-- Task 7

CREATE VIEW sales.vw_customer_sales_summary AS
SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    COALESCE(SUM(i.quantity),0) AS total_units_purchased,
    COALESCE(SUM(i.quantity * i.list_price * (1 - i.discount)),0) AS total_net_revenue,
    MAX(o.order_date) AS most_recent_order_date
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id AND o.order_status = 4
LEFT JOIN sales.order_items i ON o.order_id = i.order_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Task 8
BEGIN TRANSACTION;

UPDATE sales.customers
SET phone = '(999) 555-0101'
WHERE customer_id = 1;
SELECT customer_id, phone FROM sales.customers WHERE customer_id = 1;
ROLLBACK;


-- Task 9

CREATE PROCEDURE sales.usp_store_sales_report
    @store_id INT,
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    IF @start_date > @end_date
    BEGIN
        RAISERROR('Invalid date range: start_date is later than end_date', 16, 1);
        RETURN;
    END;

    SELECT 
        p.product_name,
        SUM(i.quantity) AS total_units_sold,
        SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_net_revenue
    FROM sales.orders o
    JOIN sales.order_items i ON o.order_id = i.order_id
    JOIN production.products p ON i.product_id = p.product_id
    WHERE o.store_id = @store_id
      AND o.order_status = 4
      AND o.order_date BETWEEN @start_date AND @end_date
    GROUP BY p.product_name
    ORDER BY total_net_revenue DESC;
END;


--Task 10

SELECT 
    st.staff_id,
    CONCAT(st.first_name, ' ', st.last_name) AS staff_name,
    COUNT(DISTINCT o.order_id) AS total_orders_handled,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS total_net_revenue
FROM sales.staffs st
join sales.orders o ON st.staff_id = o.staff_id
join sales.order_items oi ON o.order_id = oi.order_id
where o.order_status <> 3 -- Excluding 'Rejected/Canceled' orders
Group by st.staff_id, st.first_name, st.last_name
order by total_net_revenue desc;

/* 
BUSINESS QUESTION: Our top sales staffs by net revenue?
MEASUREMENT: staff performance by unique orders, volume, and net revenue.
WHY MANAGEMENT CARE: To see their best staffs.
*/
