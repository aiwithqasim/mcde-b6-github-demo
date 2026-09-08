use BikeStores;

-- Self Join

-- Task 41:

SELECT
    e.first_name + ' ' + e.last_name AS employee,
    m.first_name + ' ' + m.last_name AS manager
FROM sales.staffs AS e
LEFT JOIN sales.staffs AS m
    ON e.manager_id = m.staff_id;

-- Task 42:

SELECT p1.product_name, p2.product_name, b.brand_name
FROM production.products p1
JOIN production.products p2
ON p1.brand_id = p2.brand_id
AND p1.list_price = p2.list_price
AND p1.product_id < p2.product_id
JOIN production.brands b
ON p1.brand_id = b.brand_id;

-- Cross Join

-- Task 45:

SELECT b.brand_name, c.category_name 
FROM production.brands as b 
CROSS JOIN production.categories as c;

-- Task 46:

SELECT b.brand_name, c.category_name
FROM production.brands b
CROSS JOIN production.categories c
LEFT JOIN production.products p
ON b.brand_id = p.brand_id
AND c.category_id = p.category_id
WHERE p.product_id IS NULL;

-- Right Join

-- Task 49:

SELECT p.product_name, b.brand_name 
FROM production.products AS p 
RIGHT JOIN production.brands AS b
ON p.brand_id = b.brand_id;

INSERT INTO production.brands (brand_name)
VALUES ('Test Brand'); -- For Testing

-- Task 50:

SELECT s.store_name, o.order_id
FROM sales.orders AS o
RIGHT JOIN sales.stores AS s
ON o.store_id = s.store_id;

INSERT INTO sales.stores (store_name)
VALUES ('Test Store'); --FOR TESTING

-- Left Anti Join (LEFT JOIN + WHERE IS NULL)

-- Task 53:

SELECT 
    c.first_name + ' ' + c.last_name AS full_name,
    o.order_id
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

INSERT INTO sales.customers
(first_name, last_name, phone, email, street, city, state, zip_code)
VALUES
('Test', 'Customer', '03001234567', 'test@gmail.com',
 '123 Main Street', 'Karachi', 'Sindh', '75000'); -- FOR TESTING

 -- Task 54:

SELECT p.product_name, st.store_id
FROM production.products AS p
LEFT JOIN production.stocks AS st
ON p.product_id = st.product_id
WHERE st.store_id IS NULL;

-- Task 56:

SELECT p.product_name, o.order_id
FROM production.products AS p
LEFT JOIN sales.order_items AS o
ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

-- Task 59:

SELECT c.category_name
FROM production.categories AS c
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) AS p
ON c.category_id = p.category_id
WHERE p.category_id IS NULL;

INSERT INTO production.categories (category_name)
VALUES ('Test Category'); -- For Testing

-- Task 60:

SELECT DISTINCT
    c.first_name + ' ' + c.last_name AS full_name
FROM sales.customers AS c
JOIN sales.orders AS o
ON c.customer_id = o.customer_id

LEFT JOIN (
    SELECT DISTINCT o2.customer_id
    FROM sales.orders AS o2
    JOIN sales.order_items AS oi
    ON o2.order_id = oi.order_id
    JOIN production.products AS p
    ON oi.product_id = p.product_id
    JOIN production.brands AS b
    ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) AS t
ON c.customer_id = t.customer_id

WHERE t.customer_id IS NULL;
