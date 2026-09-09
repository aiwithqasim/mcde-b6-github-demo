-- SECTION 4 - ADVANCE JOINS
USE BikeStores;

--										✧✧✧✧✧✧ SELF JOIN ✧✧✧✧✧✧
-- 											✦✦✦ QUESTION 41 ✦✦✦
-- Task 41: List each staff member alongside their manager's full name. If a staff member has no manager
-- (top-level), still show them with NULL for manager name.
SELECT 
	CONCAT(emp.first_name , ' ', emp.last_name) AS employee,
	CONCAT(mgr.first_name , ' ', mgr.last_name) AS manager
FROM sales.staffs emp
LEFT JOIN sales.staffs mgr
ON emp.manager_id = mgr.staff_id;

-- 											✦✦✦ QUESTION 42 ✦✦✦
-- Task 42: Find pairs of products from the same brand that have the exact same list price. Show both
-- product names and the brand name.
SELECT 
	p1.product_name,
	b.brand_name,
	p1.list_price,
	p2.product_name,
	b.brand_name,
	p2.list_price
FROM production.products AS p1
INNER JOIN production.products AS p2
	ON p1.brand_id = p2.brand_id
INNER JOIN production.brands AS b
	ON p1.brand_id = b.brand_id
WHERE p1.list_price = p2.list_price
	AND p1.product_id < p2.product_id; -- Duplicates se bachne k lie condition likhi

