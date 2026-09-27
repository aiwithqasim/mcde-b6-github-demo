--Joins

-- 1 (Easy)  List every order with the customer's full name, store name, and the full name of the staff member who handled it.

SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    s.store_name,
    st.first_name + ' ' + st.last_name AS staff_name,
    o.order_id,
    o.order_status
FROM sales.orders AS o
INNER JOIN sales.customers AS c 
    ON o.customer_id = c.customer_id
INNER JOIN sales.stores AS s 
    ON o.store_id = s.store_id
INNER JOIN sales.staffs AS st 
    ON o.staff_id = st.staff_id;


--2.(Easy)  Show each product with its brand name and category name. Include products even if they have no brand or category assigned.

SELECT 
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products AS p
LEFT JOIN production.brands AS b 
    ON p.brand_id = b.brand_id
LEFT JOIN production.categories AS c 
    ON p.category_id = c.category_id;
 


--3.(Medium)  Find all customers who have never placed an order. Return their name, city, and email.
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    c.city,
    c.email
FROM sales.customers AS c
LEFT JOIN sales.orders AS o 
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


--GROUP BY Tasks**


---4. (Easy)  Calculate total revenue per store. Revenue = quantity * list_price * (1 - discount). Sort from highest to lowest.
SELECT 
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.order_items AS oi
JOIN sales.orders AS o 
    ON oi.order_id = o.order_id
JOIN sales.stores AS s 
    ON o.store_id = s.store_id
GROUP BY s.store_name
ORDER BY total_revenue DESC;


--5  (Medium)  For each brand, show the number of products, the average list price, and the highest list price. Only include brands with more than 5 products.

SELECT 
    b.brand_name,
    COUNT(p.product_id) AS num_products,
    AVG(p.list_price) AS avg_price,
    MAX(p.list_price) AS max_price
FROM production.products AS p
JOIN production.brands AS b 
    ON p.brand_id = b.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 5;


--6 (Medium)  Show the number of orders and total revenue per month for the year 2017, ordered chronologically.

SELECT 
    YEAR(o.order_date) AS year,
    MONTH(o.order_date) AS month,
    COUNT(o.order_id) AS num_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders AS o
JOIN sales.order_items AS oi 
    ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
ORDER BY year, month;

--7 (Medium)  Find all products priced above the average list price of their own category.
--Hint: Use a correlated subquery.

SELECT 
    p.product_name,
    p.list_price,
    p.category_id
FROM production.products AS p
WHERE p.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products AS p2
    WHERE p2.category_id = p.category_id
    );

--8.  (Medium)  List the customers who have placed more orders than the average number of orders per customer.
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS num_orders
FROM sales.customers AS c
JOIN sales.orders AS o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(o2.order_id) AS order_count
        FROM sales.customers AS c2
        LEFT JOIN sales.orders AS o2 
            ON c2.customer_id = o2.customer_id
        GROUP BY c2.customer_id
    ) AS sub
);

--9.  (Hard)  Using a CTE, calculate each customer's total spend, then return the top 10 customers with their spend and rank. Add a second CTE that labels each customer as "High" (above the overall average spend) or "Regular".

WITH customer_spend AS (
    SELECT 
        c.customer_id,
        c.first_name + ' ' + c.last_name AS customer_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spend
    FROM sales.customers AS c
    JOIN sales.orders AS o 
        ON c.customer_id = o.customer_id
    JOIN sales.order_items AS oi 
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
avg_spend AS (
    SELECT AVG(total_spend) AS avg_spend
    FROM customer_spend
),
ranked_customers AS (
    SELECT 
        cs.customer_name,
        cs.total_spend,
        RANK() OVER (ORDER BY cs.total_spend DESC) AS spend_rank,
        CASE 
            WHEN cs.total_spend > (SELECT avg_spend FROM avg_spend) THEN 'High'
            ELSE 'Regular'
        END AS label
    FROM customer_spend AS cs
)
SELECT *
FROM ranked_customers
WHERE spend_rank <= 10;


--10.  (Hard)  Using CTEs, find the best-selling product (by quantity) in each category, and show how much of that product's stock is currently available across all stores.
--Hint: Use ROW_NUMBER() or RANK() partitioned by category, then join to production.stocks.

WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity) AS total_sold
    FROM production.products AS p
    JOIN sales.order_items AS oi 
        ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category_id
),
ranked_sales AS (
    SELECT 
        ps.*,
        RANK() OVER (PARTITION BY ps.category_id ORDER BY ps.total_sold DESC) AS rnk
    FROM product_sales AS ps
),
best_sellers AS (
    SELECT 
        product_id,
        product_name,
        category_id,
        total_sold
    FROM ranked_sales
    WHERE rnk = 1
)
SELECT 
    bs.category_id,
    bs.product_name,
    bs.total_sold,
    SUM(st.quantity) AS total_stock_available
FROM best_sellers AS bs
LEFT JOIN production.stocks AS st 
    ON bs.product_id = st.product_id
GROUP BY bs.category_id, bs.product_name, bs.total_sold;