--Section 3 — JOINs

--Task 12:  List every product along with its brand name and category name.
--Hint: JOIN production.products with production.brands and production.categories.

select 
p.product_name,
b.brand_name,
c.category_name
from production.products as p
join production.brands as b on p.brand_id = b.brand_id
join production.categories as c on p.category_id = c.category_id;

--Task 13:  List all orders with the customer's full name (first_name + last_name), order date, and order status.

select c.first_name + ' ' + c.last_name AS full_name,
o.order_date,
o.order_status
from sales.orders o
join sales.customers c on o.customer_id = c.customer_id;

--Task 14:  Show every order item with the product name, quantity, list price, and discount.

select 
p.product_name,
oi.quantity,
oi.list_price,
oi.discount
from sales.order_items oi
join production.products p on oi.product_id = p.product_id;

--Task 15:  List each staff member's full name alongside their store name.

select st.first_name + ' ' + st.last_name as full_name,
	s.store_name
from sales.staffs st
join sales.stores s on st.store_id = s.store_id;	

--Task 16:  List staff members along with their manager's full name.
--Hint: Use a self-join on the sales.staffs table using manager_id.


select 
s.staff_id,
s.first_name + ' ' + s.last_name as employee_name,
m.first_name + ' ' + m.last_name as manager_name
from sales.staffs s
left join sales.staffs m on s.manager_id = m.staff_id;


--Task 17:  Show all stores and the products they have in stock, including the product name and quantity. Only show items where quantity > 0.

select
	st.store_name,
	p.product_name,
	s.quantity
from sales.stores st
join production.stocks s on st.store_id = s.store_id
join production.products p on s.product_id = p.product_id
where s.quantity > 0;

--Task 18:  List all customers who placed at least one order. Show customer name and order date.
--Hint: An INNER JOIN naturally eliminates non-ordering customers.

select c.first_name + ' ' + c.last_name as customer_name,
	s.order_date
from sales.customers c 
inner join sales.orders s on c.customer_id = s.customer_id;


--Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.
--Hint: Use a LEFT JOIN.

select 
c.customer_id,
c.first_name + ' ' + c.last_name as customer_name,
s.order_id,
s.order_date
from sales.customers c
left join sales.orders s on c.customer_id = s.customer_id;
