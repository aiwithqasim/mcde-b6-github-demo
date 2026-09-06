use bikestores;

--Task 12:  List every product along with its brand name and category name

select p.product_name,
b.brand_name,
c.category_name
from production.products as p
join production.brands as b
on p.brand_id = b.brand_id
join production.categories as c
on p.category_id = c.category_id;

--Task 13:  List all orders with the customer's full name (first_name + last_name), order date, and order status.

select 
    c.first_name + ' ' + c.last_name as full_name,
    o.order_date,
    o.order_status
from sales.orders as o
inner join sales.customers as c
on o.customer_id = c.customer_id;

--Show every order item with the product name, quantity, list price, and discount.

select 
    p.product_name,
    oi.quantity,
    oi.list_price,
    oi.discount
from sales.order_items as oi
inner join production.products as p
on oi.product_id = p.product_id;

--Task 15:  List each staff member's full name alongside their store name.

select 
    s.first_name + ' ' + s.last_name as full_name,
    st.store_name
from sales.staffs as s
inner join sales.stores as st
on s.store_id = st.store_id;

--Task 16:  List staff members along with their manager's full name.

select 
    s.first_name + ' ' + s.last_name as staff_name,
    m.first_name + ' ' + m.last_name as manager_name
from sales.staffs as s
join sales.staffs as m
on s.manager_id = m.staff_id;

--Task 17:  Show all stores and the products they have in stock, including the product name and quantity. Only show items where quantity > 0.

select 
    st.store_name,
    p.product_name,
    s.quantity
from production.stocks as s
inner join sales.stores as st
    on s.store_id = st.store_id
inner join production.products as p
    on s.product_id = p.product_id
where s.quantity > 0;

--Task 18:  List all customers who placed at least one order. Show customer name and order date

select 
    c.first_name + ' ' + c.last_name as customer_name,
    o.order_date
from sales.customers as c
inner join sales.orders as o
on c.customer_id = o.customer_id;

--Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.

select 
    c.first_name + ' ' + c.last_name as customer_name,
    o.order_date
from sales.customers as c
left join sales.orders as o
on c.customer_id = o.customer_id;