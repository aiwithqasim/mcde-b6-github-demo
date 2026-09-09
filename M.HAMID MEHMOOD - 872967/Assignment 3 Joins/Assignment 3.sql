--TASK12

SELECT 
    p.product_name, 
    b.brand_name, 
    c.category_name
FROM production.products p
INNER JOIN production.brands b ON p.brand_id = b.brand_id
INNER JOIN production.categories c ON p.category_id = c.category_id;

--TASK13
SELECT 
    o.order_id, 
    c.first_name + ' ' + c.last_name AS customer_name, 
    o.order_date, 
    o.order_status
FROM sales.orders o
INNER JOIN sales.customers c ON o.customer_id = c.customer_id;

--TASK!4

SELECT 
    oi.order_id, 
    p.product_name, 
    oi.quantity, 
    oi.list_price, 
    oi.discount
FROM sales.order_items oi
INNER JOIN production.products p ON oi.product_id = p.product_id;

--TASK15

SELECT 
    s.first_name + ' ' + s.last_name AS staff_name, 
    st.store_name
FROM sales.staffs s
INNER JOIN sales.stores st ON s.store_id = st.store_id;

--TASK16

SELECT 
    e.first_name + ' ' + e.last_name AS staff_name, 
    ISNULL(m.first_name + ' ' + m.last_name, 'Top Manager') AS manager_name
FROM sales.staffs e
LEFT JOIN sales.staffs m ON e.manager_id = m.staff_id;

--TASK17

SELECT 
    st.store_name, 
    p.product_name, 
    s.quantity
FROM production.stocks s
INNER JOIN sales.stores st ON s.store_id = st.store_id
INNER JOIN production.products p ON s.product_id = p.product_id
WHERE s.quantity > 0;

--TASK18

SELECT DISTINCT 
    c.customer_id, 
    c.first_name + ' ' + c.last_name AS customer_name, 
    o.order_date
FROM sales.customers c
INNER JOIN sales.orders o ON c.customer_id = o.customer_id;

--TASK19

SELECT 
    c.customer_id, 
    c.first_name + ' ' + c.last_name AS customer_name, 
    o.order_id, 
    o.order_date
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id;

