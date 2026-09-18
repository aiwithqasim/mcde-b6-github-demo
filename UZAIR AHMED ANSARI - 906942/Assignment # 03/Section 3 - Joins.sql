--SECTION 3 ---------- JOINS ----------

--Task 12: List every product along with its brand name and category name? Hint: JOIN production.products with production.brands and production.categories
SELECT 
	p.product_name,
	b.brand_name,
	c.category_name

FROM production.products AS p
JOIN production.brands AS b
	ON p.brand_id = b.brand_id

JOIN production.categories AS c
	ON p.category_id = c.category_id;

--Task 13:  List all orders with the customer's full name (first_name + last_name), order date, and order status?
SELECT
	o.order_id,
	CONCAT (c.first_name, '  ', c.last_name) AS full_name,
	o.order_date,
	o.order_status

FROM sales.orders AS o
JOIN sales.customers as c
	ON c.customer_id = o.customer_id;

--Task 14:  Show every order item with the product name, quantity, list price, and discount?
SELECT
	p.product_name,
	oi.list_price,
	oi.quantity,
	oi.discount

FROM sales.order_items AS oi
JOIN production.products AS p
	ON oi.product_id = p.product_id;
	 
--Task 15:  List each staff member's full name alongside their store name?
SELECT
	CONCAT (s.first_name, '  ', s.last_name) AS full_name,
	st.store_name

FROM sales.staffs AS s
LEFT JOIN sales.stores AS st
	ON s.store_id = st.store_id;

--Task 16:  List staff members along with their manager's full name. Hint: Use a self-join on the sales.staffs table using manager_id?
SELECT
	CONCAT (s.first_name, '  ', s.last_name) AS staff_name,
	CONCAT (m.first_name, '  ', m.last_name) AS manager_name

FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
	ON s.manager_id = m.staff_id;

--Task 17:  Show all stores and the products they have in stock, including the product name and quantity. Only show items where quantity > 0.
SELECT
	s.store_name,
	p.product_name,
	st.quantity

FROM sales.stores AS s
LEFT JOIN production.stocks AS st
			ON s.store_id = st.store_id
JOIN production.products AS p
			ON st.product_id = p.product_id
		WHERE quantity > 0;

--Task 18:  List all customers who placed at least one order. Show customer name and order date? Hint: An INNER JOIN naturally eliminates non-ordering customers.
SELECT
	CONCAT (c.first_name, '  ', c.last_name) AS customer_name,
	o.order_date

FROM sales.customers AS C
INNER JOIN sales.orders AS O
	ON c.customer_id = o.customer_id;

--Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data. Hint: Use a LEFT JOIN.
SELECT
	CONCAT (c.first_name, '  ', c.last_name) AS customer_name,
	o.order_date

FROM sales.customers AS c
LEFT JOIN sales.orders AS o
	ON c.customer_id = o.customer_id;










