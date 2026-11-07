--Task 12: List every product along with its brand name and category name
--Hint: JOIN production.products with production.brands and production.categories
use BikeStores;
go
select p.product_name, b.brand_name, c.category_name
from production.products p
join production.categories c ON p.category_id = c.category_id 
join production.brands b ON p.brand_id = b.brand_id;

--Task 13: List all orders with customer's full name (first_name + last_name),
--order date and order status
use BikeStores;
go
select first_name + ' ' + last_name AS customer_name, order_date, order_status 
from sales.customers c
join sales.orders o ON c.customer_id = o.customer_id;

--Task 14: Show every order item with the product name, quantity, list price
--and discount
use BikeStores;
go
select p.product_name, oi.quantity, oi.list_price, 
CONCAT(CAST(oi.discount * 100 as int), '%') AS discount
from sales.order_items oi
inner join production.products p
ON p.product_id = oi.product_id;


--Task 15: List each staff member's full name alongside their store name
use BikeStores;
go
select stf.first_name + ' ' + stf.last_name AS Staff_Full_Name, sto.store_name
from sales.staffs stf
join sales.stores sto
ON stf.store_id = sto.store_id;


--Task 16: List staff members along with their manager's full name
--Hint: Use a self-join on the sales.staff table using manager_id
use BikeStores;
go
select st.first_name + ' ' + st.last_name AS staff,
stf.first_name + ' ' + stf.last_name AS manager
from sales.staffs st
left join sales.staffs stf
ON st.manager_id = stf.staff_id;


--Task 17: Show all stores and the products they have in stock including the product
--name and quantity. Only show items where quantity > 0
use BikeStores;
go
select s.store_id, s.store_name, pd.product_name, st.quantity
from sales.stores s
join production.stocks st ON s.store_id = st.store_id
join production.products pd ON st.product_id = pd.product_id
where st.quantity > 0;

--Task 18: List all customers who placed atleast one order. Show customer name
--and order date
--Hint: an INNER JOIN naturally eliminates non-ordering customers
use BikeStores;
go
select c.first_name + ' ' + c.last_name AS customer_name, o.order_date
from sales.customers C
inner join sales.orders O 
ON c.customer_id = o.customer_id;

--Task 19: List all customers and their orders (if any). customers who never ordered
--should still appear with NULL order data
--Hint: Use a LEFT JOIN
use BikeStores;
go
 select 
 c.customer_id, c.first_name + ' ' + c.last_name AS customer_name,
 o.order_id, o.order_date
 from sales.customers c
 left join sales.orders o
 ON c.customer_id = o.customer_id;

