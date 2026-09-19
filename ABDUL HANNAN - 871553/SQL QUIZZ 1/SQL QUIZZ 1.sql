 --JOINS

--1.  (Easy)  List every order with the customer's full name, store name, and the full name of the staff member who handled it.

use BikeStores;
go

SELECT
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customername,
    s.store_name AS storename,
    CONCAT(st.first_name, ' ', st.last_name) AS staffname
    FROM sales.orders o
INNER JOIN sales.customers c
ON o.customer_id = c.customer_id
INNER JOIN sales.stores s
ON o.store_id = s.store_id
INNER JOIN sales.staffs st
ON o.staff_id = st.staff_id;

--2.  (Easy)  Show each product with its brand name and category name. Include products even if they have no brand or category assigned.

SELECT
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products p
LEFT JOIN production.brands b
ON p.brand_id = b.brand_id
LEFT JOIN production.categories c
ON p.category_id = c.category_id;

--3.  (Medium)  Find all customers who have never placed an order. Return their name, city, and email.

SELECT
    c.first_name,
    c.last_name,
    c.city,
    c.email
FROM sales.customers c
LEFT JOIN sales.orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--GROUP BY

--4. (Easy) Calculate total revenue per store. Revenue = quantity * list_price * (1 - discount). Sort from highest to lowest.

SELECT
    s.store_id,
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
INNER JOIN sales.order_items oi
ON o.order_id = oi.order_id
INNER JOIN sales.stores s
    ON o.store_id = s.store_id
GROUP BY s.store_id, s.store_name
ORDER BY total_revenue DESC;

--5. (Medium) For each brand, show the number of products, the average list price, and the highest list price. Only include brands with more than 5 products.

SELECT
    b.brand_name,
    COUNT(p.product_id) AS product_count,
    AVG(p.list_price) AS avg_list_price,
    MAX(p.list_price) AS max_list_price
FROM production.products p
INNER JOIN production.brands b
ON p.brand_id = b.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 5
ORDER BY product_count DESC; --end



--6. (Medium) Show the number of orders and total revenue per month for the year 2017, ordered chronologically.

SELECT
    MONTH(o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
INNER JOIN sales.order_items oi
ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY MONTH(o.order_date)
ORDER BY order_month;

--SUB QUERIES

--7. (Medium) Find all products priced above the average list price of their own category.

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

--8. (Medium) List the customers who have placed more orders than the average number of orders per customer.

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers c
INNER JOIN sales.orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count) 
    FROM (
        SELECT COUNT(order_id) AS order_count
        FROM sales.orders
        GROUP BY customer_id
    ) AS customer_order_counts
)
ORDER BY order_count DESC;

--CTEs

--9. (Hard) Using a CTE, calculate each customer's total spend, then return the top 10 
--    customers with their spend and rank. Add a second CTE that labels each customer 
--    as "High" (above the overall average spend) or "Regular".
WITH customer_spend AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spend
    FROM sales.customers c
    INNER JOIN sales.orders o
        ON c.customer_id = o.customer_id
    INNER JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
spend_with_label AS (
    SELECT
        cs.customer_id,
        cs.first_name,
        cs.last_name,
        cs.total_spend,
        CASE
            WHEN cs.total_spend > AVG(cs.total_spend) OVER ()
                THEN 'High'
            ELSE 'Regular'
        END AS spend_label,
        RANK() OVER (ORDER BY cs.total_spend DESC) AS spend_rank
    FROM customer_spend cs
)
SELECT
    customer_id,
    first_name,
    last_name,
    total_spend,
    spend_label,
    spend_rank
FROM spend_with_label
ORDER BY spend_rank
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

--10. (Hard) Using CTEs, find the best-selling product (by quantity) in each category, 
--     and show how much of that product's stock is currently available across all stores.

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity) AS total_quantity_sold
    FROM production.products p
    INNER JOIN sales.order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category_id
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
        ) AS rn
    FROM product_sales ps
),
stock_totals AS (
    SELECT
        s.product_id,
        SUM(s.quantity) AS total_stock_available
    FROM production.stocks s
    GROUP BY s.product_id
)
SELECT
    c.category_name,
    rp.product_name,
    rp.total_quantity_sold,
    COALESCE(st.total_stock_available, 0) AS total_stock_available
FROM ranked_products rp
INNER JOIN production.categories c
    ON rp.category_id = c.category_id
LEFT JOIN stock_totals st
    ON rp.product_id = st.product_id
WHERE rp.rn = 1
ORDER BY rp.total_quantity_sold DESC;