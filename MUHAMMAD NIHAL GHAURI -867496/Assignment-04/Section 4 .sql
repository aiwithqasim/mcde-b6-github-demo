

--Section 4 — GROUP BY & Aggregates
--BikeStores Database



-- Task 20: Count how many products exist in each category.
SELECT
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM production.categories AS c
LEFT JOIN production.products AS p
    ON c.category_id = p.category_id
GROUP BY
    c.category_id,
    c.category_name
ORDER BY
    product_count DESC;

-- Task 21: Find the average list price of products per brand.
SELECT
    b.brand_name,
    AVG(p.list_price) AS average_price
FROM production.brands AS b
JOIN production.products AS p
    ON b.brand_id = p.brand_id
GROUP BY
    b.brand_id,
    b.brand_name
ORDER BY
    average_price DESC;

-- Task 22: For each store, count the total number of orders.
SELECT
    s.store_name,
    COUNT(o.order_id) AS total_orders
FROM sales.stores AS s
LEFT JOIN sales.orders AS o
    ON s.store_id = o.store_id
GROUP BY
    s.store_id,
    s.store_name
ORDER BY
    total_orders DESC;

-- Task 23: Find the total revenue per order.
-- Revenue = quantity * list_price * (1 - discount)
SELECT
    oi.order_id,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.order_items AS oi
GROUP BY
    oi.order_id
ORDER BY
    oi.order_id;

-- Task 24: Find each customer's total number of orders.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY
    total_orders DESC;

-- Task 25: Find the brand that has the highest average product price.
SELECT TOP 1
    b.brand_name,
    AVG(p.list_price) AS average_price
FROM production.brands AS b
JOIN production.products AS p
    ON b.brand_id = p.brand_id
GROUP BY
    b.brand_id,
    b.brand_name
ORDER BY
    average_price DESC;

-- Task 26: List categories that have more than 50 products.
SELECT
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM production.categories AS c
JOIN production.products AS p
    ON c.category_id = p.category_id
GROUP BY
    c.category_id,
    c.category_name
HAVING
    COUNT(p.product_id) > 50
ORDER BY
    product_count DESC;

-- Task 27: For each store, find the total revenue generated across all orders.
SELECT
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.stores AS s
JOIN sales.orders AS o
    ON s.store_id = o.store_id
JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    s.store_id,
    s.store_name
ORDER BY
    total_revenue DESC;

-- Task 28: Find how many orders each staff member handled,
-- and show only those who handled more than 50 orders.
SELECT
    s.staff_id,
    s.first_name,
    s.last_name,
    COUNT(o.order_id) AS total_orders
FROM sales.staffs AS s
JOIN sales.orders AS o
    ON s.staff_id = o.staff_id
GROUP BY
    s.staff_id,
    s.first_name,
    s.last_name
HAVING
    COUNT(o.order_id) > 50
ORDER BY
    total_orders DESC;
