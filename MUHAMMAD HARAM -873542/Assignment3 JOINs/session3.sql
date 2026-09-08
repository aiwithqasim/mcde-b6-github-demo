-- JOINS
-- task 12
select 
    pp.product_name,
    pb.brand_name,
    pc.category_name
from [production].[products] as pp
inner join [production].[brands] as pb on pp.brand_id = pb.brand_id
inner join [production].[categories] as pc on pp.category_id = pc.category_id

--task 13 
select 
so.order_id,
sc.first_name + ' ' + sc.last_name as full_name,
so.order_date,
so.order_status
from [sales].[orders] as so
left join [sales].[customers] as sc on so.customer_id = sc.customer_id

--task 14
select
pp.product_name,
soi.quantity,
soi.list_price,
soi.discount
from [sales].[order_items] as soi
left join [production].[products] as pp on soi.product_id = pp.product_id


--task 15
select
ssf.first_name + ' ' + ssf.last_name as full_name,
sst.store_name
from [sales].[staffs] as ssf
left join [sales].[stores] as sst on ssf.store_id = sst.store_id

-- task 16
select 
e.first_name + ' ' + e.last_name as employee,
m.first_name + ' ' + m.last_name as manager
from sales.staffs as e
left join sales.staffs as m on e.manager_id = m.staff_id

-- task 17
select 
ss.store_name,
ps.product_id,
pp.product_name,
ps.quantity
from sales.stores as ss
left join production.stocks as ps 
    on ss.store_id = ps.store_id and ps.quantity > 0
left join production.products as pp 
    on ps.product_id = pp.product_id

--task 18
select 
sc.first_name + ' ' + sc.last_name as full_name,
so.order_date
from sales.customers as sc 
inner join sales.orders as so
    on sc.customer_id = so.customer_id


--task 19
select 
sc.first_name + ' ' + sc.last_name as full_name,
order_id,
order_status
from sales.customers as sc 
left join sales.orders as so 
    on sc.customer_id = so.customer_id