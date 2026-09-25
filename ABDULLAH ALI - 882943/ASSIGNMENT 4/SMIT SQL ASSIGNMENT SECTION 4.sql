--ASSIGNMENT NO.4
--TASK; 1

SELECT staff1.first_name + ' ' + staff1.last_name AS staff,
       staff2.first_name + ' ' + staff2.last_name AS manager
FROM sales.staffs AS staff1
left join sales.staffs as staff2
ON staff2.staff_id = staff1.manager_id;

--TASK; 2 

SELECT 
    product1.product_name AS product1,
    product2.product_name AS product2,
    brands.brand_name,
    product1.list_price
FROM production.products AS product1
INNER JOIN production.products AS product2
    ON product1.brand_id = product2.brand_id
    AND product1.list_price = product2.list_price
    AND product1.product_id < product2.product_id
INNER JOIN production.brands AS brands
    ON product1.brand_id = brands.brand_id;

--TASK 3;
SELECT 
    brands.brand_name,
    categories.category_name
FROM production.brands AS brands
CROSS JOIN production.categories AS categories;

--TASK 4;

SELECT 
    brands.brand_name,
    categories.category_name
FROM production.brands AS brands
CROSS JOIN production.categories AS categories
LEFT JOIN production.products AS products
    ON products.brand_id = brands.brand_id
    AND products.category_id = categories.category_id
WHERE products.product_id IS NULL;

--TASK 5;

    SELECT b.brand_name, p.product_name
    FROM production.products p
    RIGHT JOIN production.brands AS b
    on p.brand_id = b.brand_id;

 --TASK 6;
 SELECT s.store_name, o.order_date
 FROM sales.orders AS o
 RIGHT JOIN sales.stores AS s
 ON o.store_id = s.store_id
--TASK 7;

 SELECT cust.first_name, cust.last_name, o.order_date
 FROM sales.customers AS cust 
 LEFT join sales.orders AS o
 on cust.customer_id = o.customer_id
 WHERE o.order_date IS NULL

 --TASK 8;

 SELECT p.product_name
 FROM production.products as p
 LEFT JOIN production.stocks as s
 ON p.product_id = s.product_id
 WHERE s.store_id IS NULL

--TASK 9;
  SELECT 
    p.product_name
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;
-- TASK 10;

SELECT 
    c.category_name
FROM production.categories AS c
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) AS expensive_categories
    ON c.category_id = expensive_categories.category_id
WHERE expensive_categories.category_id IS NULL;

--TASK 11;

SELECT DISTINCT
    c.first_name,
    c.last_name
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
) AS trek_customers
    ON c.customer_id = trek_customers.customer_id
WHERE trek_customers.customer_id IS NULL;