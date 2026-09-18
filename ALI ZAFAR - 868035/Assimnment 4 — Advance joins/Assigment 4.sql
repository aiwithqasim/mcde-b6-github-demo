 
-- SELF JOIN TASK  
--TASK - 41
SELECT
	s.first_name + ' ' +s.last_name AS staff_name,
	m.first_name + ' '+m.last_name AS manger_name
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
	ON s.manager_id = m.staff_id


--TASK - 42
SELECT
	*
FROM sales.customers AS c1
INNER JOIN sales.customers AS c2
	on c1.city = c2.city
	AND c1.customer_id < c2.customer_id;
	 

--TASK - 43
SELECT 
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name,
    s.store_id
FROM 
    sales.staffs AS s
INNER JOIN 
    sales.staffs AS m 
    ON s.manager_id = m.staff_id
   AND s.store_id = m.store_id;


-- TASK - 44
 
SELECT s.first_name, s.last_name
FROM sales.staffs s
JOIN sales.staffs m ON s.manager_id = m.staff_id
WHERE s.store_id = m.store_id;


-- CROSS JOINS

-- TASK - 45
 
SELECT b.brand_name, c.category_name
FROM production.brands b
CROSS JOIN production.categories c;

-- TASK - 46
 
SELECT b.brand_name, c.category_name
FROM production.brands b
CROSS JOIN production.categories c
LEFT JOIN production.products p 
    ON b.brand_id = p.brand_id AND c.category_id = p.category_id
WHERE p.product_id IS NULL;

-- TASK - 47
 
SELECT st.store_name, p.product_name, ISNULL(s.quantity, 0) AS stock_quantity
FROM sales.stores st
CROSS JOIN production.products p
LEFT JOIN production.stocks s 
    ON st.store_id = s.store_id AND p.product_id = s.product_id;

-- TASK - 48
 
SELECT stf.staff_id, sto.store_id,
       CASE WHEN stf.store_id = sto.store_id THEN 'Yes' ELSE 'No' END AS is_current_assignment
FROM sales.staffs stf
CROSS JOIN sales.stores sto;


-- RIGHT JOINS

-- TASK - 49
 
SELECT b.brand_name, p.product_name
FROM production.products p
RIGHT JOIN production.brands b ON p.brand_id = b.brand_id;

-- TASK - 50
 
SELECT s.store_name, o.order_id
FROM sales.orders o
RIGHT JOIN sales.stores s ON o.store_id = s.store_id;

-- TASK - 51
 
SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM production.products p
RIGHT JOIN production.categories c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name;

-- TASK - 52
 
SELECT st.first_name, st.last_name, o.order_id
FROM sales.orders o
RIGHT JOIN sales.staffs st ON o.staff_id = st.staff_id;


-- LEFT ANTI JOIN 

-- TASK - 53
 
SELECT c.customer_id, c.first_name, c.last_name
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- TASK - 54
 
SELECT p.product_id, p.product_name
FROM production.products p
LEFT JOIN production.stocks s ON p.product_id = s.product_id
WHERE s.store_id IS NULL;

-- TASK - 55
 
SELECT b.brand_id, b.brand_name
FROM production.brands b
LEFT JOIN production.products p ON b.brand_id = p.brand_id
WHERE p.product_id IS NULL;

-- TASK - 56
 
SELECT p.product_id, p.product_name
FROM production.products p
LEFT JOIN sales.order_items oi ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

-- TASK - 57
 
SELECT s.store_id, s.store_name
FROM sales.stores s
LEFT JOIN sales.staffs st ON s.store_id = st.store_id
WHERE st.staff_id IS NULL;

-- TASK - 58
 
SELECT st.staff_id, st.first_name, st.last_name
FROM sales.staffs st
LEFT JOIN sales.orders o ON st.staff_id = o.staff_id
WHERE o.order_id IS NULL;

-- TASK - 59
 
SELECT category_id, category_name
FROM production.categories
WHERE category_id NOT IN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
);

-- TASK - 60
 
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
WHERE c.customer_id NOT IN (
    SELECT DISTINCT o2.customer_id
    FROM sales.orders o2
    JOIN sales.order_items oi ON o2.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.brands b ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
);