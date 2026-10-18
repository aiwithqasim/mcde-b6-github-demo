/* =====================================================================================================
SQL Practice Questions
BikeStores Dataset: Joins, GROUP BY, Subqueries & CTEs
=====================================================================================================*/

---														            	◇◇◇ JOINS ◇◇◇
-- 1.  (Easy)  List every order with the customer's full name, store name, and the full name of the staff member who handled it.
SELECT
	c.first_name + ' ' + c.last_name AS customer_name,
	s.first_name + ' ' + s.last_name AS staff_name,
	st.store_name
FROM sales.customers c
INNER JOIN sales.orders o
	ON c.customer_id = o.customer_id
INNER JOIN sales.staffs s
	ON o.staff_id = s.staff_id
INNER JOIN sales.stores st
	ON st.store_id = s.store_id;

-- 2.  (Easy)  Show each product with its brand name and category name. Include products even if they have no brand
-- or category assigned
SELECT 
	p.product_name,
	b.brand_name,
	c.category_name
FROM production.categories c
LEFT JOIN production.products p
	ON c.category_id = p.category_id
LEFT JOIN production.brands b
	ON p.brand_id = b.brand_id;

-- 3.  (Medium)  Find all customers who have never placed an order. Return their name, city, and email.
SELECT
	c.first_name + ' '  + c.last_name AS customer_name,
	c.city,
	c.email
FROM sales.customers c
LEFT JOIN sales.orders o
	ON c.customer_id = o.customer_id
WHERE o.order_status IS NULL;

-- 												                    ◇◇◇ GROUP BY ◇◇◇	
-- 4.  (Easy)  Calculate total revenue per store. Revenue = quantity * list_price * (1 - discount). Sort from highest to lowest.												◇◇◇ GROUP BY ◇◇◇
SELECT 
    s.store_name,
    SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_revenue
FROM sales.stores s
JOIN sales.orders o 
    ON s.store_id = o.store_id
JOIN sales.order_items i 
    ON o.order_id = i.order_id
GROUP BY 
    s.store_id, 
    s.store_name
ORDER BY 
    total_revenue DESC;

-- 5.  (Medium)  For each brand, show the number of products, the average list price, and the highest list price. 
-- Only include brands with more than 5 products.
SELECT
	b.brand_name,
	COUNT(p.product_name) AS total_products,
	AVG(p.list_price) AS avg_price,
	MAX(p.list_price) AS highest_price
FROM production.brands b
INNER JOIN production.products p
	ON b.brand_id = p.brand_id
GROUP BY b.brand_name 
HAVING COUNT(p.product_name) > 5;

-- 6.  (Medium)  Show the number of orders and total revenue per month for the year 2017, ordered chronologically.
SELECT 
    MONTH(o.order_date) AS month_number,
    DATENAME(MONTH, o.order_date) AS month_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.order_items i 
    ON o.order_id = i.order_id
WHERE 
    o.order_date >= '2017-01-01' 
    AND o.order_date < '2018-01-01'
GROUP BY 
    MONTH(o.order_date),
    DATENAME(MONTH, o.order_date)
ORDER BY 
    month_number ASC;
---											                				◇◇◇ SUB QUERIES ◇◇◇
-- 7.  (Medium)  Find all products priced above the average list price of their own category.
-- Hint: Use a correlated subquery.
SELECT 
    p1.product_id,
    p1.product_name,
    p1.category_id,
    p1.list_price
FROM production.products p1
WHERE p1.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p1.category_id
)
ORDER BY 
    p1.category_id, 
    p1.list_price DESC;

