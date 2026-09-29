-- QUESTION 1 : List every order with the customer's full name, store name, and the full name of the staff member who handled it.
SELECT 
    o.order_id,
    o.order_date,
    c.first_name + ' ' + c.last_name AS customer_name,
    s.store_name,
    st.first_name + ' ' + st.last_name AS staff_name
FROM sales.orders o
JOIN sales.customers c ON o.customer_id = c.customer_id
JOIN sales.stores s ON o.store_id = s.store_id
JOIN sales.staffs st ON o.staff_id = st.staff_id
ORDER BY o.order_id;

-- QUESTION 2 :   Show each product with its brand name and category name. Include products even if they have no brand or category assigned.
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products p
LEFT JOIN production.brands b ON p.brand_id = b.brand_id
LEFT JOIN production.categories c ON p.category_id = c.category_id
ORDER BY p.product_name;

-- QUESTION 3 : Find all customers who have never placed an order. Return their name, city, and email.
SELECT 
    c.first_name,
    c.last_name,
    c.city,
    c.email
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.last_name;

-- QUESTION 4 : Calculate total revenue per store. Revenue = quantity * list_price * (1 - discount). Sort from highest to lowest.
SELECT 
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN sales.stores s ON o.store_id = s.store_id
GROUP BY s.store_name
ORDER BY total_revenue DESC;

-- QUESTION 5 : For each brand, show the number of products, the average list price, and the highest list price. Only include brands with more than 5 products.
SELECT 
    b.brand_name,
    COUNT(p.product_id) AS num_products,
    AVG(p.list_price) AS avg_price,
    MAX(p.list_price) AS max_price
FROM production.products p
JOIN production.brands b ON p.brand_id = b.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 5
ORDER BY num_products DESC;

-- QUESTION 6 :Show the number of orders and total revenue per month for the year 2017, ordered chronologically.
SELECT 
    MONTH(o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS num_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY MONTH(o.order_date)
ORDER BY order_month;

-- QUESTION 7 : Find all products priced above the average list price of their own category.
-- Hint: Use a correlated subquery.
SELECT 
    p.product_id,
    p.product_name,
    p.category_id,
    p.list_price
FROM production.products p
WHERE p.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p.category_id
)
ORDER BY p.category_id, p.list_price DESC;


-- QUESTION 8 : List the customers who have placed more orders than the average number of orders per customer.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(order_id) AS order_count
        FROM sales.orders
        GROUP BY customer_id
    ) AS sub
)
ORDER BY order_count DESC;

-- QUESTION 9: Using a CTE, calculate each customer's total spend, then return the top 10 customers with their spend and rank. Add a second CTE that labels each customer as "High" (above the overall average spend) or "Regular".
WITH customer_spend AS (
    SELECT 
        o.customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spend
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
),
ranked_spend AS (
    SELECT 
        customer_id,
        total_spend,
        RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
        CASE 
            WHEN total_spend > (SELECT AVG(total_spend) FROM customer_spend) THEN 'High'
            ELSE 'Regular'
        END AS spend_category
    FROM customer_spend
)
SELECT TOP 10
    c.first_name,
    c.last_name,
    r.total_spend,
    r.spend_rank,
    r.spend_category
FROM ranked_spend r
JOIN sales.customers c ON r.customer_id = c.customer_id
ORDER BY r.spend_rank;


-- QUESTION 10 : )  Using CTEs, find the best-selling product (by quantity) in each category, and show how much of that product's stock is currently available across all stores.
--  Hint: Use ROW_NUMBER() or RANK() partitioned by category, then join to production.stocks.
WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity) AS total_qty_sold
    FROM production.products p
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category_id
),
ranked_products AS (
    SELECT 
        product_id,
        product_name,
        category_id,
        total_qty_sold,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY total_qty_sold DESC) AS rn
    FROM product_sales
)
SELECT 
    c.category_name,
    rp.product_name,
    rp.total_qty_sold AS units_sold,
    SUM(st.quantity) AS total_stock_available
FROM ranked_products rp
JOIN production.categories c ON rp.category_id = c.category_id
LEFT JOIN production.stocks st ON rp.product_id = st.product_id
WHERE rp.rn = 1
GROUP BY c.category_name, rp.product_name, rp.total_qty_sold
ORDER BY c.category_name;


                                -- BONUS CHALLENGES
-- 1) •	Rewrite Q8 using a CTE instead of a subquery and compare readability.
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
    c.first_name, 
    c.last_name, 
    oc.order_count
FROM order_counts oc
JOIN sales.customers c ON oc.customer_id = c.customer_id
CROSS JOIN avg_orders a
WHERE oc.order_count > a.avg_count
ORDER BY oc.order_count DESC;

-- 2) •	For Q4, add a column showing each store's percentage share of total company revenue.
WITH store_revenue AS (
    SELECT 
        s.store_id,
        s.store_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN sales.stores s ON o.store_id = s.store_id
    GROUP BY s.store_id, s.store_name
)
SELECT 
    store_name,
    total_revenue,
    ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER (), 2) AS pct_of_total_revenue
FROM store_revenue
ORDER BY total_revenue DESC;