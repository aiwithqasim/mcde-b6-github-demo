Task 12:  List every product along with its brand name and category name.
Hint: JOIN production.products with production.brands and production.categories.
SELECT
    p.product_name,
    f.brand_name,
    c.category_name
FROM production.products p
JOIN production.brands f
    ON p.brand_id = f.brand_id
JOIN production.categories c
    ON p.category_id = c.category_id;

Task 13:  List all orders with the customer full name (first_name + last_name), order date, and order status


Task 14:  Show every order item with the productkname, quantity, list price, and discount
SELECT
    oi.order_id,
    p.product_name,
    oi.quantity,
    oi.list_price,
    oi.discount
FROM sales.order_items oi
JOIN production.products AS p
    ON oi.product_id = p.product_id;

Task 15:  List each staff member full name alongside their store name.
SELECT 
    s.first_name + s.last_name AS staff_name,
    st.store_name
FROM sales.staffs s
JOIN sales.stores st
    ON s.store_id = st.store_id;

Task 16:  List staff members along with their manager full name.
Hint: Use a self-join on the sales.staffs table using manager_id.
SELECT
    s.first_name + s.last_name AS staff_name,
    m.first_name + m.last_name AS manager_name
FROM sales.staffs s
LEFT JOIN sales.staffs m
    ON s.manager_id = m.staff_id;



Task 17:  Show all stores and the products they have in stock, including the product name and quantity. Only show items where quantity > 0.
SELECT
    st.store_name,
    p.product_name,
    sk.quantity
FROM production.stocks sk
JOIN sales.stores st
    ON sk.store_id = st.store_id
JOIN production.products p
    ON sk.product_id = p.product_id
WHERE sk.quantity > 0;

Task 18:  List all customers who placed at least one order. Show customer name and order date.
Hint: An INNER JOIN naturally eliminates non-ordering customers.
SELECT
    c.first_name + c.last_name AS customer_name,
    o.order_date
FROM sales.customers c
JOIN sales.orders o
    ON c.customer_id = o.customer_id;

Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.
Hint: Use a LEFT JOIN.
SELECT
    c.first_name + c.last_name AS customer_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM sales.customers c
LEFT JOIN sales.orders o
    ON c.customer_id = o.customer_id;
