-- ASSIGNMENT 4
-- Tasks 41-60

-- Task 41: 
SELECT
    s.first_name + ' ' + s.last_name AS staff_member,
    m.first_name + ' ' + m.last_name AS manager
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id;


-- Task 42:
SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    b.brand_name
FROM production.products AS p1
INNER JOIN production.products AS p2
    ON p1.brand_id = p2.brand_id
    AND p1.list_price = p2.list_price
    AND p1.product_id < p2.product_id
INNER JOIN production.brands AS b
    ON p1.brand_id = b.brand_id;


-- Task 43: 
SELECT
    c1.first_name + ' ' + c1.last_name AS customer_1,
    c2.first_name + ' ' + c2.last_name AS customer_2,
    c1.city,
    c1.state
FROM sales.customers AS c1
INNER JOIN sales.customers AS c2
    ON c1.city = c2.city
    AND c1.state = c2.state
    AND c1.customer_id < c2.customer_id;


-- Task 44: 
SELECT
    s.first_name + ' ' + s.last_name AS staff_member,
    m.first_name + ' ' + m.last_name AS manager,
    s.store_id
FROM sales.staffs AS s
INNER JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id
    AND s.store_id = m.store_id;



-- Task 45: 
SELECT
    b.brand_name,
    c.category_name
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
    s.store_name,
    p.product_name,
    COALESCE(st.quantity, 0) AS stock_quantity
FROM sales.stores AS s
CROSS JOIN production.products AS p
LEFT JOIN production.stocks AS st
    ON s.store_id = st.store_id
    AND p.product_id = st.product_id;


-- Task 48: 
SELECT
    s.first_name + ' ' + s.last_name AS staff_member,
    st.store_name,
    CASE
        WHEN s.store_id = st.store_id THEN 'Actual Assignment'
        ELSE 'Not Assigned'
    END AS assignment_status
FROM sales.staffs AS s
CROSS JOIN sales.stores AS st;


-- Task 49: 
SELECT
    b.brand_name,
    p.product_name
FROM production.products AS p
RIGHT JOIN production.brands AS b
    ON p.brand_id = b.brand_id;


-- Task 50: 
SELECT
    st.store_name,
    o.order_id,
    o.order_date
FROM sales.orders AS o
RIGHT JOIN sales.stores AS st
    ON o.store_id = st.store_id;


-- Task 51: 
SELECT
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM production.products AS p
RIGHT JOIN production.categories AS c
    ON p.category_id = c.category_id
GROUP BY
    c.category_id,
    c.category_name;


-- Task 52: 
SELECT
    s.first_name + ' ' + s.last_name AS staff_member,
    o.order_id,
    o.order_date
FROM sales.orders AS o
RIGHT JOIN sales.staffs AS s
    ON o.staff_id = s.staff_id;



-- Task 53: 
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Task 54: 
SELECT
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN production.stocks AS st
    ON p.product_id = st.product_id
WHERE st.store_id IS NULL;


-- Task 55: 
SELECT
    b.brand_id,
    b.brand_name
FROM production.brands AS b
LEFT JOIN production.products AS p
    ON b.brand_id = p.brand_id
WHERE p.product_id IS NULL;


-- Task 56: 
SELECT
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;


-- Task 57: 
SELECT
    st.store_id,
    st.store_name
FROM sales.stores AS st
LEFT JOIN sales.staffs AS s
    ON st.store_id = s.store_id
WHERE s.staff_id IS NULL;


-- Task 58: 
SELECT
    s.staff_id,
    s.first_name,
    s.last_name
FROM sales.staffs AS s
LEFT JOIN sales.orders AS o
    ON s.staff_id = o.staff_id
WHERE o.order_id IS NULL;


-- Task 59: 
SELECT
    c.category_id,
    c.category_name
FROM production.categories AS c
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) AS expensive_categories
    ON c.category_id = expensive_categories.category_id
WHERE expensive_categories.category_id IS NULL;


-- Task 60: 
SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT DISTINCT
        o2.customer_id
    FROM sales.orders AS o2
    INNER JOIN sales.order_items AS oi
        ON o2.order_id = oi.order_id
    INNER JOIN production.products AS p
        ON oi.product_id = p.product_id
    INNER JOIN production.brands AS b
        ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) AS trek_customers
    ON c.customer_id = trek_customers.customer_id
WHERE trek_customers.customer_id IS NULL;