-- 8.  (Medium)  List the customers who have placed more orders than the average number of orders per
-- customer.
WITH customer_orders AS (
    SELECT 
        customer_id, 
        COUNT(order_id) AS total_orders
    FROM sales.orders
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    co.total_orders
FROM sales.customers c
JOIN customer_orders co 
    ON c.customer_id = co.customer_id
WHERE co.total_orders > (
    SELECT AVG(total_orders * 1.0)
    FROM customer_orders
)
ORDER BY 
    co.total_orders DESC;
---											                        		◇◇◇ CTEs ◇◇◇
/* 9.  (Hard)  Using a CTE, calculate each customer's total spend, then return the top 10 customers
with their spend and rank. Add a second CTE that labels each customer as "High" 
(above the overall average spend) or "Regular". */
WITH customer_spend AS (
    SELECT 
        o.customer_id,
        SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_spend
    FROM sales.orders o
    JOIN sales.order_items i 
        ON o.order_id = i.order_id
    GROUP BY 
        o.customer_id
),
customer_tier AS (
    SELECT 
        cs.customer_id,
        cs.total_spend,
        CASE 
            WHEN cs.total_spend > (SELECT AVG(total_spend) FROM customer_spend) THEN 'High'
            ELSE 'Regular'
        END AS customer_category,
        DENSE_RANK() OVER (ORDER BY cs.total_spend DESC) AS spend_rank
    FROM customer_spend cs
)
SELECT TOP 10
    c.customer_id,
    c.first_name,
    c.last_name,
    ct.total_spend,
    ct.spend_rank,
    ct.customer_category
FROM customer_tier ct
JOIN sales.customers c 
    ON ct.customer_id = c.customer_id
ORDER BY 
    ct.spend_rank ASC;

/* 10.  (Hard)  Using CTEs, find the best-selling product (by quantity) in each category, and show how
much of that product's stock is currently available across all stores.
Hint: Use ROW_NUMBER() or RANK() partitioned by category, then join to production.stocks. */
WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(i.quantity) AS total_quantity_sold
    FROM production.products p
    JOIN sales.order_items i 
        ON p.product_id = i.product_id
    GROUP BY 
        p.product_id,
        p.product_name,
        p.category_id
),
ranked_products AS (
    SELECT 
        ps.product_id,
        ps.product_name,
        ps.category_id,
        ps.total_quantity_sold,
        ROW_NUMBER() OVER (
            PARTITION BY ps.category_id 
            ORDER BY ps.total_quantity_sold DESC
        ) AS rnk
    FROM product_sales ps
),
product_stock AS (
    SELECT 
        product_id,
        SUM(quantity) AS current_stock
    FROM production.stocks
    GROUP BY product_id
)
SELECT 
    c.category_name,
    rp.product_name,
    rp.total_quantity_sold,
    ISNULL(ps.current_stock, 0) AS total_available_stock
FROM ranked_products rp
JOIN production.categories c 
    ON rp.category_id = c.category_id
LEFT JOIN product_stock ps 
    ON rp.product_id = ps.product_id
WHERE 
    rp.rnk = 1
ORDER BY 
    c.category_name;

---														                    	◇◇◇ BONUS CHALLENGES ◇◇◇
-- Bonus Challenge 1: Rewrite Q8 using CTE
WITH customer_orders AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(o.order_id) AS total_orders
    FROM sales.customers c
    JOIN sales.orders o 
        ON c.customer_id = o.customer_id
    GROUP BY 
        c.customer_id, 
        c.first_name, 
        c.last_name
)
SELECT 
    customer_id,
    first_name,
    last_name,
    total_orders
FROM customer_orders
WHERE total_orders > (
    SELECT AVG(total_orders * 1.0) 
    FROM customer_orders
)
ORDER BY 
    total_orders DESC;

-- Bonus Challenge 2: Customers with More Orders than Average (Subquery Solution)
WITH store_revenue AS (
    SELECT 
        s.store_id,
        s.store_name,
        SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_revenue
    FROM sales.stores s
    JOIN sales.orders o 
        ON s.store_id = o.store_id
    JOIN sales.order_items i 
        ON o.order_id = i.order_id
    GROUP BY 
        s.store_id, 
        s.store_name
)
SELECT 
    store_name,
    total_revenue,
    ROUND((total_revenue * 100.0 / SUM(total_revenue) OVER()), 2) AS revenue_percentage_share
FROM store_revenue
ORDER BY 
    total_revenue DESC;


