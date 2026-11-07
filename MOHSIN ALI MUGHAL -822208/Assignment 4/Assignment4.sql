-- Task 20
SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM production.categories AS c
INNER JOIN production.products AS p
    ON c.category_id = p.category_id
GROUP BY c.category_name;


-- Task 21
SELECT b.brand_name, AVG(p.list_price) AS average_price
FROM production.brands AS b
INNER JOIN production.products AS p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_name;


-- Task 22
SELECT s.store_name, COUNT(o.order_id) AS total_orders
FROM sales.stores AS s
INNER JOIN sales.orders AS o
    ON s.store_id = o.store_id
GROUP BY s.store_name;


-- Task 23
SELECT
    oi.order_id,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.order_items AS oi
GROUP BY oi.order_id;


-- Task 24
SELECT
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS order_count
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY order_count DESC;


-- Task 25
SELECT TOP 1
    b.brand_name,
    AVG(p.list_price) AS average_price
FROM production.brands AS b
INNER JOIN production.products AS p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_name
ORDER BY average_price DESC;


-- Task 26
SELECT
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM production.categories AS c
INNER JOIN production.products AS p
    ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) > 50;


-- Task 27
SELECT
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.stores AS s
INNER JOIN sales.orders AS o
    ON s.store_id = o.store_id
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY s.store_name;


-- Task 28
SELECT
    s.first_name + ' ' + s.last_name AS staff_name,
    COUNT(o.order_id) AS order_count
FROM sales.staffs AS s
INNER JOIN sales.orders AS o
    ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name
HAVING COUNT(o.order_id) > 50;