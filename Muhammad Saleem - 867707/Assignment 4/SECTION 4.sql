
--Assignment 4 - Advacne JOINS 
--Self Join

--Task 41: Staff with Manager
SELECT 
    s.staff_id,
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m 
    ON s.manager_id = m.staff_id;

--Task 42: Products with Same Brand & Price
SELECT 
    p1.product_name AS product1,
    p2.product_name AS product2,
    b.brand_name,
    p1.list_price
FROM production.products AS p1
JOIN production.products AS p2 
    ON p1.brand_id = p2.brand_id
   AND p1.list_price = p2.list_price
JOIN production.brands AS b 
    ON p1.brand_id = b.brand_id
    AND p1.product_id = p2.product_id;

--Task 45: All Brand–Category Combos
SELECT 
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c;

--Task 46: Combos with No Products
SELECT 
    bc.brand_name,
    bc.category_name
FROM (
    SELECT b.brand_id, b.brand_name, c.category_id, c.category_name
    FROM production.brands AS b
    CROSS JOIN production.categories AS c
) AS bc
LEFT JOIN production.products AS p 
    ON bc.brand_id = p.brand_id 
   AND bc.category_id = p.category_id
WHERE p.product_id IS NULL;

--Task 49: All Brands + Products
SELECT 
    b.brand_name,
    p.product_name
FROM production.products AS p
RIGHT JOIN production.brands AS b 
    ON p.brand_id = b.brand_id;

--Task 50: Stores + Orders
SELECT 
    s.store_name,
    o.order_id
FROM sales.orders AS o
RIGHT JOIN sales.stores AS s 
    ON o.store_id = s.store_id;

--Task 53: Customers with No Orders
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
LEFT JOIN sales.orders AS o 
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--Task 54: Products Not in Stock
SELECT 
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN production.stocks AS s 
    ON p.product_id = s.product_id
WHERE s.store_id IS NULL;

--Task 56: Products Never Ordered
SELECT 
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN sales.order_items AS oi 
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

--Task 59: Categories with No Product > 2000
SELECT c.category_id, c.category_name
FROM production.categories AS c
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) AS high_price
    ON c.category_id = high_price.category_id
WHERE high_price.category_id IS NULL;

--Task 60: Customers Who Ordered but Never Trek
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM sales.customers AS c
JOIN sales.orders AS o 
    ON c.customer_id = o.customer_id
JOIN sales.order_items AS oi 
    ON o.order_id = oi.order_id
JOIN production.products AS p 
    ON oi.product_id = p.product_id
JOIN production.brands AS b 
    ON p.brand_id = b.brand_id
WHERE c.customer_id NOT IN (
    SELECT DISTINCT c2.customer_id
    FROM sales.customers AS c2
    JOIN sales.orders AS o2 ON c2.customer_id = o2.customer_id
    JOIN sales.order_items AS oi2 ON o2.order_id = oi2.order_id
    JOIN production.products AS p2 ON oi2.product_id = p2.product_id
    JOIN production.brands AS b2 ON p2.brand_id = b2.brand_id
    WHERE b2.brand_name = 'Trek'
);
