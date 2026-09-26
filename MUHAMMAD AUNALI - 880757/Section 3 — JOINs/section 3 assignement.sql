use BikeStores

--task 12
select p.product_name, b.brand_name, c.category_name from production.products as p 
join production.brands as b 
  ON p.brand_id = b.brand_id 
join production.categories as c 
  on p.category_id = c.category_id;

  --task13
select c.first_name + ' ' + c.last_name as full_name,o.order_date, o.order_status 
from sales.customers as c 
inner join  sales.orders as o 
on c.customer_id = o.customer_id;

--task 14
	select p.product_name, oi.quantity, oi.list_price, oi.discount 
	from production.products as p 
	inner join sales.order_items as oi 
	on p.list_price = oi.list_price;

--task 15
select sta.first_name + ' ' + sta.last_name as full_name, sto.store_name 
from sales.staffs as sta 
join sales.stores as sto 
on sta.store_id = sto.store_id;

--task 16
select  e.staff_id,e.first_name as employee_name, m.first_name as manager, m.staff_id as manager_id 
from sales.staffs as  e 
left join sales.staffs as m 
on e.manager_id = m.staff_id 
order by manager_id asc;

--task 17
select st.store_name, s.quantity, p.product_name 
from production.stocks as s 
inner join sales.stores as st 
on s.store_id = st.store_id 
inner join production.products as p
on s.product_id = p.product_id where s.quantity > 0;

--task 18
select c.first_name + ' ' + c.last_name as customer_name, o.order_date from sales.customers as c
inner join sales.orders as o 
on c.customer_id = o.customer_id;

--task 19
select c.first_name + ' ' + c.last_name as customer_name, o.order_id from sales.customers as c
left join sales.orders as o 
on c.customer_id = o.customer_id;

