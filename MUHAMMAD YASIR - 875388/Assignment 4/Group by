--Task 20: Count how many products exist in each category. Show category name and product count.

SELECT c.category_name, COUNT(p.product_id) AS total_products
FROM production.categories c
LEFT JOIN production.products p ON c.category_id = p.category_id
GROUP BY c.category_name;


--Task 21: Find the average list price of products per brand.

SELECT b.brand_name, AVG(p.list_price) AS avg_price
FROM production.brands b
JOIN production.products p ON b.brand_id = p.brand_id
GROUP BY b.brand_name;


--Task 22: For each store, count the total number of orders.

SELECT st.store_name, COUNT(o.order_id) AS total_orders
FROM sales.stores st
LEFT JOIN sales.orders o ON st.store_id = o.store_id
GROUP BY st.store_name;


--Task 23: Find the total revenue per order. Revenue = quantity × list_price × (1 - discount).

SELECT order_id, 
       SUM(quantity * list_price * (1 - discount)) AS total_revenue
FROM sales.order_items
GROUP BY order_id;


--Task 24: Find each customer's total number of orders. Sort by order count descending.

SELECT c.customer_id, 
       c.first_name + ' ' + c.last_name AS customer_name, 
       COUNT(o.order_id) AS order_count
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY order_count DESC;


--Task 25: Find the brand that has the highest average product price.

SELECT TOP 1 b.brand_name, AVG(p.list_price) AS avg_price
FROM production.brands b
JOIN production.products p ON b.brand_id = p.brand_id
GROUP BY b.brand_name
ORDER BY avg_price DESC;


--Task 26: List categories that have more than 50 products.

SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM production.categories c
JOIN production.products p ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) > 50;


--Task 27: For each store, find the total revenue generated across all orders.

SELECT st.store_name, 
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.stores st
JOIN sales.orders o ON st.store_id = o.store_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY st.store_name;


--Task 28: Find how many orders each staff member handled, and show only those who handled more than 50 orders.

SELECT s.staff_id, 
       s.first_name + ' ' + s.last_name AS staff_name, 
       COUNT(o.order_id) AS total_orders
FROM sales.staffs s
JOIN sales.orders o ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name
HAVING COUNT(o.order_id) > 50;
