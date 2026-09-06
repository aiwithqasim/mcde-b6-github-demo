Use bikestores

SELECT
    p.product_name,
    oi.order_id
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;
-- List every product along with its brand name and category name.
select * from production.brands
select * from production.categories
select * from production.products

SELECT 
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products AS p
LEFT JOIN production.brands AS b
    ON p.brand_id = b.brand_id
LEFT JOIN production.categories AS c
    ON p.category_id = c.category_id;

-- List all orders with the customer's full name (first_name + last_name), order date, and order status.

select 
CONCAT(sc.first_name, ' ', sc.last_name) AS full_name,
so.order_date,
so.order_status 
from sales.customers as sc 
Left Join sales.orders as so
ON sc.customer_id = so.customer_id

--Show every order item with the product name, quantity, list price, and discount.
select 
pp.product_name,
soi.list_price,
soi.quantity,
soi.discount,
soi.order_id
from production.products AS pp
Left Join sales.order_items AS soi
ON pp.product_id = soi.product_id;

-- List each staff member's full name alongside their store name.

select
CONCAT(first_name,' ',last_name) AS FullName,
ss.store_name
From sales.staffs AS st
Left Join sales.stores AS ss
ON st.store_id = ss.store_id;

--List staff members along with their manager's full name.

SELECT
    e.staff_id,
    CONCAT(e.first_name, ' ', e.last_name) AS FullName
FROM sales.staffs AS e
JOIN sales.staffs AS m
    ON e.staff_id = m.staff_id;

--Show all stores and the products they have in stock, including the product name and quantity. Only show items where quantity > 0

SELECT
    s.store_name,
    p.product_name,
    st.quantity
FROM sales.stores AS s
JOIN production.stocks AS st
    ON s.store_id = st.store_id
JOIN production.products AS p
    ON st.product_id = p.product_id
WHERE st.quantity > 0;

-- List all customers who placed at least one order. Show customer name and order date.
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_date
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;

--:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_date
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;