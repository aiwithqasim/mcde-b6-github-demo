--(Easy) List every order with the customer's full name, store name, and the full name of  staff member who thehandled it.

SELECT 
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    s.store_name,
    st.first_name + ' ' + st.last_name AS staff_name
FROM sales.orders o
JOIN sales.customers c ON o.customer_id = c.customer_id
JOIN sales.stores s ON o.store_id = s.store_id
JOIN sales.staffs st ON o.staff_id = st.staff_id;

--(Easy) Show each product with its brand name and category name. Include products even if they have no brand or category assigned.

SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products p
LEFT JOIN production.brands b ON p.brand_id = b.brand_id
LEFT JOIN production.categories c ON p.category_id = c.category_id;

--(Medium) Find all customers who have never placed an order. Return their name, city, and email.

SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    c.city,
    c.email
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--(Easy)  Calculate total revenue per store. Revenue = quantity * list_price * (1 - discount). Sort from highest to lowest.
 SELECT 
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN sales.stores s ON o.store_id = s.store_id
GROUP BY s.store_name
ORDER BY total_revenue DESC;

--5.  (Medium)  For each brand, show the number of products, the average list price, and the highest list price. Only include brands with more than 5 products.
SELECT 
    b.brand_name,
    COUNT(p.product_id) AS num_products,
    AVG(p.list_price) AS avg_list_price,
    MAX(p.list_price) AS max_list_price
FROM production.brands b
JOIN production.products p ON b.brand_id = p.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 5;

--(Medium)  Show the number of orders and total revenue per month for the year 2017, ordered chronologically.
SELECT 
    MONTH(o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS num_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY MONTH(o.order_date)
ORDER BY order_month;

--(Medium)  Find all products priced above the average list price of their own category.

SELECT 
    p.product_id,
    p.product_name,
    p.list_price,
    p.category_id
FROM production.products p
WHERE p.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p.category_id
);

--(Medium)  List the customers who have placed more orders than the average number of orders per customer.

SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_cnt)
    FROM (
        SELECT COUNT(order_id) AS order_cnt
        FROM sales.orders
        GROUP BY customer_id
    ) AS avg_orders
);

-- (Hard)  Using a CTE, calculate each customer's total spend, then return the top 10 customers with their spend and rank. Add a second CTE that labels each customer as "High" (above the overall average spend) or "Regular".

WITH customer_spend AS (
    SELECT 
        c.customer_id,
        c.first_name + ' ' + c.last_name AS customer_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spend
    FROM sales.customers c
    JOIN sales.orders o ON c.customer_id = o.customer_id
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
ranked_customers AS (
    SELECT 
        customer_id,
        customer_name,
        total_spend,
        RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
        CASE 
            WHEN total_spend > (SELECT AVG(total_spend) FROM customer_spend) 
            THEN 'High' 
            ELSE 'Regular' 
        END AS spend_label
    FROM customer_spend
)
SELECT 
    customer_id,
    customer_name,
    total_spend,
    spend_rank,
    spend_label
FROM ranked_customers
WHERE spend_rank <= 10
ORDER BY spend_rank;

--(Hard)  Using CTEs, find the best-selling product (by quantity) in each category, and show how much of that product's stock is currently available across all stores.
 
 WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category_id,
        c.category_name,
        SUM(oi.quantity) AS total_quantity_sold
    FROM production.products p
    JOIN production.categories c ON p.category_id = c.category_id
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category_id, c.category_name
),
ranked_products AS (
    SELECT 
        product_id,
        product_name,
        category_id,
        category_name,
        total_quantity_sold,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY total_quantity_sold DESC) AS rn
    FROM product_sales
)
SELECT 
    rp.category_name,
    rp.product_name,
    rp.total_quantity_sold,
    COALESCE(SUM(st.quantity), 0) AS total_stock_available
FROM ranked_products rp
LEFT JOIN production.stocks st ON rp.product_id = st.product_id
WHERE rp.rn = 1
GROUP BY rp.category_name, rp.product_name, rp.total_quantity_sold
ORDER BY rp.category_name;

--•using a CTE instead of a subquery and compare readability.

WITH customer_order_counts AS (
    SELECT 
        customer_id,
        COUNT(order_id) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
avg_orders AS (
    SELECT AVG(order_count * 1.0) AS avg_order_count
    FROM customer_order_counts
)
SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    coc.order_count
FROM sales.customers c
JOIN customer_order_counts coc ON c.customer_id = coc.customer_id
CROSS JOIN avg_orders ao
WHERE coc.order_count > ao.avg_order_count;

--• add a column showing each store's percentage share of total company revenue.
SELECT 
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
    CAST(
        100.0 * SUM(oi.quantity * oi.list_price * (1 - oi.discount)) 
        / SUM(SUM(oi.quantity * oi.list_price * (1 - oi.discount))) OVER () 
        AS DECIMAL(5,2)
    ) AS revenue_percentage
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN sales.stores s ON o.store_id = s.store_id
GROUP BY s.store_name
ORDER BY total_revenue DESC;













