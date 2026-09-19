
---Quiz NO 1
------- Joins--------


--1.  (Easy)  List every order with the customer's full name, store name, 
--and the full name of the staff member who handled it.


 SELECT
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    s.store_name,
    st.first_name + ' ' + st.last_name AS staff_name
FROM sales.orders o
INNER JOIN sales.customers c
    ON o.customer_id = c.customer_id
INNER JOIN sales.stores s
    ON o.store_id = s.store_id
INNER JOIN sales.staffs st
    ON o.staff_id = st.staff_id;


----2.  (Easy)  Show each product with its brand name and category name. 
---Include products even if they have no brand or category assigned.
-- Q2: Show every product with brand and category

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


-- Q3: Customers who have never placed an order

SELECT
    c.first_name + ' ' + c.last_name AS customer_name,
    c.city,
    c.email
FROM sales.customers c
LEFT JOIN sales.orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;



----GROUP BY
-- Q4: Total revenue per store

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
ORDER BY total_revenue DESC;



-- Q5: Brand product count, average price and highest price

SELECT
    b.brand_id,
    b.brand_name,
    COUNT(p.product_id) AS product_count,
    AVG(p.list_price) AS average_list_price,
    MAX(p.list_price) AS highest_list_price
FROM production.brands b
INNER JOIN production.products p
    ON b.brand_id = p.brand_id
GROUP BY
    b.brand_id,
    b.brand_name
HAVING COUNT(p.product_id) > 5
ORDER BY product_count DESC;




-- Q6: Orders and revenue per month for 2017

SELECT
    MONTH(o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
INNER JOIN sales.order_items oi
    ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY
    MONTH(o.order_date)
ORDER BY
    order_month;



    -- Q7: Products priced above the average price of their own category

SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    p.list_price
FROM production.products p
WHERE p.list_price >
(
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p.category_id
);



-- Q8: Customers who placed more orders than the average number of orders per customer

SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers c
INNER JOIN sales.orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING COUNT(o.order_id) >
(
    SELECT AVG(order_count * 1.0)
    FROM
    (
        SELECT
            customer_id,
            COUNT(order_id) AS order_count
        FROM sales.orders
        GROUP BY customer_id
    ) AS customer_orders
)
ORDER BY order_count DESC;





-- Q9: Top 10 customers by total spend with rank and spending label

WITH CustomerSpend AS
(
    SELECT
        c.customer_id,
        c.first_name + ' ' + c.last_name AS customer_name,
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
CustomerLabels AS
(
    SELECT
        customer_id,
        customer_name,
        total_spend,
        CASE
            WHEN total_spend >
            (
                SELECT AVG(total_spend * 1.0)
                FROM CustomerSpend
            )
            THEN 'High'
            ELSE 'Regular'
        END AS spending_level
    FROM CustomerSpend
)
SELECT TOP 10
    customer_id,
    customer_name,
    total_spend,
    RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
    spending_level
FROM CustomerLabels
ORDER BY total_spend DESC;





-- Q10: Best-selling product in each category and its total stock

WITH ProductSales AS
(
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
RankedProducts AS
(
    SELECT
        product_id,
        product_name,
        category_id,
        total_quantity,
        ROW_NUMBER() OVER
        (
            PARTITION BY category_id
            ORDER BY total_quantity DESC
        ) AS product_rank
    FROM ProductSales
),
ProductStock AS
(
    SELECT
        product_id,
        SUM(quantity) AS total_stock
    FROM production.stocks
    GROUP BY product_id
)
SELECT
    c.category_name,
    rp.product_id,
    rp.product_name,
    rp.total_quantity AS quantity_sold,
    ISNULL(ps.total_stock, 0) AS total_stock
FROM RankedProducts rp
INNER JOIN production.categories c
    ON rp.category_id = c.category_id
LEFT JOIN ProductStock ps
    ON rp.product_id = ps.product_id
WHERE rp.product_rank = 1
ORDER BY c.category_name;