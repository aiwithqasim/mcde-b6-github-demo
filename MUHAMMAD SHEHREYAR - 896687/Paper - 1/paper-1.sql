--JOINS TASK'S
--TASK 1
SELECT
o.order_id,
c.first_name +' ' + c.last_name AS full_name,
s.store_name,
st.first_name + ' ' + st.last_name AS staff_name
FROM sales.orders AS o
INNER JOIN sales.customers AS c
	on o.customer_id = c.customer_id 
INNER JOIN sales.stores AS s
	on o.store_id = s.store_id
INNER JOIN sales.staffs AS st
	on o.staff_id = st.staff_id
ORDER BY order_id ;

--TASK 2
SELECT 
	p.product_name,
	b.brand_name,
	c.category_name
FROM production.products AS p
LEFT JOIN production.brands AS b
	ON p.brand_id = b.brand_id
LEFT JOIN production.categories AS c
	ON p.category_id = c.category_id


--TASK 3
SELECT
	c.first_name,
	c.city,
	c.email
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
	on c.customer_id = o.customer_id


--GROUP BY QUESTIONS
--TASK 4
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


--TASK 5
SELECT 
    b.brand_name,
    COUNT(p.product_id) AS total_products,
    AVG(p.list_price) AS avg_price,
    MAX(p.list_price) AS max_price
FROM production.brands AS b
INNER JOIN production.products AS p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 5;


--TASK 6
SELECT 
    MONTH(o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY MONTH(o.order_date)
ORDER BY order_month ASC;


--Subqueries QUESTIONS
--TASK 7
SELECT 
    p1.product_id,
    p1.product_name,
    p1.category_id,
    p1.list_price
FROM production.products AS p1
WHERE p1.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products AS p2
    WHERE p2.category_id = p1.category_id
);


--TASK 8
SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS total_orders
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count * 1.0)
    FROM (
        SELECT COUNT(order_id) AS order_count
        FROM sales.orders
        GROUP BY customer_id
    ) AS customer_order_counts
);


--CTEs QUESTIONS
--TASK 9
WITH CustomerSpend AS (
    SELECT 
        c.customer_id,
        c.first_name + ' ' + c.last_name AS customer_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spend
    FROM sales.customers AS c
    INNER JOIN sales.orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
SpendWithCategory AS (
    SELECT 
        customer_id,
        customer_name,
        total_spend,
        DENSE_RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
        CASE 
            WHEN total_spend > (SELECT AVG(total_spend) FROM CustomerSpend) THEN 'High'
            ELSE 'Regular'
        END AS customer_tag
    FROM CustomerSpend
)
SELECT TOP 10 
    customer_id,
    customer_name,
    total_spend,
    spend_rank,
    customer_tag
FROM SpendWithCategory
ORDER BY spend_rank;


--TASK 10
WITH ProductSales AS (
    SELECT 
        p.category_id,
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS total_sold
    FROM production.products AS p
    INNER JOIN sales.order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY p.category_id, p.product_id, p.product_name
),
RankedProducts AS (
    SELECT 
        category_id,
        product_id,
        product_name,
        total_sold,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY total_sold DESC) AS rank_num
    FROM ProductSales
),
ProductStock AS (
    SELECT 
        product_id,
        SUM(quantity) AS total_stock
    FROM production.stocks
    GROUP BY product_id
)
SELECT 
    cat.category_name,
    rp.product_name,
    rp.total_sold,
    ISNULL(ps.total_stock, 0) AS current_stock
FROM RankedProducts AS rp
INNER JOIN production.categories AS cat
    ON rp.category_id = cat.category_id
LEFT JOIN ProductStock AS ps
    ON rp.product_id = ps.product_id
WHERE rp.rank_num = 1;