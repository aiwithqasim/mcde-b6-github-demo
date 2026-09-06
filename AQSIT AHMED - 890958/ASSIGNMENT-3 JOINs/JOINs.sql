-- SECTION 3 JOINS
--TASK 12
--List every product along with its brand name and category name.

SELECT
     p.product_id,
     p.product_name,
     b.brand_name,
     c.category_name
FROM production.products as p
LEFT JOIN  production.brands as b
ON p.brand_id = b.brand_id
LEFT JOIN production.categories as c
ON p.category_id = c.category_id;

--TASK 13
--List all orders with the customer's full name (first_name + last_name), order date, and order status.

SELECT
    c.first_name,
    c.last_name,
    o.order_status,
    o.order_date
FROM sales.customers as c
RIGHT JOIN sales.orders as o
ON c.customer_id = o.customer_id;

--TASK 14
--Show every order item with the product name, quantity, list price, and discount.

SELECT
    p.product_name,
    o.quantity,
    o.list_price,
    o.discount,
    o.order_id
FROM production.products as p
RIGHT JOIN sales.order_items as o
ON p.product_id = o.product_id;

--TASK 15
--List each staff member's full name alongside their store name.

SELECT
     s.staff_id,
     s.first_name,
     s.last_name,
    st.store_name,
    st.store_id
FROM sales.staffs as s
LEFT JOIN sales.stores as st
ON s.store_id = st.store_id;

--TASK 16
--List staff members along with their manager's full name.

SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS staff_full_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_full_name
FROM  sales.staffs as s
LEFT JOIN sales.staffs as m 
ON s.manager_id = m.staff_id;

--TASK 17
--Show all stores and the products they have in stock, including the product name and quantity. Only show items where quantity >0.

SELECT
    p.product_name,
    p.product_id,
    s.quantity,
   st.store_id,
   st.store_name
FROM production.products as p
RIGHT JOIN production.stocks as s
ON p.product_id = s. product_id
RIGHT JOIN sales.stores as st
ON s.store_id = st.store_id
WHERE s.quantity >0;

--TASK 18
--List all customers who placed at least one order. Show customer name and order date.

SELECT
     c.customer_id,
     c.first_name,
     c.last_name,
     o.order_date,
     o.order_id
FROM sales.customers as c
INNER JOIN sales.orders as o
ON c.customer_id = o.customer_id;

--TASK 19
--List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.

SELECT
     c.customer_id,
     c.first_name,
     c.last_name,
     o.order_id
FROM sales.customers As c
LEFT JOIN sales.orders as o
ON c.customer_id = o.customer_id;