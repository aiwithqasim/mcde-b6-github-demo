
SELECT * FROM
sales.customers 

SELECT * FROM
production.products

--         ====== ADVANCE JOINs ======

-- Task 41: List each staff member alongside their manager's full name.
-- If a staff member has no manager (top-level), still show them with NULL for manager name.

SELECT s.first_name+ ' ' +s.last_name AS Staff,
m.first_name+ ' ' +m.last_name AS Manager
FROM 
sales.staffs AS  s
LEFT JOIN sales.staffs AS m
ON s.staff_id = m.manager_id 

-- Task 42: Find pairs of products from the same brand that have the exact same list price.
-- Show both product names and the brand name.

SELECT p.product_name AS product_name,
p2.product_name AS product_name_02,
b.brand_name AS brand_name,
p.list_price
FROM 
production.products AS p
LEFT JOIN production.brands AS b
ON p.brand_id = b.brand_id
JOIN production.products AS p2
On p.brand_id = p2.brand_id
AND p.list_price = p2.list_price
AND p.product_id < p2.product_id

-- Task 43: Find all pairs of customers who live in the same city and state.
-- Avoid duplicates (don't show A-B and B-A both).

SELECT c.first_name+ ' ' +c.last_name AS customer_pair01,
c2.first_name+ ' ' +c2.last_name AS customer_pair02,
c.city,
c.state
FROM
sales.customers AS c
INNER JOIN sales.customers AS c2
ON c.city = c2.city
AND c.state = c2.state
AND c.customer_id < c2.customer_id

-- Task 44: List staff members who were hired at the same store as their manager.
-- Cross Join

SELECT s.first_name+ ' ' +s.last_name AS staff_name,
m.first_name+ ' ' +m.last_name AS Manager,
m.staff_id
FROM 
sales.staffs AS s
CROSS JOIN sales.staffs AS m
WHERE s.manager_id = m.staff_id AND s.store_id = m.store_id 

-- Task 45: Generate a list of every possible combination of brand and category.
-- Show brand name and category name.
-- Hint: This is useful when you want to find which brand-category combos have no products.

SELECT b.brand_name,
c.category_name,
p.product_name
FROM 
production.brands AS b
CROSS JOIN production.categories AS c
LEFT JOIN production.products AS p
ON b.brand_id = p.brand_id AND c.category_id = p.category_id

-- Task 46: Using the result of a CROSS JOIN between brands and categories,
-- find brand-category combinations that have NO products 
-- (LEFT JOIN the cross join result against products and filter for NULLs).

SELECT b.brand_name,
c.category_name,
p.product_name
FROM 
production.brands AS b
CROSS JOIN production.categories AS c
LEFT JOIN production.products AS p
ON b.brand_id = p.brand_id AND c.category_id = p.category_id
WHERE P.product_id IS NULL

-- Task 47: Generate a report showing every store paired with every product, 
-- along with the stock quantity. If a store doesn't carry a product, show 0.

SELECT s.store_name ,
p.product_name,
ISNULL(st.quantity, 0) AS quantity
FROM 
sales.stores AS s
CROSS JOIN production.products AS p
LEFT JOIN production.stocks AS st
ON s.store_id = st.store_id AND p.product_id = st.product_id

-- Task 48: Create all possible staff-store assignments (every staff paired with every store),
-- then show which ones are the actual current assignments.

SELECT 
    s.first_name + ' ' + s.last_name AS staff_name,
    st.store_name,
    CASE
        WHEN s.staff_id = stf.staff_id
             AND st.store_id = stf.store_id
        THEN 'Actual Assignment'
        ELSE 'Not Actual'
    END AS assignment_status
FROM sales.staffs AS s
CROSS JOIN sales.stores AS st
RIGHT JOIN sales.staffs AS stf
    ON s.staff_id = stf.staff_id
    AND st.store_id = stf.store_id;

-- Task 49: List all brands and the products that belong to
-- them. Ensure ALL brands appear, even if they have no products.
-- Use a RIGHT JOIN (products RIGHT JOIN brands).

SELECT
b.brand_name,
p.product_name
FROM production.products AS p
RIGHT JOIN production.brands AS b
ON p.brand_id = b.brand_id;

-- Task 50: Show all stores and the orders placed at each
-- store. Use a RIGHT JOIN so that stores with zero orders still appear.

SELECT
st.store_name,
o.order_id,
o.order_date,
o.order_status
FROM sales.orders AS o
RIGHT JOIN sales.stores AS st
ON o.store_id = st.store_id;

-- Task 51: List all categories with their product count. Use a
-- RIGHT JOIN to ensure categories with no products show a count of 0.

SELECT
c.category_name,
COUNT(p.product_id) AS product_count
FROM production.products AS p
RIGHT JOIN production.categories AS c
ON p.category_id = c.category_id
GROUP BY c.category_name;

-- Task 52: Show all staff members and the orders they handled.
-- Use a RIGHT JOIN on orders RIGHT JOIN staffs, so staff who handled
-- zero orders still appear.

SELECT
s.first_name + ' ' + s.last_name AS staff_name,
o.order_id,
o.order_date,
o.order_status
FROM sales.orders AS o
RIGHT JOIN sales.staffs AS s
ON o.staff_id = s.staff_id;

-- Left Anti Join (LEFT JOIN + WHERE IS NULL)

-- Task 53: Find all customers who have NEVER placed an order.
-- Hint: LEFT JOIN sales.customers with sales.orders,
-- then filter WHERE order_id IS NULL.

SELECT
c.customer_id,
c.first_name,
c.last_name
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Task 54: Find all products that are NOT currently in stock
-- at ANY store.
-- Hint: LEFT JOIN production.products with production.stocks,
-- filter WHERE store_id IS NULL.

SELECT
p.product_id,
p.product_name
FROM production.products AS p
LEFT JOIN production.stocks AS st
ON p.product_id = st.product_id
WHERE st.store_id IS NULL;

-- Task 55: Find brands that have NO products in the database.

SELECT
b.brand_id,
b.brand_name
FROM production.brands AS b
LEFT JOIN production.products AS p
ON b.brand_id = p.brand_id
WHERE p.product_id IS NULL;

-- Task 56: Find all products that have never been ordered.
-- Hint: LEFT JOIN production.products with sales.order_items,
-- filter WHERE order_id IS NULL.

SELECT
p.product_id,
p.product_name
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

-- Task 57: Find stores that have never had any staff assigned
-- to them.

SELECT
st.store_id,
st.store_name
FROM sales.stores AS st
LEFT JOIN sales.staffs AS s
ON st.store_id = s.store_id
WHERE s.staff_id IS NULL;

-- Task 58: Find staff members who have never handled a single order.

SELECT
s.staff_id,
s.first_name,
s.last_name
FROM sales.staffs AS s
LEFT JOIN sales.orders AS o
ON s.staff_id = o.staff_id
WHERE o.order_id IS NULL;

-- Task 59: Find categories where no product has a list price
-- above 2000.
-- Hint: LEFT anti-join categories against a subquery of
-- categories that DO have products above 2000.

SELECT
c.category_id,
c.category_name
FROM production.categories AS c
LEFT JOIN
(
SELECT DISTINCT category_id
FROM production.products
WHERE list_price > 2000
) AS expensive
ON c.category_id = expensive.category_id
WHERE expensive.category_id IS NULL;

-- Task 60: Find customers who placed orders but never ordered
-- any product from the brand 'Trek'.
-- Hint: This combines a regular join (customers who ordered)
-- with a left anti pattern (never ordered Trek).

SELECT DISTINCT
c.customer_id,
c.first_name,
c.last_name
FROM sales.customers AS c
INNER JOIN sales.orders AS o
ON c.customer_id = o.customer_id
LEFT JOIN
(
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





