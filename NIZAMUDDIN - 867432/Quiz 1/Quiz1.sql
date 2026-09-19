-- Joins

-- Q1:

SELECT 
	o.order_id,
	c.first_name + ' ' + c.last_name as full_name,
	st.store_name,
	s.first_name + ' ' + s.last_name as staff_name
FROM sales.customers c 
INNER JOIN sales.orders o 
ON c.customer_id = o.customer_id 
INNER JOIN sales.stores st
ON o.store_id = st.store_id 
INNER JOIN sales.staffs s 
ON o.staff_id = s.staff_id 

-- Q2

SELECT 
	p.product_name,
	b.brand_name,
	c.category_name
FROM production.products p 
INNER JOIN production.brands b 
ON p.brand_id = b.brand_id 
INNER JOIN production.categories c 
ON p.category_id = c.category_id 
	
-- Q3

SELECT 
	c.first_name + ' ' + c.last_name as full_name,
	c.city,
	c.email 
FROM sales.customers c 
LEFT JOIN sales.orders o
ON c.customer_id = o.customer_id 
WHERE o.customer_id is NULL

-- GROUP BY 

-- Q4

SELECT 
	s.store_name,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
FROM sales.order_items oi 
INNER JOIN sales.orders o 
ON oi.order_id = o.order_id
INNER JOIN sales.stores s 
ON o.store_id = s.store_id 
GROUP BY
s.store_id,
s.store_name
ORDER BY
total_revenue DESC
	
-- Q5

SELECT 
	b.brand_name,
	COUNT(p.product_id) as number_of_products,
	AVG(p.list_price) as avg_list_price,
	MAX(p.list_price) as max_list_price
FROM production.products p 
INNER JOIN production.brands b 
ON p.brand_id = b.brand_id 
GROUP BY b.brand_name 
HAVING COUNT(p.product_id) > 5

-- Q6

SELECT 
    MONTH(o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS number_of_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
INNER JOIN sales.order_items oi
    ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY MONTH(o.order_date)
ORDER BY MONTH(o.order_date);

-- Q7

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
);

-- Q8

SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS full_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers c
INNER JOIN sales.orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count * 1.0)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM sales.orders
        GROUP BY customer_id
    ) AS customer_orders
);

-- Q9

WITH customer_spend AS (
    SELECT
        c.customer_id,
        c.first_name + ' ' + c.last_name AS full_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spend
    FROM sales.customers c
    INNER JOIN sales.orders o
        ON c.customer_id = o.customer_id
    INNER JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
),
customer_label AS (
    SELECT
        customer_id,
        full_name,
        total_spend,
        CASE
            WHEN total_spend > (SELECT AVG(total_spend * 1.0) FROM customer_spend)
                THEN 'High'
            ELSE 'Regular'
        END AS customer_type
    FROM customer_spend
)
SELECT TOP 10
    customer_id,
    full_name,
    total_spend,
    customer_type,
    RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
FROM customer_label
ORDER BY total_spend DESC;

-- Q10

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity) AS total_quantity
    FROM production.products p
    INNER JOIN sales.order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category_id
),
ranked_products AS (
    SELECT
        product_id,
        product_name,
        category_id,
        total_quantity,
        ROW_NUMBER() OVER (
            PARTITION BY category_id
            ORDER BY total_quantity DESC
        ) AS product_rank
    FROM product_sales
),
category_best AS (
    SELECT
        product_id,
        product_name,
        category_id,
        total_quantity
    FROM ranked_products
    WHERE product_rank = 1
)
SELECT
    cb.category_id,
    cb.product_name,
    cb.total_quantity,
    SUM(s.quantity) AS available_stock
FROM category_best cb
INNER JOIN production.stocks s
    ON cb.product_id = s.product_id
GROUP BY
    cb.category_id,
    cb.product_name,
    cb.total_quantity;



------ Bonus Questions -------------

-- Q

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
average_orders AS (
    SELECT AVG(order_count * 1.0) AS avg_order_count
    FROM customer_orders
)
SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS full_name,
    co.order_count
FROM customer_orders co
INNER JOIN sales.customers c
    ON co.customer_id = c.customer_id
CROSS JOIN average_orders ao
WHERE co.order_count > ao.avg_order_count;

-- Q

WITH store_revenue AS (
    SELECT
        s.store_id,
        s.store_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.stores s
    INNER JOIN sales.orders o
        ON s.store_id = o.store_id
    INNER JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        s.store_id,
        s.store_name
)
SELECT
    store_name,
    total_revenue,
    total_revenue * 100.0 / SUM(total_revenue) OVER () AS revenue_share_percentage
FROM store_revenue
ORDER BY total_revenue DESC;





	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	