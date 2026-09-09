use BikeStores;
Go

--Task 12:  List every product along with its brand name and category name.
--Hint: JOIN production.products with production.brands and production.categories.

select p.product_name,
	b.brand_name,
	c.category_name
from production.products as p
inner join production.brands as b
on	p.brand_id = b.brand_id
inner join production.categories as c
on p.category_id = c.category_id;




--Task 13: List all orders with the customer's full name (first_name + last_name),
-- order date, and order status.

select c.first_name +' '+ c.last_name as full_name,
	o.order_date,
	o.order_status
from sales.customers as c
inner join sales.orders as o
on c.customer_id = o.customer_id ;


--Task 14:  Show every order item with the 
-- product name, quantity, list price, and discount.

select p.product_name,
	oi.quantity,
	oi.list_price,
	oi.discount
from production.products as p
inner join sales.order_items as oi
on p.product_id = oi.product_id
order by oi.discount;


-- Task 15:  List each staff member's full name 
-- alongside their store name.


select st.first_name +' '+ st.last_name as full_name,
	s.store_name
from sales.staffs as st
inner join sales.stores as s
on st.store_id = s.store_id;


--Task 16:  List staff members along with their
-- manager's full name.
--Hint: Use a self-join on the sales.staffs table
-- using manager_id.


select c.first_name + ' '+ c.last_name as Staff_name,
	m.first_name + ' '+ m.last_name as Manager_name
from sales.staffs as c
join sales.staffs as m
on c.manager_id = m.manager_id;



-- Task 17:  Show all stores and the products they have in stock,
-- including the product name and quantity. Only show items where quantity > 0.

select st.store_name,
	p.product_name,
	stk.quantity
from production.products as p
inner join production.stocks as stk
on p.product_id = stk.product_id
inner join production.stores as st
on stk.store_id = st.store_id
where stk.quantity > 0;


--Task 18:  List all customers who placed at least one order. Show customer name and order date.
--Hint: An INNER JOIN naturally eliminates non-ordering customers.

select 
	c.first_name + ' '+ c.last_name as Customer_name,
	o.order_date
from sales.customers as c
inner join sales.orders as o
on c.customer_id = o.customer_id;


--Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.
--Hint: Use a LEFT JOIN

select 
	c.first_name + ' '+ c.last_name as Customer_name,
	o.order_status
from sales.customers as c
left join sales.orders as o
on c.customer_id = o.customer_id
order by order_status desc;
