USE BikeStores;
GO

-- Extra query (Products never ordered)
SELECT 
    p.product_name,
    oi.order_id
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

-- Task 12: List every product along with its brand name and category name.
SELECT 
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products AS p
LEFT JOIN production.brands AS b
    ON p.brand_id = b.brand_id
LEFT JOIN production.categories AS c
    ON p.category_id = c.category_id;

-- Task 13: List all orders with the customer's full name, order date, and order status.
SELECT 
    CONCAT(sc.first_name, ' ', sc.last_name) AS full_name,
    so.order_date,
    so.order_status 
FROM sales.customers AS sc 
LEFT JOIN sales.orders AS so
    ON sc.customer_id = so.customer_id;

-- Task 14: Show every order item with the product name, quantity, list price, and discount.
SELECT 
    pp.product_name,
    soi.quantity,
    soi.list_price,
    soi.discount,
    soi.order_id
FROM production.products AS pp
LEFT JOIN sales.order_items AS soi
    ON pp.product_id = soi.product_id;

-- Task 15: List each staff member's full name alongside their store name.
SELECT
    CONCAT(st.first_name, ' ', st.last_name) AS FullName,
    ss.store_name
FROM sales.staffs AS st
LEFT JOIN sales.stores AS ss
    ON st.store_id = ss.store_id;

-- Task 16: List staff members along with their manager's full name.
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS StaffName,
    CONCAT(m.first_name, ' ', m.last_name) AS ManagerName
FROM sales.staffs AS e
LEFT JOIN sales.staffs AS m
    ON e.manager_id = m.staff_id;

-- Task 17: Show all stores and the products they have in stock (quantity > 0).
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

-- Task 18: List all customers who placed at least one order.
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_date
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;

-- Task 19: List ALL customers and their orders (if any).
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_date
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;
