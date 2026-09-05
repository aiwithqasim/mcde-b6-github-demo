USE BikeStores;

-- SECTION 3 - JOINS
-- 											✦✦✦ QUESTION 12 ✦✦✦
-- List every product along with its brand name and category name.
SELECT 
	p.product_name,
	b.brand_name,
	c.category_name
FROM production.products as p
INNER JOIN production.categories as c
ON p.category_id = c.category_id
INNER JOIN production.brands as b
ON p.brand_id = b.brand_id;

-- 											✦✦✦ QUESTION 13 ✦✦✦
-- List all orders with the customer's full name (first_name + last_name), order date, and order status.
SELECT 
	c.first_name + ' ' + c.last_name AS full_name,
	o.order_date,
	o.order_status
FROM sales.customers as c
INNER JOIN sales.orders as o
ON c.customer_id = o.customer_id;

-- 											✦✦✦ QUESTION 14 ✦✦✦
-- Show every order item with the product name, quantity, list price, and discount.
SELECT 
	p.product_name,
	oi.quantity,
	oi.list_price,
	oi.discount
FROM production.products AS p
INNER JOIN sales.order_items AS oi
ON p.product_id = oi.product_id;

-- 											✦✦✦ QUESTION 15 ✦✦✦
-- List each staff member's full name alongside their store name.
SELECT 
    s.first_name + ' ' + s.last_name AS full_name,
    st.store_name
FROM sales.staffs AS s
INNER JOIN sales.stores AS st
ON s.store_id = st.store_id;

-- 											✦✦✦ QUESTION 16 ✦✦✦
-- List staff members along with their manager's full name.(Hint use self join)
SELECT 
	mmbr.staff_id,
	mmbr.first_name,
	mmbr.last_name,
	CONCAT(mgr.first_name, ' ', mgr.last_name ) AS manager_name
FROM sales.staffs AS mmbr 
JOIN sales.staffs AS mgr
ON mmbr.manager_id = mgr.staff_id;

-- 											✦✦✦ QUESTION 17 ✦✦✦
-- Show all stores and the products they have in stock, including the product name and quantity.
-- Only show items where quantity > 0.
SELECT
	st.store_name,
	p.product_name,
	s.quantity
FROM production.products AS p
INNER JOIN production.stocks AS s
ON p.product_id = s.product_id
INNER JOIN sales.stores AS st
ON st.store_id = s.store_id
WHERE s.quantity > 0;

-- 											✦✦✦ QUESTION 18 ✦✦✦
-- List all customers who placed at least one order. Show customer name and order date.
SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	o.order_date
FROM sales.customers AS c
INNER JOIN sales.orders AS o
ON c.customer_id = o.customer_id;

-- 											✦✦✦ QUESTION 19 ✦✦✦
-- List ALL customers and their orders (if any). Customers who never ordered should still
-- appear with NULL order data.
SELECT
	c.customer_id,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	o.order_status,
	o.order_id,
	o.order_date
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
ON c.customer_id = o.customer_id
ORDER BY o.order_status;