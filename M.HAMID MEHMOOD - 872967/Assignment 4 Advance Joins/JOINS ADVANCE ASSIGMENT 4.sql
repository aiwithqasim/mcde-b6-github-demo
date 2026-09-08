Use BikeStores;

-- Task 41

SELECT 
    s.first_name + ' ' + s.last_name AS Staff_Name,
    m.first_name + ' ' + m.last_name AS Manager_Name
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id;


-- Task 42:

SELECT 
    p.product_name AS Product_1,
    p1.product_name AS Product_2,
    p.list_price,
    b.brand_name
FROM production.products AS p
INNER JOIN production.products AS p1
    ON p.brand_id = p1.brand_id
    AND p.list_price = p1.list_price
    AND p.product_id < p1.product_id
INNER JOIN production.brands AS b
    ON p.brand_id = b.brand_id;


--Task 43:

SELECT 
    c.first_name + ' ' + c.last_name AS Customer_1,
    c1.first_name + ' ' + c1.last_name AS Customer_2,
    c.city,
    c.state
FROM sales.customers AS c
INNER JOIN sales.customers AS c1
    ON c.state = c1.state
    AND c.city = c1.city
    AND c.customer_id < c1.customer_id;


-- Task 44:

SELECT 
    s.first_name + ' ' + s.last_name AS Staff_Name,
    m.first_name + ' ' + m.last_name AS Manager_Name,
    s.store_id
FROM sales.staffs AS s
INNER JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id
    AND s.store_id = m.store_id;


-- Task 45:

SELECT 
    b.brand_name AS Brand_Name,
    c.category_name AS Category_Name
FROM production.brands AS b
CROSS JOIN production.categories AS c;


-- Task 46: 

SELECT 
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c
LEFT JOIN production.products AS p
    ON p.brand_id = b.brand_id
    AND p.category_id = c.category_id
WHERE p.product_id IS NULL;


-- Task 47: 


SELECT 
    p.product_name,
    st.store_name,
    ISNULL(s.quantity, 0) AS Quantity
FROM production.products AS p
CROSS JOIN sales.stores AS st
LEFT JOIN production.stocks AS s
    ON s.product_id = p.product_id
    AND s.store_id = st.store_id;


--Task 48: 

SELECT
    s.first_name + ' ' + s.last_name AS Staff_Name,
    st.store_name,
    IIF(
        s.store_id = st.store_id,
        'Actual',
        'Possible'
    ) AS Assignment_Status
FROM sales.staffs AS s
CROSS JOIN sales.stores AS st
ORDER BY s.staff_id, st.store_id;


--Task 49:

SELECT 
    p.product_name,
    b.brand_name
FROM production.products AS p
RIGHT JOIN production.brands AS b
    ON b.brand_id = p.brand_id;


--Task 50:

SELECT
    o.order_status,
    s.store_name
FROM sales.orders AS o
RIGHT JOIN sales.stores AS s
    ON o.store_id = s.store_id
ORDER BY o.order_status ASC;


--Task 51:

SELECT 
    c.category_name,
    COUNT(p.product_id) AS Product_Count
FROM production.products AS p
RIGHT JOIN production.categories AS c
    ON c.category_id = p.category_id
GROUP BY c.category_name;


--Task 52:

SELECT 
    s.first_name + ' ' + s.last_name AS Staff_Name,
    COUNT(o.order_id) AS Orders_Handled
FROM sales.orders AS o
RIGHT JOIN sales.staffs AS s
    ON o.staff_id = s.staff_id
GROUP BY 
    s.first_name + ' ' + s.last_name;


--Task 53: 

SELECT
    c.customer_id AS Customer_ID,
    c.first_name + ' ' + c.last_name AS Customer_Name
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Task 54:

SELECT 
    p.product_name AS Product_Not_In_Stock,
    p.product_id,
    s.quantity
FROM production.products AS p
LEFT JOIN production.stocks AS s
    ON p.product_id = s.product_id
    AND s.quantity > 0
WHERE s.store_id IS NULL;


-- Task 55:

SELECT 
    b.brand_name AS Brand_With_No_Products
FROM production.brands AS b
LEFT JOIN production.products AS p
    ON b.brand_id = p.brand_id
WHERE p.product_id IS NULL;


--Task 56:

SELECT 
    p.product_name AS Product_Never_Ordered
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;


--Task 57:

SELECT 
    s.store_name AS Store_Without_Staff
FROM sales.stores AS s
LEFT JOIN sales.staffs AS st
    ON s.store_id = st.store_id
WHERE st.store_id IS NULL;


-- Task 58:

SELECT 
    s.first_name + ' ' + s.last_name AS Staff_Name
FROM sales.staffs AS s
LEFT JOIN sales.orders AS o
    ON s.staff_id = o.staff_id
WHERE o.order_id IS NULL;



-- Task 59:

SELECT 
    c.category_name
FROM production.categories AS c
LEFT JOIN production.products AS p
    ON c.category_id = p.category_id 
GROUP BY c.category_id, c.category_name
HAVING MAX(p.list_price) <= 2000;



-- Task 60:

SELECT DISTINCT
    c.first_name + ' ' + c.last_name AS Customer_Name
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT DISTINCT
        o.customer_id
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    INNER JOIN production.products AS p
        ON oi.product_id = p.product_id
    INNER JOIN production.brands AS b
        ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) AS Trek_Orders
    ON c.customer_id = Trek_Orders.customer_id
WHERE Trek_Orders.customer_id IS NULL;
