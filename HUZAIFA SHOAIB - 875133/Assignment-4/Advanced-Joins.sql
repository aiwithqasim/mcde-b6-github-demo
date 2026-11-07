SELECT
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS StaffName,
    CONCAT(m.first_name, ' ', m.last_name) AS ManagerName
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id;

SELECT
    b.brand_name,
    p1.product_name AS Product1,
    p2.product_name AS Product2,
    p1.list_price
FROM production.products AS p1
JOIN production.products AS p2
    ON p1.brand_id = p2.brand_id
    AND p1.list_price = p2.list_price
    AND p1.product_id < p2.product_id
JOIN production.brands AS b
    ON p1.brand_id = b.brand_id;

SELECT
    c1.customer_id AS Customer1_ID,
    CONCAT(c1.first_name, ' ', c1.last_name) AS Customer1,
    c2.customer_id AS Customer2_ID,
    CONCAT(c2.first_name, ' ', c2.last_name) AS Customer2,
    c1.city,
    c1.state
FROM sales.customers AS c1
JOIN sales.customers AS c2
    ON c1.city = c2.city
    AND c1.state = c2.state
    AND c1.customer_id < c2.customer_id;

    SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS StaffName,
    CONCAT(m.first_name, ' ', m.last_name) AS ManagerName,
    s.store_id
FROM sales.staffs AS s
JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id
    AND s.store_id = m.store_id;


    SELECT
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c;


SELECT
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c
LEFT JOIN production.products AS p
    ON p.brand_id = b.brand_id
    AND p.category_id = c.category_id
WHERE p.product_id IS NULL;


SELECT
    s.store_name,
    p.product_name,
    COALESCE(st.quantity, 0) AS StockQuantity
FROM sales.stores AS s
CROSS JOIN production.products AS p
LEFT JOIN production.stocks AS st
    ON s.store_id = st.store_id
    AND p.product_id = st.product_id;

    SELECT
    CONCAT(sf.first_name, ' ', sf.last_name) AS StaffName,
    st.store_name,
    CASE
        WHEN sf.store_id = st.store_id
        THEN 'Actual Assignment'
        ELSE 'Not Assigned'
    END AS AssignmentStatus
FROM sales.staffs AS sf
CROSS JOIN sales.stores AS st;

SELECT
    b.brand_name,
    p.product_name
FROM production.products AS p
RIGHT JOIN production.brands AS b
    ON p.brand_id = b.brand_id;

    SELECT
    st.store_name,
    o.order_id,
    o.order_date
FROM sales.orders AS o
RIGHT JOIN sales.stores AS st
    ON o.store_id = st.store_id;