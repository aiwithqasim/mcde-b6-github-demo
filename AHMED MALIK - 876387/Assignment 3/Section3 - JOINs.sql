

-- Task 12 is Completed!! --

SELECT
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products AS p
INNER JOIN production.brands AS b
    ON p.brand_id = b.brand_id
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id;

 -------------------------------------------------


 -- Task 13 is Completed!! --

 SELECT 
     e.first_name + ' ' + e.last_name AS customer_name,
     o.order_date,
     o.order_status
FROM sales.orders AS o
INNER JOIN sales.customers AS e
ON o.customer_id = e.customer_id;


----------------------------------------------------


-- Task 14 is Completed!! --

SELECT 
   p.product_name,
   io.quantity,
   io.list_price,
   io.discount
FROM production.products AS p
INNER JOIN sales.order_items AS io
ON io.product_id = p.product_id;


----------------------------------------------------


-- Task 15 is Completed!! --

SELECT
    s.first_name + ' ' + s.last_name AS staff_name,
    st.store_name
FROM sales.staffs AS s
INNER JOIN sales.stores AS st
    ON s.store_id = st.store_id;

----------------------------------------------------

-- Task 16 is Completed!! --

SELECT
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id;

----------------------------------------------------

-- Task 17 is Completed!! --

SELECT
    st.store_name,
    p.product_name,
    s.quantity
FROM production.stocks AS s
INNER JOIN sales.stores AS st
    ON s.store_id = st.store_id
INNER JOIN production.products AS p
    ON s.product_id = p.product_id
WHERE s.quantity > 0;
   
-----------------------------------------------------

-- Task 18 is Completed!! --

SELECT
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_date
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;

------------------------------------------------------

-- Task 19 is Completed!! --

SELECT
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_date,
    o.order_status
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;

----x-------x--------x-------------x-----------x----