-- 											✦✦✦ QUESTION 43 ✦✦✦
-- Task 43: Find all pairs of customers who live in the same city and state. Avoid duplicates 
-- (don't show A-B and B-A both).
SELECT 
	c1.first_name + ' ' + c1.last_name AS customer1_name,
	c1.city,
	c1.state,
	c2.first_name + ' ' + c2.last_name AS customer2_name,
	c2.city,
	c2.state
FROM sales.customers AS c1
INNER JOIN sales.customers AS c2
ON c1.city = c2.city
WHERE c1.state = c2.state
	AND c1.customer_id < c2.customer_id;

-- 											✦✦✦ QUESTION 44 ✦✦✦
-- Task 44: List staff members who were hired at the same store as their manager.
SELECT 
	staff1.first_name + ' ' + staff1.last_name AS employee_name,
	s.store_name,
	staff2.first_name + ' ' + staff2.last_name AS manager_name,
	s.store_name
FROM sales.staffs AS staff1
INNER JOIN sales.staffs AS staff2
	ON staff1.manager_id = staff2.staff_id
INNER JOIN sales.stores	AS s
	ON staff1.store_id = s.store_id
WHERE staff1.store_id = staff2.store_id;

-- ====================================== SELF JOIN QUESTIONS COMPLETED! ============================================================
--										✧✧✧✧✧✧ CROSS JOIN ✧✧✧✧✧✧
-- 											✦✦✦ QUESTION 45 ✦✦✦
-- Task 45: Generate a list of every possible combination of brand and category. Show brand name and category name.
SELECT
	b.brand_name,
	c.category_name
FROM production.brands b
CROSS JOIN production.categories c;

-- 											✦✦✦ QUESTION 46 ✦✦✦
/* Task 46: Using the result of a CROSS JOIN between brands and categories, find brand-category
combinations that have NO products (LEFT JOIN the cross join result against products and filter for
NULLs) */
SELECT 
	b.brand_name,
	c.category_name,
	p.product_name
FROM production.brands b
CROSS JOIN production.categories c
LEFT JOIN production.products p
	ON c.category_id = p.category_id
	AND b.brand_id = p.brand_id
WHERE p.product_name IS NULL;

-- 											✦✦✦ QUESTION 47 ✦✦✦
/* Task 47: Generate a report showing every store paired with every product, along with the stock quantity.
If a store doesn't carry a product, show 0 */
SELECT
	s.store_name,
	p.product_name,
	ISNULL(st.quantity, 0) AS quantity  
FROM sales.stores s 
CROSS JOIN production.products p
LEFT JOIN production.stocks st
	ON s.store_id = st.store_id
	AND p.product_id = st.product_id;

-- 											✦✦✦ QUESTION 48 ✦✦✦
/* Task 48: Create all possible staff-store assignments (every staff paired with every store), then show which
ones are the actual current assignments.*/
SELECT 
    st.staff_id,
    st.first_name + ' ' + st.last_name AS staff_member_name,
    s.store_id,
    s.store_name,
    CASE 
        WHEN st.store_id = s.store_id THEN 'Actual Assignment'
        ELSE 'Possible Assignment'
    END AS assignment_status
FROM sales.staffs st
CROSS JOIN sales.stores s;

-- ====================================== CROSS JOIN QUESTIONS COMPLETED! ============================================================
--										✧✧✧✧✧✧ RIGHT JOIN ✧✧✧✧✧✧
-- 											✦✦✦ QUESTION 49 ✦✦✦ 
/* Task 49: List all brands and the products that belong to them. Ensure ALL brands appear, even if they
have no products. Use a RIGHT JOIN (products RIGHT JOIN brands)*/
SELECT 
    b.brand_id,
    b.brand_name,
    p.product_id,
    p.product_name
FROM production.products p
RIGHT JOIN production.brands b
    ON p.brand_id = b.brand_id;
-- 											✦✦✦ QUESTION 50 ✦✦✦ 

/* Task 50: Show all stores and the orders placed at each store. Use a RIGHT JOIN so that stores with zero
orders still appear.*/
SELECT 
    s.store_id,
    s.store_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM sales.orders o
RIGHT JOIN sales.stores s
    ON o.store_id = s.store_id;
-- 											✦✦✦ QUESTION 51 ✦✦✦ 
/* Task 51: List all categories with their product count. Use a RIGHT JOIN to ensure categories with no
products show a count of 0 */
SELECT 
    c.category_id,
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM production.products p
RIGHT JOIN production.categories c
    ON p.category_id = c.category_id
GROUP BY 
    c.category_id, 
    c.category_name;
-- 											✦✦✦ QUESTION 52 ✦✦✦ 
/* Task 52: Show all staff members and the orders they handled. Use a RIGHT JOIN on orders RIGHT JOIN
staffs, so staff who handled zero orders still appear.*/
SELECT 
    st.staff_id,
    st.first_name + ' ' + st.last_name AS staff_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM sales.orders o
RIGHT JOIN sales.staffs st
    ON o.staff_id = st.staff_id;
-- ================================== RIGHT ANTI JOIN QUESTIONS COMPLETED! ============================================================
--									 ✧✧✧✧✧✧ LEFT ANTI JOIN ✧✧✧✧✧✧
-- 											✦✦✦ QUESTION 53 ✦✦✦ 
/* Task 53: Find all customers who have NEVER placed an order.
Hint: LEFT JOIN sales.customers with sales.orders, then filter WHERE order_id IS NULL */
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone
FROM sales.customers c
LEFT JOIN sales.orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
-- 											✦✦✦ QUESTION 54 ✦✦✦ 
/* Task 54: Find all products that are NOT currently in stock at ANY store.
Hint: LEFT JOIN production.products with production.stocks, filter WHERE store_id IS NULL. */
SELECT 
    p.product_id,
    p.product_name,
    p.brand_id,
    p.category_id,
    p.list_price
FROM production.products p
LEFT JOIN production.stocks st
    ON p.product_id = st.product_id
WHERE st.store_id IS NULL;
-- 											✦✦✦ QUESTION 55 ✦✦✦ 
-- Task 55: Find brands that have NO products in the database
SELECT 
    b.brand_id,
    b.brand_name
FROM production.brands b
LEFT JOIN production.products p
    ON b.brand_id = p.brand_id
WHERE p.product_id IS NULL;

-- 											✦✦✦ QUESTION 56 ✦✦✦ 
/* Task 56: Find all products that have never been ordered.
Hint: LEFT JOIN production.products with sales.order_items, filter WHERE order_id IS NULL */
SELECT 
    p.product_id,
    p.product_name,
    p.brand_id,
    p.category_id,
    p.list_price
FROM production.products p
LEFT JOIN sales.order_items oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;
-- 											✦✦✦ QUESTION 57 ✦✦✦
-- Task 57: Find stores that have never had any staff assigned to them
SELECT 
    s.store_id,
    s.store_name,
    s.city,
    s.state
FROM sales.stores s
LEFT JOIN sales.staffs st
    ON s.store_id = st.store_id
WHERE st.staff_id IS NULL;
-- 											✦✦✦ QUESTION 58 ✦✦✦ 
-- Task 58: Find staff members who have never handled a single order
SELECT 
    st.staff_id,
    st.first_name,
    st.last_name,
    st.email,
    st.store_id
FROM sales.staffs st
LEFT JOIN sales.orders o
    ON st.staff_id = o.staff_id
WHERE o.order_id IS NULL;
-- 											✦✦✦ QUESTION 59 ✦✦✦ 
/* Task 59: Find categories where no product has a list price above 2000.
Hint: LEFT anti-join categories against a subquery of categories that DO have products above 2000. */
SELECT 
    c.category_id,
    c.category_name
FROM production.categories c
LEFT JOIN (
    SELECT DISTINCT category_id 
    FROM production.products 
    WHERE list_price > 2000
) high_price
    ON c.category_id = high_price.category_id
WHERE high_price.category_id IS NULL;
-- 											✦✦✦ QUESTION 60 ✦✦✦ 
/* Task 60: Find customers who placed orders but never ordered any product from the brand 'Trek'.
Hint: This combines a regular join (customers who ordered) with a left anti pattern (never ordered Trek) */
SELECT DISTINCT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM sales.customers c
INNER JOIN sales.orders o
    ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT DISTINCT o2.customer_id
    FROM sales.orders o2
    INNER JOIN sales.order_items oi 
        ON o2.order_id = oi.order_id
    INNER JOIN production.products p 
        ON oi.product_id = p.product_id
    INNER JOIN production.brands b 
        ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) trek_buyers
    ON c.customer_id = trek_buyers.customer_id
WHERE trek_buyers.customer_id IS NULL;
