

-- JOIN Part is completed ---

-- Task 1 is completed --

SELECT 
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    st.store_name,
    s.first_name + ' ' + s.last_name AS staff_name
FROM sales.orders o
JOIN sales.customers c ON o.customer_id = c.customer_id
JOIN sales.stores st ON o.store_id = st.store_id
JOIN sales.staffs s ON o.staff_id = s.staff_id;


-- Task 2 is completed --

SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    cat.category_name
FROM production.products p
LEFT JOIN production.brands b ON p.brand_id = b.brand_id
LEFT JOIN production.categories cat ON p.category_id = cat.category_id;


-- Task 3 is completed --

SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    c.city,
    c.email
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-----x------------x---------------x-------------------x-------------------------------------------


-- GROUP By Part is Completed --

-- Task 4 is completed --

SELECT 
    st.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.stores st
JOIN sales.orders o ON st.store_id = o.store_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY st.store_name
ORDER BY total_revenue DESC;


-- Task 5 is completed --

SELECT 
    b.brand_name,
    COUNT(p.product_id) AS total_products,
    AVG(p.list_price) AS avg_list_price,
    MAX(p.list_price) AS max_list_price
FROM production.brands b
JOIN production.products p ON b.brand_id = p.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 5;


-- Task 6 is completed --

SELECT 
    EXTRACT(MONTH FROM o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.order_date >= '2017-01-01' AND o.order_date < '2018-01-01'
GROUP BY EXTRACT(MONTH FROM o.order_date)
ORDER BY order_month ASC;

---------------------x----------------------------x-----------------------------x---------------------


-- SUBQUERIES Part is completed --

-- Task 7 is completed --

SELECT 
    p.product_id,
    p.product_name,
    p.category_id,
    p.list_price
FROM production.products p
WHERE p.list_price > (
    SELECT AVG(sub.list_price)
    FROM production.products sub
    WHERE sub.category_id = p.category_id
);


-- Task 8 is completed --

SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT COUNT(order_id) * 1.0 / COUNT(DISTINCT customer_id)
    FROM sales.orders
);

-----------x--------------------x----------------------x--------------------------


-- CTEs Part is completed --

-- Task 9 is completed --

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
categorized_customers AS (
    SELECT 
        customer_id,
        customer_name,
        total_spend,
        DENSE_RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
        CASE 
            WHEN total_spend > (SELECT AVG(total_spend) FROM customer_spend) THEN 'High'
            ELSE 'Regular'
        END AS customer_tier
    FROM customer_spend
)
SELECT 
    customer_id,
    customer_name,
    total_spend,
    spend_rank,
    customer_tier
FROM categorized_customers
WHERE spend_rank <= 10
ORDER BY spend_rank;

------------------------------------------------------

-- Task 10 is completed --

WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category_id,
        cat.category_name,
        SUM(oi.quantity) AS total_quantity_sold
    FROM production.products p
    JOIN production.categories cat ON p.category_id = cat.category_id
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category_id, cat.category_name
),
ranked_products AS (
    SELECT 
        product_id,
        product_name,
        category_name,
        total_quantity_sold,
        ROW_NUMBER() OVER (
            PARTITION BY category_id 
            ORDER BY total_quantity_sold DESC
        ) AS rn
    FROM product_sales
),
stock_totals AS (
    SELECT 
        product_id,
        SUM(quantity) AS current_stock
    FROM production.stocks
    GROUP BY product_id
)
SELECT 
    rp.category_name,
    rp.product_name,
    rp.total_quantity_sold,
    COALESCE(st.current_stock, 0) AS total_stock_available
FROM ranked_products rp
LEFT JOIN stock_totals st ON rp.product_id = st.product_id
WHERE rp.rn = 1;

