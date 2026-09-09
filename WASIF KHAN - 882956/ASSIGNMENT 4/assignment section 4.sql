                                                      
                                                                             (section no 4)

--task no 1
 
 SELECT 
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM production.products p
JOIN production.categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name;
 
--task no 2

SELECT 
    b.brand_name,
    AVG(p.list_price) AS average_price
FROM production.products p
JOIN production.brands b
    ON p.brand_id = b.brand_id
GROUP BY b.brand_name;

--task no 3

SELECT 
    s.store_name,
    COUNT(o.order_id) AS total_orders
FROM sales.orders o
JOIN sales.stores s
    ON o.store_id = s.store_id
GROUP BY s.store_name;

--task no 4

SELECT 
    order_id,
    SUM(quantity * list_price * (1 - discount)) AS total_revenue
FROM sales.order_items
GROUP BY order_id;

--task no 5

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
ORDER BY total_orders DESC;

--task no 5

SELECT TOP 1
    b.brand_name,
    AVG(p.list_price) AS average_price
FROM production.products p
JOIN production.brands b
    ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY average_price DESC;

--task no 6

SELECT 
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM production.products p
JOIN production.categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) > 50;

--task no 8

SELECT 
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.stores s
JOIN sales.orders o
    ON s.store_id = o.store_id
JOIN sales.order_items oi
    ON o.order_id = oi.order_id
GROUP BY s.store_name
ORDER BY total_revenue DESC;

--task no 9

SELECT
    s.staff_id,
    s.first_name,
    s.last_name,
    COUNT(o.order_id) AS total_orders
FROM sales.staffs s
JOIN sales.orders o
    ON s.staff_id = o.staff_id
GROUP BY
    s.staff_id,
    s.first_name,
    s.last_name
HAVING COUNT(o.order_id) > 50;
































































