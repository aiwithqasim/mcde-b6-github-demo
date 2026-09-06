----SECTION;3 joins----

---Task 12:  List every product along with its brand name and category name.
SELECT
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products p
INNER JOIN production.brands b
    ON p.brand_id = b.brand_id
INNER JOIN production.categories c
    ON p.category_id = c.category_id;

    ---Task 13:  List all orders with the customer's full name (first_name + last_name), order date, and order status.
    SELECT
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    o.order_date,
    o.order_status
FROM sales.orders o
INNER JOIN sales.customers c
    ON o.customer_id = c.customer_id;

-----*Task 14: ** Show every order item with the product name, quantity, list price, and discount
SELECT
    p.product_name,
    oi.quantity,
    oi.list_price,
    oi.discount
FROM sales.order_items oi
INNER JOIN production.products p
    ON oi.product_id = p.product_id;

 ---Task 15:  List each staff member's full name alongside their store name.\
    SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS full_name,
    st.store_name
FROM sales.staffs s
INNER JOIN sales.stores st
    ON s.store_id = st.store_id;



 ----Task 16:  List staff members along with their manager's full name.
 SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name
FROM sales.staffs s
LEFT JOIN sales.staffs m
    ON s.manager_id = m.staff_id;

----Task 17:  Show all stores and the products they have in stock, including the product name and quantity. Only show items where quantity > 0.
SELECT
    st.store_name,
    p.product_name,
    s.quantity
FROM production.stocks s
INNER JOIN sales.stores st
    ON s.store_id = st.store_id
INNER JOIN production.products p
    ON s.product_id = p.product_id
WHERE s.quantity > 0;

---Task 18:  List all customers who placed at least one order. Show customer name and order date.
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_date
FROM sales.customers c
INNER JOIN sales.orders o
    ON c.customer_id = o.customer_id;
    
----Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM sales.customers c
LEFT JOIN sales.orders o
    ON c.customer_id = o.customer_id;
