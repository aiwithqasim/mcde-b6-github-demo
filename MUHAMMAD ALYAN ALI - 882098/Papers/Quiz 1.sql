

--CLASS QUIZ------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------
--Joins
----------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------

--1.  (Easy)  List every order with the customer's full name, store name, and the full name of the staff member who handled it.


SELECT
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    s.store_name,
    st.first_name + ' ' + st.last_name AS staff_name
FROM sales.orders AS o
INNER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN sales.stores AS s
    ON o.store_id = s.store_id
INNER JOIN sales.staffs AS st
    ON o.staff_id = st.staff_id;

---------------------------------------------------------------------------------------------------------------------

--2.Show each product with its brand name and category name. Include products even if they have no brand or category assigned.

SELECT
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products AS p
LEFT JOIN production.brands AS b
    ON p.brand_id = b.brand_id
LEFT JOIN production.categories AS c
    ON p.category_id = c.category_id;


----------------------------------------------------------------------------------------------------------------------

--3.  (Medium)  Find all customers who have never placed an order. Return their name, city, and email.


    SELECT
    c.first_name + ' ' + c.last_name AS customer_name,
    c.city,
    c.email
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;


----------------------------------------------------------------------------------------------------------------------
--GROUP BY
-----------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------

--4.  (Easy)  Calculate total revenue per store. Revenue = quantity * list_price * (1 - discount). Sort from highest to lowest.



SELECT
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.stores AS s
INNER JOIN sales.orders AS o
    ON s.store_id = o.store_id
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY s.store_name
ORDER BY total_revenue DESC;


-------------------------------------------------------------------------------------------------------------------------


--5.  (Medium)  For each brand, show the number of products, the average list price, and the highest list price. Only include brands with more than 5 products.


SELECT
    b.brand_name,
    COUNT(p.product_id) AS product_count,
    AVG(p.list_price) AS average_price,
    MAX(p.list_price) AS highest_price
FROM production.brands AS b
INNER JOIN production.products AS p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 5;

-------------------------------------------------------------------------------------------------------------------------

--6.  (Medium)  Show the number of orders and total revenue per month for the year 2017, ordered chronologically.

SELECT
    MONTH(o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY MONTH(o.order_date)
ORDER BY order_month;


-------------------------------------------------------------------------------------------------------------------------
--Subqueries
----------------------------------------------------------------------------------------------------------------------


--7.  (Medium)  Find all products priced above the average list price of their own category.
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

-------------------------------------------------------------------------------------------------------------------------

--8.  (Medium)  List the customers who have placed more orders than the average number of orders per customer.


SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count * 1.0)
    FROM (
        SELECT customer_id, COUNT(*) AS order_count
        FROM sales.orders
        GROUP BY customer_id
    ) AS customer_orders
);


-------------------------------------------------------------------------------------------------------------------------
--CTEs
----------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------

--9.  (Hard)  Using a CTE, calculate each customer's total spend, then return the top 10 customers with their spend and rank. Add a second CTE that labels each customer as "High" (above the overall average spend) or "Regular".


WITH customer_spend AS (
    SELECT
        c.customer_id,
        c.first_name + ' ' + c.last_name AS customer_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spend
    FROM sales.customers AS c
    INNER JOIN sales.orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
),
customer_labels AS (
    SELECT
        customer_id,
        customer_name,
        total_spend,
        CASE
            WHEN total_spend > (SELECT AVG(total_spend) FROM customer_spend)
                THEN 'High'
            ELSE 'Regular'
        END AS spend_label
    FROM customer_spend
),
ranked_customers AS (
    SELECT
        *,
        RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
    FROM customer_labels
)
SELECT TOP 10
    customer_name,
    total_spend,
    spend_rank,
    spend_label
FROM ranked_customers
ORDER BY spend_rank;

--------------------------------------------------------------------------------------------------------------------

--10.  (Hard)  Using CTEs, find the best-selling product (by quantity) in each category, and show how much of that product's stock is currently available across all stores.
--Hint: Use ROW_NUMBER() or RANK() partitioned by category, then join to production.stocks.

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity) AS total_quantity
    FROM production.products AS p
    INNER JOIN sales.order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category_id
),
ranked_products AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY category_id
            ORDER BY total_quantity DESC
        ) AS rn
    FROM product_sales
),
stock_totals AS (
    SELECT
        product_id,
        SUM(quantity) AS total_stock
    FROM production.stocks
    GROUP BY product_id
)
SELECT
    c.category_name,
    rp.product_name,
    rp.total_quantity,
    ISNULL(st.total_stock, 0) AS total_stock
FROM ranked_products AS rp
INNER JOIN production.categories AS c
    ON rp.category_id = c.category_id
LEFT JOIN stock_totals AS st
    ON rp.product_id = st.product_id
WHERE rp.rn = 1
ORDER BY c.category_name;