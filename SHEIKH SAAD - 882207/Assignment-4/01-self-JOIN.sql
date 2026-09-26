USE [bikestores];
go

--TASK-41

SELECT 
 e.first_name + ' ' + e.last_name AS staff_Member,
 m.first_name + ' ' + m.last_name AS Manager
FROM sales.staffs AS e 
 LEFT JOIN sales.staffs AS m 
 ON  m.staff_id = e.manager_id;

--TASK-42

SELECT DISTINCT
	b.brand_name,
	p1.product_name product_1,
	p2.product_name product_2,
	p1.list_price shared_price
FROM production.products AS p1
INNER JOIN production.products AS p2 ON p1.brand_id = p2.brand_id
  AND p1.list_price = p2.list_price AND p1.product_id < p2.product_id
INNER JOIN production.brands AS b 
	ON p1.brand_id = b.brand_id
ORDER BY
	b.brand_name,
	p1.list_price DESC;

-- TASK-43

SELECT DISTINCT
	c1.first_name+' '+c1.last_name customer_1,
	c2.first_name+' '+c2.last_name customer_2,
	c1.city,
	c1.state
FROM sales.customers as c1
INNER JOIN sales.customers as c2
	ON c1.city = c2.city
    AND c1.state = c2.state
    AND c1.customer_id < c2.customer_id
ORDER BY
	customer_1,
	city,
	state;

--TASK-44

SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS staff_member,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    s.store_name
FROM 
    sales.staffs e
INNER JOIN 
    sales.staffs m 
    ON e.manager_id = m.staff_id 
   AND e.store_id = m.store_id
INNER JOIN 
    sales.stores s 
    ON e.store_id = s.store_id
ORDER BY 
    s.store_name, 
    staff_member;

