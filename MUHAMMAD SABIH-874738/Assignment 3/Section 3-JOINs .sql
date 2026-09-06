--Section 3 — JOINs

--Task 12:  List every product along with its brand name and category name.
--Hint: JOIN production.products with production.brands and production.categories.
SELECT p.product_name,
b.brand_name,
c.category_name
FROM production.products AS p
JOIN production.brands AS b
ON p.brand_id = b.brand_id
JOIN production.categories AS c
ON p.category_id = c.category_id;

--Task 13:  List all orders with the customer's full name (first_name + last_name), order date, and order status.
SELECT c.first_name + ' ' + c.last_name AS full_name,
o.order_date,
o.order_status
FROM sales.customers AS c
JOIN sales.orders AS o
ON c.customer_id= o.customer_id;


SELECT*from sales.orders
SELECT*from production.categories
SELECT*from production.products

--Task 14:  Show every order item with the product name, quantity, list price, and discount.
--Task 15:  List each staff member's full name alongside their store name.
--Task 16:  List staff members along with their manager's full name.
--Hint: Use a self-join on the sales.staffs table using manager_id.
--Task 17:  Show all stores and the products they have in stock, including the product name and quantity. Only show items where quantity > 0.
--Task 18:  List all customers who placed at least one order. Show customer name and order date.
--Hint: An INNER JOIN naturally eliminates non-ordering customers.
--Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.
--Hint: Use a LEFT JOIN.