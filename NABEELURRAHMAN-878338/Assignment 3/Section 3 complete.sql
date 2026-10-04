------------------------ SECTION 3 — JOINs =================

------- Task 12: Product + Brand name + Category name
use bikestores;
go
    SELECT 
        p.product_name,
        b.brand_name,
        c.category_name
    FROM production.products p
    INNER JOIN production.brands b ON p.brand_id = b.brand_id
    INNER JOIN production.categories c ON p.category_id = c.category_id;

------------ Task 13: Orders with Customer Full Name
    SELECT 
        o.order_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        o.order_date,
        o.order_status
    FROM sales.orders o
    INNER JOIN sales.customers c ON o.customer_id = c.customer_id;

------- Task 14: Order Items with Product name
    SELECT 
        oi.order_id,
        p.product_name,
        oi.quantity,
        oi.list_price,
        oi.discount
    FROM sales.order_items oi
    INNER JOIN production.products p ON oi.product_id = p.product_id;

----------- Task 15: Staff with Store name
    SELECT 
        CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
        st.store_name
    FROM sales.staffs s
    INNER JOIN sales.stores st ON s.store_id = st.store_id;

-------- Task 16: Staff with Manager name - Self Join
    SELECT 
        CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
        CONCAT(m.first_name, ' ', m.last_name) AS manager_name
    FROM sales.staffs s
    LEFT JOIN sales.staffs m ON s.manager_id = m.staff_id;

-------Task 17: Stores and products in stock where quantity > 0

    SELECT 
        st.store_name,
        p.product_name,
        stk.quantity
    FROM production.stocks stk
    INNER JOIN sales.stores st ON stk.store_id = st.store_id
    INNER JOIN production.products p ON stk.product_id = p.product_id
    WHERE stk.quantity > 0;

------------ Task 18: Customers who placed at least one order
    SELECT DISTINCT
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        o.order_date
    FROM sales.customers c
    INNER JOIN sales.orders o ON c.customer_id = o.customer_id
    ORDER BY o.order_date;

----------- Task 19: ALL customers and their orders - LEFT JOIN
    SELECT 
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        o.order_id,
        o.order_date
    FROM sales.customers c
    LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
    ORDER BY customer_name;


