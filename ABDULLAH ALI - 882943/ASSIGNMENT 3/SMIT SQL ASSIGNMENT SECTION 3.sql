						-----SECTION 3-----  

--TASK 1;

SELECT PP.product_name, PB.brand_name, pc.category_name
FROM production.products AS PP
INNER JOIN production.brands AS PB
on PP.brand_id = pb.brand_id
INNER JOIN production.categories AS PC 
ON pp.category_id = pc.category_id

--TASK 2;

SELECT SC.first_name + ' ' + SC.last_name AS FULL_NAME, so.order_date, so.order_status
FROM sales.customers AS SC
INNER JOIN sales.orders AS SO
ON sc.customer_id = so.customer_id

--TASK 3;

SELECT pp.product_name,oi.quantity,oi.list_price,oi.discount
FROM production.products AS PP
INNER JOIN sales.order_items AS oi
ON pp.product_id = oi.product_id

--TASK 4;
	SELECT staffs.first_name + ' ' + staffs.last_name AS FULL_NAME, stores.store_name 
	FROM sales.staffs AS staffs
	inner join sales.stores as stores
	ON staffs.store_id = stores.store_id

--TASK 5;

SELECT staff1.first_name + ' ' + staff1.last_name AS employee,
       staff2.first_name + ' ' + staff2.last_name AS manager
FROM sales.staffs AS staff1
left join sales.staffs as staff2
ON staff2.staff_id = staff1.manager_id;

--TASK 6;
SELECT stocks.quantity, ss.store_name,p.product_name
from production.stocks as stocks
inner join sales.stores as ss
ON stocks.store_id = ss.store_id
inner join production.products as p
ON stocks.product_id = p.product_id
where stocks.quantity > 0;

--TASK 7;
SELECT cust.first_name,cust.last_name,orders.order_date
FROM sales.customers AS cust
inner join sales.orders AS orders
ON cust.customer_id = orders.customer_id

--TASK 8;
SELECT cust.first_name,cust.last_name,orders.order_date
FROM sales.customers AS cust
left join sales.orders AS orders
ON cust.customer_id = orders.customer_id

-------------------------------------------------------------------