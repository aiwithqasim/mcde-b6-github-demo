---Task 12:  List every product along with its brand name and category name.
---Hint: JOIN production.products with production.brands and production.categories.
SELECT
p.product_name,
b.brand_name,
c.category_name
FROM production.products AS p
INNER JOIN production.brands AS b
ON b.brand_id = p.brand_id
INNER JOIN production.categories AS c
ON c.category_id = P.category_id; 


-----Task 13:  List all orders with the customer's full name (first_name + last_name), order date, and order status.
SELECT 
c.first_name + ' ' + c.last_name AS full_name,
o.order_date,
o.order_status
FROM sales.orders AS o
INNER JOIN sales.customers AS c
ON o.customer_id  = c.customer_id;


----Task 14:  Show every order item with the product name, quantity, list price, and discount.
SELECT 
p.product_name,
oi.quantity,
oi.list_price,
oi.discount
FROM sales.order_items AS oi
INNER JOIN production.products AS p
ON oi.product_id = p.product_id;


----Task 15:  List each staff member's full name alongside their store name.
SELECT
s.first_name + ' ' + last_name AS full_name,
store_name
FROM sales.staffs AS s
INNER JOIN sales.stores AS st
ON st.store_id = s.staff_id;



----Task 16:  List staff members along with their manager's full name.
----Hint: Use a self-join on the sales.staffs table using manager_id.
SELECT
m.first_name + '  ' + m.last_name AS manager, 
e.first_name + '  ' + e.last_name AS employee
FROM sales.staffs AS e
INNER JOIN sales.staffs AS m
ON e.manager_id = m.staff_id;


-----Task 17:  Show all stores and the products they have in stock,
-----including the product name and quantity. Only show items where quantity > 0.
SELECT
st.store_name,
p.product_name,
s.quantity
FROM production.products AS p
INNER JOIN production.stocks AS s
  ON s.product_id = p.product_id
INNER JOIN sales.stores AS st
ON st.store_id = s.store_id
WHERE s.quantity >0;

-----Task 18:  List all customers who placed at least one order. Show customer name and order date.
----Hint: An INNER JOIN naturally eliminates non-ordering customers.
SELECT
c.first_name,
o.order_date
FROM sales.customers AS c
INNER JOIN sales.orders AS o
ON o.customer_id = c.customer_id;


-----Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.
-----Hint: Use a LEFT JOIN.
SELECT
c.first_name,
o.order_date
FROM sales.customers AS c
LEFT JOIN sales.orders  AS o
ON o.customer_id = c.customer_id;