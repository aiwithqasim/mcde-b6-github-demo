--SELF JOIN

/*Task 41: List each staff member alongside their manager's full name. 
If a staff member has no manager (top-level), 
still show them with NULL for manager name.*/

SELECT
   e.first_name + ' ' + e.last_name as employee,
   m.first_name + ' ' + m.last_name as manager
FROM sales.staffs AS e
LEFT JOIN sales.staffs AS m
   ON e.manager_id = m.staff_id;

/*Task 42: Find pairs of products from the same brand that 
have the exact same list price. Show both product names and the brand name.*/

SELECT
    p1.product_name,
    p2.product_name, 
    p1.brand_id,
    p1.list_price
FROM production.products AS p1
JOIN production.products AS p2
    ON p1.brand_id = p2.brand_id
    AND p1.list_price = p2.list_price
    AND p1.product_id < p2.product_id;

-- CROSS JOIN
/* Task 45: Generate a list of every possible combination of brand and category. 
Show brand name and category name.*/

SELECT 
   b.brand_name,
   c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c;

/*Task 46: Using the result of a CROSS JOIN between brands and categories, find brand-category combinations that have NO products 
(LEFT JOIN the cross join result against products and filter for NULLs).*/

SELECT
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c
LEFT JOIN production.products AS p
    ON b.brand_id = p.brand_id
    AND c.category_id = p.category_id
WHERE p.product_id IS NULL;

--Right Join
/*Task 49: List all brands and the products that belong to them. Ensure ALL brands appear,
even if they have no products.
Use a RIGHT JOIN (products RIGHT JOIN brands).*/
SELECT 
  b.brand_name,
  p.product_name
FROM production.products as p
RIGHT JOIN  production.brands as b
on p.brand_id = b.brand_id;

/* Task 50: Show all stores and the orders placed at each store. 
Use a RIGHT JOIN so that stores with zero orders still appear.*/
SELECT 
  s.store_name ,
  o.order_id
FROM sales.orders as o
RIGHT JOIN sales.stores as s
on o.store_id = s.store_id

-- LEFT ANTI JOIN (LEFT JOIN + WHERE IS NULL) 
/* Find all customers who have never placed an order*/

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

--Find all products that are NOT currently in stock at ANY store.

SELECT 
    p.product_name,
    p.product_id
FROM production.products AS p
LEFT JOIN production.stocks AS s
    ON  p.product_id = s.product_id
WHERE s.product_id is null;

--Find all products that have never been ordered.
SELECT 
   p.product_name
FROM production.products AS p
LEFT JOIN sales.order_items AS s
ON p.product_id = s.product_id
WHERE s.order_id is null;

--Find categories where no product has a list price above 2000
--Hint: LEFT anti-join categories against a subquery of categories that DO have products above 2000.

SELECT c.category_name
FROM production.categories AS c
LEFT JOIN (
    SELECT DISTINCT c.category_id
    FROM production.categories AS c
    JOIN production.products AS p
        ON c.category_id = p.category_id
    WHERE p.list_price > 2000
) AS expensive
    ON c.category_id = expensive.category_id
WHERE expensive.category_id IS NULL;

--Find customers who placed orders but never ordered any product from the brand 'Trek'.
SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT DISTINCT o.customer_id
    FROM sales.orders AS o
    JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    JOIN production.products AS p
        ON oi.product_id = p.product_id
    JOIN production.brands AS b
        ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) AS trek
    ON c.customer_id = trek.customer_id
WHERE trek.customer_id IS NULL;

       














   
   
 
