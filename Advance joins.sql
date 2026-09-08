use bikestores;
go

-- ============================================================
-- Self Join
-- ============================================================

-- Task 41: List each staff member alongside their manager's full name.
-- If a staff member has no manager (top-level), still show them
-- with NULL for manager name.

SELECT
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
    ON s.manager_id = m.staff_id;
     
     -- Task 42: Find pairs of products from the same brand that have
-- the exact same list price. Show both product names and brand name.

select * 
from
production.products;

select
p1.product_name as product_1,
p2.product_name as product_2,
b.brand_name,
p1.list_price

from production.products as p1
join production.products as p2
on p1.brand_id = p2.brand_id
and p1.list_price = p2.list_price

join production.brands as b
on p1.brand_id = b.brand_id

-- Task 43: Find all pairs of customers who live in the same city
-- and state. Avoid duplicates (don't show A-B and B-A both).

select *
from sales.customers;


SELECT
    c1.customer_id AS customer_1_id,
    CONCAT(c1.first_name, ' ', c1.last_name) AS customer_1,
    c2.customer_id AS customer_2_id,
    CONCAT(c2.first_name, ' ', c2.last_name) AS customer_2,
    c1.city,
    c1.state
FROM sales.customers AS c1
join sales.customers as c2
on c1.city = c2.city
and c1.state = c2.state
and c1.customer_id < c2.customer_id;

-- Task 44: List staff members who were hired at the same store
-- as their manager.

select *
from sales.staffs;
select
s.staff_id,
s.store_id,
concat(s.first_name,' ',s.last_name) as staff_name,
concat(m.first_name,' ',m.last_name) as manager_name
from sales.staffs as s
join sales.staffs as m
on s.staff_id = m.manager_id
and s.store_id = m.store_id

-- ============================================================
-- Cross Join
-- ============================================================

-- Task 45: Generate a list of every possible combination of
-- brand and category. Show brand name and category name.

select
b.brand_name,
c.category_name
from production.brands as b 
cross join production.categories as c;


-- Task 46: Using the result of a CROSS JOIN between brands and
-- categories, find brand-category combinations that have NO products.

select
b.brand_name,
c.category_name
from production.brands as b 
cross join production.categories as c
left join production.products as p
on p.brand_id = b.brand_id
and p.category_id = c.category_id
where p.product_name is null;

-- Task 47: Generate a report showing every store paired with
-- every product, along with the stock quantity.
-- If a store doesn't carry a product, show 0.


select
s.store_id,
s.store_name,
p.product_id,
p.product_name,

isnull(st.quantity, 0) as stock_quantity
from sales.stores as s 
cross join production.products as p
left join production.stocks as st
on s.store_id = st.store_id
and p.product_id = st.product_id;

-- Task 48: Create all possible staff-store assignments
-- (every staff paired with every store), then show which ones
-- are the actual current assignments.

SELECT
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    st.store_id,
    st.store_name,
    CASE
        WHEN s.store_id = st.store_id THEN 'Current Assignment'
        ELSE 'Not Assigned'
    END AS assignment_status
FROM sales.staffs AS s
CROSS JOIN sales.stores AS st;

-- ============================================================
-- Right Join
-- ============================================================

-- Task 49: List all brands and the products that belong to them.
-- Ensure ALL brands appear, even if they have no products.
-- Use a RIGHT JOIN (products RIGHT JOIN brands).
select
s.brand_id,
s.brand_name,
b.product_id,
b.product_name

from production.brands as s
right join production.products as b
on b.brand_id = s.brand_id;


-- Task 50: Show all stores and the orders placed at each store.
-- Use a RIGHT JOIN so that stores with zero orders still appear.

select 
oi.order_id,
oi.order_date,
oi.order_status,
si.store_id,
si.store_name

from sales.orders as oi
right join sales.stores as si
on oi.store_id = si.store_id;

-- Task 51: List all categories with their product count.
-- Use a RIGHT JOIN to ensure categories with no products
-- show a count of 0.

SELECT
    c.category_id,
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM production.products AS p
RIGHT JOIN production.categories AS c
    ON p.category_id = c.category_id
GROUP BY
    c.category_id,
    c.category_name;


-- Task 52: Show all staff members and the orders they handled.
-- Use a RIGHT JOIN on orders RIGHT JOIN staffs, so staff who
-- handled zero orders still appear.

SELECT
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM sales.orders AS o
RIGHT JOIN sales.staffs AS s
    ON o.staff_id = s.staff_id;


-- ============================================================
-- Left Anti Join (LEFT JOIN + WHERE IS NULL)
-- ============================================================

-- Task 53: Find all customers who have NEVER placed an order.

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Task 54: Find all products that are NOT currently in stock
-- at ANY store.

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

SELECT
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;


-- Task 57: Find stores that have never had any staff assigned to them.

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
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name
FROM sales.staffs AS s
LEFT JOIN sales.orders AS o
    ON s.staff_id = o.staff_id
WHERE o.order_id IS NULL;


-- Task 59: Find categories where no product has a list price above 2000.
-- Left anti-join categories against categories that DO have
-- products above 2000.

SELECT
    c.category_id,
    c.category_name
FROM production.categories AS c
LEFT JOIN (
    SELECT DISTINCT
        category_id
    FROM production.products
    WHERE list_price > 2000
) AS expensive_categories
    ON c.category_id = expensive_categories.category_id
WHERE expensive_categories.category_id IS NULL;


-- Task 60: Find customers who placed orders but never ordered
-- any product from the brand 'Trek'.

SELECT DISTINCT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM sales.customers AS c
JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT DISTINCT
        o2.customer_id
    FROM sales.orders AS o2
    JOIN sales.order_items AS oi
        ON o2.order_id = oi.order_id
    JOIN production.products AS p
        ON oi.product_id = p.product_id
    JOIN production.brands AS b
        ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) AS trek_customers
    ON c.customer_id = trek_customers.customer_id
WHERE trek_customers.customer_id IS NULL;
























