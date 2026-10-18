-- Task 41: List each staff member alongside their manager's full name.
-- If a staff member has no manager, show NULL for manager name.
-- LEFT JOIN is used because we want ALL staff members.
-- This is also a SELF JOIN because we join the staffs table with itself.

SELECT
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id;



-- Task 42: Find pairs of products from the same brand
-- that have exactly the same list price.
-- p1 and p2 represent two copies of the products table.
-- product_id < product_id prevents duplicate/reversed pairs.

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

-- Task 45: Generate every possible combination
-- of brand and category.
-- CROSS JOIN combines every brand with every category.


    SELECT
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c;

-- Task 46: Find brand-category combinations
-- that do not have any products.
-- First, CROSS JOIN creates every possible combination.
-- Then LEFT JOIN checks whether a product exists.
-- If product_id is NULL, no product exists for that combination.

SELECT
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c
LEFT JOIN production.products AS p
    ON p.brand_id = b.brand_id
    AND p.category_id = c.category_id
WHERE p.product_id IS NULL;

-- Task 49: List all brands and their products.
-- RIGHT JOIN ensures that ALL brands are displayed,
-- even if a brand does not have any products.
-- If a brand has no product, product columns will show NULL.

SELECT
    b.brand_name,
    p.product_name
FROM production.products AS p
RIGHT JOIN production.brands AS b
    ON p.brand_id = b.brand_id;

-- Task 50: Show all stores and the orders placed at each store.
-- RIGHT JOIN ensures that ALL stores are displayed,
-- even if a store has zero orders.
-- Stores without orders will have NULL in order columns.

Select 
s.store_name,
o.order_id,
o.order_date
From sales.orders as o
right join sales.stores as s
ON o.store_id = s.store_id

-- Task 53: Find customers who have NEVER placed an order.
-- LEFT JOIN keeps all customers.
-- If no matching order exists, order_id will be NULL.
-- Therefore, WHERE order_id IS NULL finds customers with no orders.

Select 
c.customer_id,
c.first_name,
c.last_name
From sales.customers as c 
left join sales.orders as o 
ON c.customer_id = o.customer_id
where o.order_id is NULL
-- Task 54: Find products that are not currently
-- in stock at any store.
-- LEFT JOIN keeps all products.
-- If a product has no matching stock record,
-- store_id will be NULL.

Select 
p.product_id,
p.product_name
From production.products as p
left join production.stocks as s
on p.product_id = s.product_id
where s.store_id is NUll;


-- Task 56: Find products that have never been ordered.
-- LEFT JOIN keeps all products.
-- If a product has never appeared in order_items,
-- order_id will be NULL.
-- WHERE order_id IS NULL returns those products.


Select 
p.product_id,
p.product_name
FROM production.products as p
left join sales.order_items as oi
ON p.product_id = oi.product_id
WHERE oi.order_id is NULL ;

-- Task 59: Find categories where no product
-- has a list price above 2000.
-- The subquery finds categories that DO have
-- at least one product with a price above 2000.
-- LEFT JOIN compares all categories with those categories.
-- NULL means the category has no product above 2000.
SELECT 
c.category_id,
c.category_name
from production.categories as c
Left Join (
SELECT DISTINCT
category_id
From production.products where list_price > 2000
) AS expensive_Category
ON c.category_id = expensive_Category.category_id
where expensive_Category.category_id is NULL

-- Task 60: Find customers who placed orders
-- but never ordered a product from the brand 'Trek'.
--
-- INNER JOIN ensures that the customer has placed an order.
-- LEFT JOIN connects the ordered products to their brands.
-- The condition checks only for the Trek brand.
-- If Trek is not fouwnd, brand_id will be NULL.
-- WHERE brand_id IS NULL therefore finds customers
-- who ordered products but never ordered Trek products.




SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
LEFT JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
LEFT JOIN production.products AS p
    ON oi.product_id = p.product_id
LEFT JOIN production.brands AS b
    ON p.brand_id = b.brand_id
    AND b.brand_name = 'Trek'
WHERE b.brand_id IS NULL;