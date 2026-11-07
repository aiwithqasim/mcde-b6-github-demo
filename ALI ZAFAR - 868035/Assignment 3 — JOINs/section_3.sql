
--TASK - 12
SELECT 
	p.product_name,
	b.brand_name,
	c.category_name
FROM production.products AS p
INNER JOIN production.brands AS b 
on p.brand_id = b.brand_id
INNER JOIN production.categories AS c
ON p.category_id = c.category_id;


--TASK - 13
SELECT 
	c.first_name + ' ' + c.last_name AS full_name,
	o.order_date,
	o.order_status
FROM sales.customers AS c
INNER JOIN sales.orders AS o
ON c.customer_id = o.customer_id


--TASK - 14
SELECT
	p.product_name,
	o.quantity,
	o.list_price,
	o.discount
FROM production.products AS p
INNER JOIN sales.order_items AS o
ON p.product_id = o.product_id


--TASK -15
SELECT
	st.first_name + ' ' + st.last_name AS full_name,
	sto.store_name
FROM sales.staffs AS st
INNER JOIN sales.stores AS sto
ON  st.store_id = sto.store_id;



--TASK -16
SELECT
    e.first_name + ' ' + e.last_name AS employee,
    m.first_name + ' ' + m.last_name AS manager
FROM sales.staffs AS e
LEFT JOIN sales.staffs AS m
    ON e.manager_id = m.staff_id;



	--TASK - 17
		SELECT 
			store_name,
			p.product_name,
			ps.quantity
		FROM production.stocks AS ps
		LEFT JOIN sales.stores AS ss
		ON ps.store_id = ss.store_id
		INNER JOIN production.products AS p
		ON  ps.product_id = p.product_id
		WHERE quantity > 0;



--TASK - 18
	SELECT 
		c.first_name+ ' ' + c.last_name AS Full_name,
		o.order_date
	FROM sales.customers AS C
	INNER JOIN sales.orders AS o
	ON c.customer_id = o.customer_id

--TASK - 19
SELECT
    c.first_name + ' ' + c.last_name AS Full_name,
    o.order_status
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id;