-- SELF JOIN --

-- Task 41:

SELECT
	e.first_name + ' ' + e.last_name as employee,
	m.first_name + ' ' + m.last_name as manager
FROM sales.staffs as e
LEFT JOIN sales.staffs as m
	ON m.staff_id = e.manager_id

-- Task 42:

SELECT
	p1.product_name as product_1,
	p2.product_name as product_2,
	b.brand_name,
	p1.list_price
FROM production.products as p1
INNER JOIN production.products as p2
	ON p1.brand_id = p2.brand_id
	AND p1.list_price = p2.list_price
	AND p1.product_id < p2.product_id
INNER JOIN production.brands as b
	ON p1.brand_id = b.brand_id

-- Task 43:

SELECT
	c1.first_name + ' ' + c1.last_name as customer_1,
	c2.first_name + ' ' + c2.last_name as customer_2,
	c1.city,
	c1.state
FROM sales.customers as c1
INNER JOIN sales.customers as c2
	ON c1.city = c2.city
	AND c1.state = c2.state
	AND c1.customer_id < c2.customer_id

-- Task 44:

SELECT
	e.first_name + ' ' + e.last_name as employee,
	m.first_name + ' ' + m.last_name as hired_by
FROM sales.staffs as e
LEFT JOIN sales.staffs as m
	ON e.manager_id = m.staff_id
	AND e.store_id = m.store_id

-- CROSS JOIN --

-- Task 45:

SELECT
	b.brand_name,
	c.category_name
FROM production.brands as b
CROSS JOIN production.categories as c

-- Task 46:

SELECT
	b.brand_name,
	c.category_name
FROM production.brands as b
CROSS JOIN production.categories as c
LEFT JOIN production.products as p
	ON b.brand_id = p.brand_id
	AND c.category_id = p.category_id
	WHERE p.product_id is NULL

-- Task 47:

SELECT
	s.store_name,
	p.product_name,
	ISNULL(st.quantity, 0) as quantity
FROM sales.stores as s
CROSS JOIN production.products as p
LEFT JOIN production.stocks as st
	ON s.store_id = st.store_id
	AND p.product_id = st.product_id

-- Task 48:

SELECT
	s.first_name,
	st.store_name,
CASE
	WHEN s.store_id = st.store_id THEN 'Actual Assignment'
	ELSE 'Not Actual'
	END as assignment_status
FROM sales.staffs as s
CROSS JOIN sales.stores as st

-- RIGHT JOIN --

-- Task 49:

SELECT
	p.product_name,
	b.brand_name
FROM production.products as p
RIGHT JOIN production.brands as b
	ON p.brand_id = b.brand_id

-- Task 50:

SELECT
	s.store_name,
	o.order_id
FROM sales.orders as o
RIGHT JOIN sales.stores as s
	ON s.store_id = o.store_id

-- Task 51:

SELECT
	COUNT(p.product_id) as counted_products,
	c.category_name
FROM production.products as p
RIGHT JOIN production.categories as c
	ON p.category_id = c.category_id
	GROUP BY c.category_name 

-- Task 52:

SELECT
	s.first_name + ' ' + s.last_name as staff_name,
	o.order_id
FROM sales.staffs as s
RIGHT JOIN sales.orders as o
	ON s.staff_id = o.staff_id

-- Left Anti Join (LEFT JOIN + WHERE IS NULL) --

-- Task 53:

SELECT
	s.first_name + ' ' + s.last_name as customer_name,
	o.order_id
FROM sales.customers as s
LEFT JOIN sales.orders as o
	ON s.customer_id = o.customer_id
	WHERE order_id is NULL

-- Task 54:

SELECT
	p.product_name,
	s.quantity
FROM production.products as p
LEFT JOIN production.stocks as s
	ON p.product_id = s.product_id
	WHERE store_id is NULL

-- Task 55:

SELECT
	b.brand_name,
	p.product_id
FROM production.brands as b
LEFT JOIN production.products as p
	ON b.brand_id = p.brand_id
	WHERE product_id is NULL

-- Task 56:

SELECT
	p.product_name,
	oi.order_id
FROM production.products as p
LEFT JOIN sales.order_items as oi
	ON p.product_id = oi.product_id
	WHERE order_id is NULL

-- Task 57:

SELECT
	s.store_name
FROM sales.stores as s
LEFT JOIN sales.staffs as st
	ON s.store_id = st.store_id
	WHERE st.store_id is NULL

-- Task 58:

SELECT
	s.first_name + ' ' + s.last_name as staff_name
FROM sales.staffs as s
LEFT JOIN sales.orders as o
	ON s.staff_id = o.staff_id
	WHERE o.order_id is NULL

-- Task 59:

SELECT
	c.category_id,
	c.category_name
FROM production.categories as c
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) as expensive_categories
    ON c.category_id = expensive_categories.category_id
	WHERE expensive_categories.category_id is NULL

-- Task 60:

SELECT
	c.first_name + ' ' + c.last_name as customer_name
FROM sales.customers as c
INNER JOIN sales.orders as o
	ON c.customer_id = o.customer_id
LEFT JOIN (
	SELECT DISTINCT o2.customer_id
	FROM sales.orders as o2
	INNER JOIN sales.order_items as oi
		ON o2.order_id = oi.order_id
	INNER JOIN production.products as p
		ON p.product_id = oi.product_id
	INNER JOIN production.brands as b
		ON p.brand_id = b.brand_id
		WHERE b.brand_name = 'Trek'
) as trek_buyers
	ON c.customer_id = trek_buyers.customer_id
	WHERE trek_buyers.customer_id is NULL