use bikestores;
-- Assignment 4 - Advance Joins 

--self join

--task 41 

SELECT 
    s.first_name + ' ' + s.last_name AS Staff_Name,
    m.first_name + ' ' + m.last_name AS Manager_Name
FROM sales.staffs s
LEFT JOIN sales.staffs m
    ON s.manager_id = m.staff_id;

--task 42

SELECT 
    p1.product_name AS Product_1,
    p2.product_name AS Product_2,
    b.brand_name
FROM production.products p1
JOIN production.products p2
    ON p1.brand_id = p2.brand_id
    AND p1.list_price = p2.list_price
    AND p1.product_id < p2.product_id
JOIN production.brands b
    ON p1.brand_id = b.brand_id;

--CROSS JOINS 

--task 45
SELECT 
    b.brand_name,
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c;


--task 46
SELECT 
    b.brand_name,
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c
LEFT JOIN production.products p
    ON p.brand_id = b.brand_id
    AND p.category_id = c.category_id
WHERE p.product_id IS NULL;

--RIGHT JOIN
--task 49

SELECT 
    b.brand_name,
    p.product_name
FROM production.products p
RIGHT JOIN production.brands b
    ON p.brand_id = b.brand_id;

--task 50 
SELECT 
    s.store_name,
    o.order_id
FROM sales.orders o
RIGHT JOIN sales.stores s
    ON o.store_id = s.store_id;

--LEFT ANTI JOIN 
--task 53
SELECT 
    c.first_name,
    c.last_name
FROM sales.customers c
LEFT JOIN sales.orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--task 54
SELECT 
    p.product_name
FROM production.products p
LEFT JOIN production.stocks s
    ON p.product_id = s.product_id
WHERE s.store_id IS NULL;


--task 56
SELECT 
    p.product_name
FROM production.products p
LEFT JOIN sales.order_items oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

--task 59
SELECT 
    c.category_name
FROM production.categories c
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) p
    ON c.category_id = p.category_id
WHERE p.category_id IS NULL;

--task 60 
SELECT DISTINCT
    c.first_name,
    c.last_name
FROM sales.customers c
JOIN sales.orders o
    ON c.customer_id = o.customer_id
LEFT JOIN sales.order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN production.products p
    ON oi.product_id = p.product_id
    AND p.brand_id = (
        SELECT brand_id
        FROM production.brands
        WHERE brand_name = 'Trek'
    )
WHERE p.product_id IS NULL;


