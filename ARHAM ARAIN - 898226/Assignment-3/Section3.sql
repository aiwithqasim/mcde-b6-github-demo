-- SECTION 3: JOINS

-- Task 12: Display each product with its corresponding brand name and category name.
select p.product_name,b.brand_name,c.category_name
from production.products as p
join production.brands as b 
on p.brand_id=b.brand_id 
join production.categories as
c on c.category_id=p.category_id;


-- Task 13: Display all orders along with the customer's full name, order date, and order status.
select c.first_name+ ' '+c.last_name as fullname,o.order_date,o.order_status
from sales.customers as c join sales.orders as o
on c.customer_id=o.customer_id;


-- Task 14: Display each order item with its product name, product ID, quantity, list price, and discount.
select p.product_name,p.product_id,oi.quantity,oi.list_price,oi.discount
from production.products as p join sales.order_items as oi
on p.product_id=oi.product_id;


-- Task 15: Display each staff member's full name along with their store name.
select stf.first_name+' '+stf.last_name as fullname, sto.store_name 
from sales.staffs as stf join sales.stores as sto 
on stf.store_id=sto.store_id;


-- Task 16: Display each staff member's full name along with their manager's full name.
select s.first_name+' '+s.last_name as staff_memeber,
m.first_name+' '+m.last_name as manager_name
from sales.staffs as s left join sales.staffs as m
on s.manager_id=m.staff_id;


-- Task 17: Display all stores and the products they currently have in stock.
-- Only include products where the available quantity is greater than 0.
select  sto.store_name,
        p.product_name,
        stoc.quantity
    from sales.stores as sto
    join production.stocks as stoc on sto.store_id = stoc.store_id
    join production.products as p on stoc.product_id = p.product_id
    where stoc.quantity > 0;


-- Task 18: Display all customers who have placed at least one order,
-- along with their full name and order date.
select c.first_name + ' ' + c.last_name as customer_name,
o.order_date
from sales.customers as c
inner join sales.orders as o 
on c.customer_id = o.customer_id;


-- Task 19: Display all customers along with their orders, if any.
-- Customers who have never placed an order should also be included.
-- Their order information will appear as NULL.
select c.first_name + ' ' + c.last_name as customer_name,
o.order_status,o.order_id
from sales.customers as c
left join sales.orders as o 
on c.customer_id = o.customer_id;