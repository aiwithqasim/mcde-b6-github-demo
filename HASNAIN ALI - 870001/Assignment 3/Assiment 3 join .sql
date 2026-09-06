use  bikestore;


--- task 12
SELECT 
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products p
JOIN production.brands b ON p.brand_id = b.brand_id
JOIN production.categories c ON p.category_id = c.category_id;

-- TASK 13
SELECT 
    c.first_name + ' ' + c.last_name AS customer_full_name,
    o.order_date,
    o.order_status
FROM sales.orders o
JOIN sales.customers c ON o.customer_id = c.customer_id;

--TASK 14

SELECT 
    p.product_name,
    oi.quantity,
    oi.list_price,
    oi.discount
FROM sales.order_items oi
JOIN production.products p ON oi.product_id = p.product_id;

---TAK 15

SELECT 
    s.first_name + ' ' + s.last_name AS staff_full_name,
    st.store_name
FROM sales.staffs s
JOIN sales.stores st ON s.store_id = st.store_id;

--Task 16
SELECT 
    e.first_name + ' ' + e.last_name AS staff_full_name,
    m.first_name + ' ' + m.last_name AS manager_full_name
FROM sales.staffs e
LEFT JOIN sales.staffs m ON e.manager_id = m.staff_id;

--Task 17
SELECT 
    st.store_name,
    p.product_name,
    s.quantity
FROM production.stocks s
JOIN sales.stores st ON s.store_id = st.store_id
JOIN production.products p ON s.product_id = p.product_id
WHERE s.quantity > 0;


--task18

SELECT DISTINCT
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_date
FROM sales.customers c
INNER JOIN sales.orders o ON c.customer_id = o.customer_id;

--task 19 
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id;