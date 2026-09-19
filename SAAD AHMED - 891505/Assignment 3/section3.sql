--Section 3 — JOINs
--Task 12:  List every product along with its brand name and category name.
--Hint: JOIN production.products with production.brands and production.categories.
SELECT brand_name, category_name from production.products p 
join production.brands b on p.brand_id = b.brand_id
join production.categories c on p.category_id = c.category_id

--Task 13:  List all orders with the customer's full name (first_name + last_name), order date, and order status.
Select c.first_name + ' ' + c.last_name, o.order_id, o.order_date, o.order_status 
from sales.orders o join sales.customers c on o.customer_id = c.customer_id

--Task 14:  Show every order item with the product name, quantity, list price, and discount.
SELECT
   o.item_id,
   p.product_name,
   o.quantity,
   o.list_price,
   o.discount
FROM sales.order_items o
JOIN production.products p
   ON o.product_id = p.product_id

--Task 15:  List each staff member's full name alongside their store name
Select first_name + ' ' + last_name as full_name, store_name from sales.staffs staff join sales.stores store on staff.store_id = store.store_id

--Task 16:  List staff members along with their manager's full name.
--Hint: Use a self-join on the sales.staffs table using manager_id.
Select s1.first_name + ' ' + s1.last_name as staff_name, s2.first_name + ' ' + s2.last_name as manager_name
from sales.staffs s1 join sales.staffs as s2 on s1.staff_id = s2.manager_id

--Task 17:  Show all stores and the products they have in stock, including the product name and quantity. Only show items where quantity > 0.
select s1.store_id, s2.store_name, s1.product_id, s1.quantity
from production.stocks as s1 join sales.stores as s2 on s1.store_id = s2.store_id join
production.products as p on p.product_id = s1.product_id where quantity > 0

--Task 18:  List all customers who placed at least one order. Show customer name and order date.
--Hint: An INNER JOIN naturally eliminates non-ordering customers
select c.customer_id, c.first_name + ' ' + c.last_name as customer_name , o.order_date 
from sales.customers as c join sales.orders as o on c.customer_id = o.customer_id

--Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.
--Hint: Use a LEFT JOIN.
select c.customer_id, c.first_name + ' ' + c.last_name as customer_name, o.order_date 
from sales.customers as c left join sales.orders as o on c.customer_id = o.customer_id