Use bikestores;

----Assignment 3----
-----=========----

--JOINs--
--=====--

--Task 12--
--=====---

SELECT
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products AS p
JOIN production.brands AS b
    ON p.brand_id = b.brand_id
JOIN production.categories AS c
    ON p.category_id = c.category_id;


-- TASK 13
SELECT
    c.first_name + ' ' + c.last_name AS full_name,
    o.order_date,
    o.order_status
FROM sales.orders AS o
JOIN sales.customers AS c
    ON o.customer_id = c.customer_id;

-- TASK 14
SELECT
    p.product_name,
    oi.quantity,
    oi.list_price,
    oi.discount
FROM sales.order_items AS oi
JOIN production.products AS p
    ON oi.product_id = p.product_id;


-- TASK 15
SELECT
    s.first_name + ' ' + s.last_name AS full_name,
    st.store_name
FROM sales.staffs AS s
JOIN sales.stores AS st
    ON s.store_id = st.store_id;

-- TASK 16
SELECT
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id;

-- TASK 17
SELECT
    st.store_name,
    p.product_name,
    s.quantity
FROM production.stocks AS s
JOIN sales.stores AS st
    ON s.store_id = st.store_id
JOIN production.products AS p
    ON s.product_id = p.product_id
WHERE s.quantity > 0;

-- TASK 18
SELECT
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_date
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;

 -- TASK 19
 SELECT
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_date,
    o.order_status
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;


