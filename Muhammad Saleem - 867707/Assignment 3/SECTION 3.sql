

-- Section 3 — JOINs

--Task 12: Products with brand & category
SELECT p.product_id, p.product_name, b.brand_name, c.category_name
FROM production.products p
JOIN production.brands b ON p.brand_id = b.brand_id
JOIN production.categories c ON p.category_id = c.category_id;


--Task 13: Orders with customer name, date, status

SELECT o.order_id,
       CONCAT(c.first_name, ' ', c.last_name) AS full_name,
       o.order_date,
       o.order_status
FROM sales.orders o
JOIN sales.customers c ON o.customer_id = c.customer_id;


--Task 14: Order items with product details

SELECT oi.order_id, p.product_name, oi.quantity, oi.list_price, oi.discount
FROM sales.order_items oi
JOIN production.products p ON oi.product_id = p.product_id;


--Task 15: Staff with store name
SELECT CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
       st.store_name
FROM sales.staffs s
JOIN sales.stores st ON s.store_id = st.store_id;


--Task 16: Staff with manager’s name
SELECT CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
       CONCAT(m.first_name, ' ', m.last_name) AS manager_name
FROM sales.staffs s
LEFT JOIN sales.staffs m ON s.manager_id = m.staff_id;


--Task 17: Stores with products in stock

SELECT st.store_name, p.product_name, ps.quantity
FROM production.stocks ps
JOIN production.products p ON ps.product_id = p.product_id
JOIN sales.stores st ON ps.store_id = st.store_id
WHERE ps.quantity > 0;
  

--Task 18: Customers with at least one order
  
SELECT DISTINCT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       o.order_date
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id;
  

-- Task 19: All customers with orders 
  
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       o.order_id,
       o.order_date
FROM sales.customers c 
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id;
  

