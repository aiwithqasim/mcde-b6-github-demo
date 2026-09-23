-- 1. (Easy) List every order with the customer's full name, store name, and the full name of the staff member who handled it.

SELECT 
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    st.store_name,
    s.first_name + ' ' + s.last_name AS staff_name
FROM sales.orders o
INNER JOIN sales.customers c ON o.customer_id = c.customer_id
INNER JOIN sales.stores st ON o.store_id = st.store_id
INNER JOIN sales.staffs s ON o.staff_id = s.staff_id;

-- 2. (Easy) Show each product with its brand name and category name. Include products even if they have no brand or category assigned.

SELECT 
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products p
LEFT JOIN production.brands b ON p.brand_id = b.brand_id
LEFT JOIN production.categories c ON p.category_id = c.category_id;

-- 3. (Medium) Find all customers who have never placed an order. Return their name, city, and email.

SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    c.city,
    c.email
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- GROUP BY

-- 4. (Easy) Calculate total revenue per store. Revenue = quantity * list_price * (1 - discount). Sort from highest to lowest.

SELECT 
    st.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.stores st
INNER JOIN sales.orders o ON st.store_id = o.store_id
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY st.store_name
ORDER BY total_revenue DESC;

-- 5. (Medium) For each brand, show the number of products, the average list price, and the highest list price. Only include brands with more than 5 products.

SELECT 
    b.brand_name,
    COUNT(p.product_id) AS product_count,
    AVG(p.list_price) AS avg_price,
    MAX(p.list_price) AS max_price
FROM production.brands b
INNER JOIN production.products p ON b.brand_id = p.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 5;

-- 6. (Medium) Show the number of orders and total revenue per month for the year 2017, ordered chronologically.

SELECT 
    MONTH(o.order_date) AS month,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY MONTH(o.order_date)
ORDER BY month;

-- SUBQUERIES

-- 7. (Medium) Find all products priced above the average list price of their own category.

SELECT 
    p.product_name,
    p.category_id,
    p.list_price
FROM production.products p
WHERE p.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p.category_id
);

-- 8. (Medium) List the customers who have placed more orders than the average number of orders per customer.

SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers c
INNER JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(order_id) AS order_count
        FROM sales.orders
        GROUP BY customer_id
    ) AS avg_orders
);

-- CTEs

-- 9. (Hard) Using a CTE, calculate each customer's total spend, then return the top 10 customers with their spend and rank. Add a second CTE that labels each customer as "High" (above the overall average spend) or "Regular".

WITH customer_spend AS (
    SELECT 
        c.customer_id,
        c.first_name + ' ' + c.last_name AS customer_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spend
    FROM sales.customers c
    INNER JOIN sales.orders o ON c.customer_id = o.customer_id
    INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
ranked AS (
    SELECT 
        customer_id,
        customer_name,
        total_spend,
        RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
    FROM customer_spend
),
labeled AS (
    SELECT 
        customer_id,
        customer_name,
        total_spend,
        spend_rank,
        CASE 
            WHEN total_spend > (SELECT AVG(total_spend) FROM customer_spend) THEN 'High'
            ELSE 'Regular'
        END AS customer_label
    FROM ranked
)
SELECT TOP 10 *
FROM labeled
ORDER BY spend_rank;

-- 10. (Hard) Using CTEs, find the best-selling product (by quantity) in each category, and show how much of that product's stock is currently available across all stores.

WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity) AS total_sold
    FROM production.products p
    INNER JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category_id
),
ranked AS (
    SELECT 
        product_id,
        product_name,
        category_id,
        total_sold,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY total_sold DESC) AS rn
    FROM product_sales
),
best_per_category AS (
    SELECT 
        product_id,
        product_name,
        category_id,
        total_sold
    FROM ranked
    WHERE rn = 1
)
SELECT 
    c.category_name,
    bpc.product_name,
    bpc.total_sold,
    ISNULL(SUM(s.quantity), 0) AS stock_available
FROM best_per_category bpc
INNER JOIN production.categories c ON bpc.category_id = c.category_id
LEFT JOIN production.stocks s ON bpc.product_id = s.product_id
GROUP BY c.category_name, bpc.product_name, bpc.total_sold;

-- BONUS CHALLENGES

-- Bonus 1: Rewrite Q8 using a CTE instead of a subquery and compare readability.

WITH order_counts AS (
    SELECT 
        customer_id,
        COUNT(order_id) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
avg_orders AS (
    SELECT AVG(order_count) AS avg_count
    FROM order_counts
)
SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    oc.order_count
FROM sales.customers c
INNER JOIN order_counts oc ON c.customer_id = oc.customer_id
CROSS JOIN avg_orders ao
WHERE oc.order_count > ao.avg_count;
-- CTE version is more readable because it breaks the logic into steps.

-- Bonus 2: For Q4, add a column showing each store's percentage share of total company revenue.

SELECT 
    st.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
    CAST(
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * 100.0 / 
        SUM(SUM(oi.quantity * oi.list_price * (1 - oi.discount))) OVER () 
    AS DECIMAL(10,2)) AS revenue_percentage
FROM sales.stores st
INNER JOIN sales.orders o ON st.store_id = o.store_id
INNER JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY st.store_name
ORDER BY total_revenue DESC;