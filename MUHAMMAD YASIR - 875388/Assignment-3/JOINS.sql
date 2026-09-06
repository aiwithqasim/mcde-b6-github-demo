--Task 12:  List every product along with its brand name and category name.

select p.product_name,b.brand_name,c.category_name
from production.products p
join production.brands b 
on p.brand_id=b.brand_id 
join production.categories c
on c.category_id=p.category_id;

--Task 13:  List all orders with the customer's full name (first_name + last_name), order date, and order status.
select c.first_name+ ' '+c.last_name as fullname,o.order_date,o.order_status
from sales.customers c
join sales.orders  o
on c.customer_id=o.customer_id


--Task 14:  Show every order item with the product name, quantity, list price, and discount.
select p.product_name,p.product_id,oi.quantity,oi.list_price,oi.discount
from production.products p join sales.order_items oi
on p.product_id=oi.product_id

--Task 15:  List each staff member's full name alongside their store name.
select stf.first_name+' '+stf.last_name as fullname, sto.store_name 
from sales.staffs stf join sales.stores sto 
on stf.store_id=sto.store_id;

--Task 16:  List staff members along with their manager's full name.
select s.first_name+' '+s.last_name as staff_memeber,
m.first_name+' '+m.last_name as manager_name
from sales.staffs s left join sales.staffs m
on s.manager_id=m.staff_id;

--Task 17:  Show all stores and the products they have in stock, including the product name and quantity. Only show items where quantity > 0.
select  sto.store_name,
        p.product_name,
        stoc.quantity
from sales.stores sto
join production.stocks stoc on sto.store_id = stoc.store_id
join production.products p on stoc.product_id = p.product_id
where stoc.quantity > 0;


--Task 18:  List all customers who placed at least one order. Show customer name and order date.
select c.first_name + ' ' + c.last_name as customer_name,
o.order_date
from sales.customers c
inner join sales.orders o 
on c.customer_id = o.customer_id;


--Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.

select c.first_name + ' ' + c.last_name as customer_name,
o.order_status,o.order_id
from sales.customers c
left join sales.orders o 
on c.customer_id = o.customer_id;
