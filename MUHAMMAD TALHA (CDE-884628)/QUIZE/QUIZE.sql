Name: MUHAMMAD TALHA
COURSE: (CDE-884628)
-----QUIZE----
Q(1)

SELECT
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    s.store_name,
    st.first_name + ' ' + st.last_name AS staff_name
FROM sales.orders o
join sales.customers c ON o.customer_id = c.customer_id
join sales.stores s ON o.store_id = s.store_id
join sales.staffs st ON o.staff_id = st.staff_id;

Q(2)
SELECT 
     p.product_name,
     b.brand_name,
     c.category_name
FROM production.products p
LEFT JOIN production.brands b ON p.brand_id = b.brand_id
LEFT JOIN production.categories c ON  p.category_id = c.category_id;
Q#3

SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    c.city,
    c.email
FROM sales.customers c
WHERE NOT EXISTS (
    SELECT 1 
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
);
   ---Q#4---
   SELECT 
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN sales.stores s ON o.store_id = s.store_id
GROUP BY s.store_name
----Q#5
SELECT 
    b.brand_name,
    COUNT(p.product_id) AS num_products,
    AVG(p.list_price) AS avg_price,
    MAX(p.list_price) AS max_price
FROM production.products p
JOIN production.brands b ON p.brand_id = b.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 5;
----Q#6---
SELECT 
    YEAR(o.order_date) AS year,
    MONTH(o.order_date) AS month,
    COUNT(o.order_id) AS num_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE YEAR(o.order_date) = 2017
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
ORDER BY year, month;
---Q#7----
SELECT 
    p.product_name,
    p.list_price,
    p.category_id
FROM production.products p
WHERE p.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p.category_id
);
---Q#8---
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS num_orders
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
);
---Q#9----
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
avg_spend AS (
    SELECT AVG(total_spend) AS avg_spend FROM customer_spend
),
ranked AS (
    SELECT 
        customer_name,
        total_spend,
        RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
    FROM customer_spend
)
SELECT 
    r.customer_name,
    r.total_spend,
    r.spend_rank,
    CASE 
        WHEN r.total_spend > (SELECT avg_spend FROM avg_spend) THEN 'High'
        ELSE 'Regular'
    END AS customer_type
FROM ranked r
WHERE r.spend_rank <= 10;
---Q#10---
WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity) AS total_sold
    FROM production.products p
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category_id
),
ranked AS (
    SELECT 
        category_id,
        product_id,
        product_name,
        total_sold,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY total_sold DESC) AS rn
    FROM product_sales
)
SELECT 
    r.category_id,
    r.product_name,
    r.total_sold,
    SUM(s.quantity) AS stock_available
FROM ranked r
JOIN production.stocks s ON r.product_id = s.product_id
WHERE r.rn = 1
GROUP BY r.category_id, r.product_name, r.total_sold;







