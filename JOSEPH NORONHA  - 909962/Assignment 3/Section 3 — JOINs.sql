-- Task 12:  List every product along with its brand name and category name.
-- Hint: JOIN production.products with production.brands and production.categories.

SELECT p.product_name, b.brand_name, c.category_name
FROM production.products p
INNER JOIN production.brands b ON p.brand_id = b.brand_id
INNER JOIN production.categories c ON p.category_id = c.category_id;

-- Task 13:  List all orders with the customer's full name (first_name + last_name), order date, and order status.

SELECT o.order_id,
       c.first_name + ' ' + c.last_name AS customer_name,  -- MySQL: CONCAT(c.first_name, ' ', c.last_name)
       o.order_date,
       o.order_status
FROM sales.orders o
INNER JOIN sales.customers c ON o.customer_id = c.customer_id;

-- Task 14:  Show every order item with the product name, quantity, list price, and discount.

SELECT oi.order_id, p.product_name, oi.quantity, oi.list_price, oi.discount
FROM sales.order_items oi
INNER JOIN production.products p ON oi.product_id = p.product_id;

-- Task 15:  List each staff member's full name alongside their store name.

SELECT s.first_name + ' ' + s.last_name AS staff_name, 
       st.store_name
FROM sales.staffs s
INNER JOIN sales.stores st ON s.store_id = st.store_id;

-- Task 16:  List staff members along with their manager's full name.
-- Hint: Use a self-join on the sales.staffs table using manager_id.

SELECT e.first_name + ' ' + e.last_name AS staff_name,
       m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs e
INNER JOIN sales.staffs m ON e.manager_id = m.staff_id;

-- Task 17:  Show all stores and the products they have in stock, including the product name and quantity. Only show items where quantity > 0.

SELECT st.store_name, p.product_name, s.quantity
FROM production.stocks s
INNER JOIN sales.stores st ON s.store_id = st.store_id
INNER JOIN production.products p ON s.product_id = p.product_id
WHERE s.quantity > 0;

-- Task 18:  List all customers who placed at least one order. Show customer name and order date.
-- Hint: An INNER JOIN naturally eliminates non-ordering customers.

SELECT c.first_name + ' ' + c.last_name AS customer_name,
       o.order_date
FROM sales.customers c
INNER JOIN sales.orders o ON c.customer_id = o.customer_id;

-- OR

SELECT c.first_name + ' ' + c.last_name AS customer_name,
       STRING_AGG(CONVERT(VARCHAR(10), o.order_date, 120), ', ') AS order_dates
FROM sales.customers c
INNER JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.
-- Hint: Use a LEFT JOIN.

SELECT c.first_name + ' ' + c.last_name AS customer_name,
       o.order_id,
       o.order_date
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id;
