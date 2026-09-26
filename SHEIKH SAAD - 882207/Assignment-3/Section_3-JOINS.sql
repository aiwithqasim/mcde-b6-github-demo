--TASK-12
SELECT 
	p.product_id,
	p.product_name,
	b.brand_name,
	c.category_name
FROM production.products AS p
INNER JOIN production.brands AS b ON p.brand_id = b.brand_id
INNER JOIN production.categories AS c ON p.category_id = c.category_id
ORDER BY p.product_name ASC;

--TASK-13
SELECT 
	o.order_id,
	c.first_name + ' ' + c.last_name AS customer_full_Name,
	o.order_date,
	o.order_status
FROM sales.orders AS o
INNER JOIN sales.customers AS c ON o.customer_id = c.customer_id;

--TASK-14
SELECT 
	oi.order_id,
	oi.item_id,
	pp.product_name,
	oi.quantity,
	oi.list_price,
	oi.discount
FROM sales.order_items AS oi
INNER JOIN production.products AS pp
ON oi.product_id = pp.product_id;

--TASK-15
SELECT 
	st.staff_id,
	st.first_name+' '+st.last_name AS Staff_Full_Name,
	s.store_name
FROM sales.staffs AS st
INNER JOIN sales.stores AS s 
ON st.store_id = s.store_id;

--TASK-16
SELECT 
	st.first_name+' '+st.last_name as staff_name,
	m.first_name+' '+m.last_name as manager_name
FROM sales.staffs AS st
INNER JOIN sales.staffs AS m
ON m.staff_id = st.manager_id;

--TASK-17
SELECT 
	st.store_name,
	p.product_name,
	pst.quantity
FROM production.stocks AS pst
INNER JOIN sales.stores AS st ON pst.store_id = st.store_id
INNER JOIN production.products AS p ON pst.product_id = p.product_id
WHERE pst.quantity > 0
ORDER BY st.store_name, p.product_name;

--TASK-18
SELECT 
	o.order_id,
	c.first_name+' '+c.last_name AS customer_name,
	o.order_date
FROM sales.customers AS c
INNER JOIN sales.orders AS o
ON c.customer_id = o.customer_id
ORDER BY o.order_id;

--TASK-19
SELECT 
	c.customer_id,
	c.first_name+' '+c.last_name AS customer_name,
	o.order_id,
	o.order_date
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
ON c.customer_id = o.customer_id
ORDER BY o.customer_id;