---Task 12:  List every product along with its brand name and category name.
SELECT 
      p.product_name,
      b.brand_name,
      c.category_name
FROM production.products AS p 
JOIN production.brands AS b 
ON p.brand_id = b.brand_id
join production.categories AS c
ON p.category_id = c.category_id ;

---Task 13:  List all orders with the customer's full name (first_name + last_name), order date, and order status.
SELECT 
     c.first_name + ' ' +c.last_name AS full_name,
     o.order_date,
      o.order_status
FROM 
     sales.orders AS o
JOIN sales.customers AS c
on o.customer_id = c.customer_id ;

---Task 14:  Show every order item with the product name, quantity, list price, and discount.
SELECT 
      oi.quantity,
      p.product_name,
      oi.discount,
      oi.list_price
FROM sales.order_items AS oi
INNER JOIN production.products AS p
ON p.product_id = oi.product_id ;   

---Task 15:  List each staff member's full name alongside their store name.
SELECT 
       st.staff_id,
       s.store_name,
       st.first_name + ' ' + st.last_name AS full_name
FROM sales.staffs AS st
INNER JOIN sales.stores AS s
ON st.store_id = s.store_id ;

---Task 16:  List staff members along with their manager's full name.
SELECT
      st.first_name + ' ' + st.last_name AS employee_name, 
      we.first_name +' ' + we.last_name AS manager_name
FROM sales.staffs AS st
LEFT JOIN sales.staffs AS we
ON st.manager_id = we.staff_id;

---Task 17:  Show all stores and the products they have in stock, including the product name and quantity. Only show items where quantity > 0.
SELECT 
    s.store_name,
    p.product_name,
    st.quantity
FROM 
    production.stocks AS st
INNER JOIN 
    sales.stores AS s ON st.store_id = s.store_id
INNER JOIN 
    production.products AS p ON st.product_id = p.product_id
WHERE 
    st.quantity > 0;

---Task 18:  List all customers who placed at least one order. Show customer name and order date.
SELECT 
      c.first_name + ' ' +c.last_name AS customer_name,
      o.order_date
FROM sales.customers AS c
INNER JOIN sales.orders AS o
ON c.customer_id = o.customer_id ;

---Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.
SELECT
      c.first_name + ' ' + c. last_name AS customer_name, 
      o.order_date,
      o.order_status,
      o.order_id
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
ON c.customer_id = o.customer_id ;