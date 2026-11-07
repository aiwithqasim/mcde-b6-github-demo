 --secton 3
 --Task 12:  List every product along with its brand name and category name.
--Hint: JOIN production.products with production.brands and production.categories.

 select 
 p.product_name, 
 c.category_name,
 b.brand_name
 from production.products as p 
 inner join production.categories as c
 on p.category_id = c.category_id
 inner join production.brands as b
 on p.brand_id = b.brand_id;

 --Task 13:  List all orders with the customer's full name (first_name + last_name), order date, and order status.
 select 
 c.first_name +' '+ c.last_name as full_name,
 o.order_date,
 o.order_status
 from sales.customers as c
 inner join sales.orders as o
 on c.customer_id = o.customer_id;
 
 --Task 14:  Show every order item with the product name, quantity, list price, and discount.
 select 
 p.product_name,
 o.quantity,
 o.list_price,
 o.discount
 from sales.order_items as o
 inner join production.products as p
 on o.product_id = p.product_id;

 --Task 15:  List each staff member's full name alongside their store name.

 select 
 stf.first_name + ' '+stf.last_name as full_name,
 sto.store_name from sales.staffs as stf
 inner join sales.stores as sto 
 on stf.store_id = sto.store_id;

 --Task 16:  List staff members along with their manager's full name.
--Hint: Use a self-join on the sales.staffs table using manager_id.

select
e.first_name + ' '+ e.last_name as Employee,
m.first_name + ' '+ m.last_name as Manager
from [sales].[staffs] as e
Inner join [sales].[staffs] as m
on e.manager_id = m.staff_id;

--Task 17:  Show all stores and the products they have in stock, including the product name and quantity. 
--Only show items where quantity > 0.

select 
sto.store_name,pd.product_name,stc.quantity
from sales.stores as sto
inner join production.stocks as stc
on sto.store_id = stc.store_id
inner join production.products as pd
on stc.product_id = pd.product_id
where stc.quantity > 0;

--Task 18:  List all customers who placed at least one order. Show customer name and order date.
--Hint: An INNER JOIN naturally eliminates non-ordering customers.

select
cs.first_name + ' ' + cs.last_name as full_name, ord.order_date
from sales.customers as cs
inner join sales.orders as ord
on cs.customer_id = ord.customer_id;

--Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.
--Hint: Use a LEFT JOIN.
select
cs.customer_id,cs.first_name + ' ' + cs.last_name as full_name,ord.order_status, ord.order_date
from sales.customers as cs
left join sales.orders as ord
on cs.customer_id = ord.customer_id;