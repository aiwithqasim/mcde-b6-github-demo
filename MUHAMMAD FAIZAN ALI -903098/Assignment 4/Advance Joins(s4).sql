use BikeStores;
Go
-- || Self Join ||
-- Task 41: List each staff member alongside their manager's full name. If a staff member has no manager (top-level),
-- still show them with NULL for manager name.

select 
	s.first_name + ' '+ s.last_name as Staff_name,
	m.first_name + ' ' + m.last_name as manager_name
from sales.staffs as s
left join sales.staffs as m
	on s.manager_id = m.staff_id;


-- Task 42: Find pairs of products from the
-- same brand that have the exact same list price.
-- Show both product names and the brand name.

select 
	p.product_name as Product_1,
	p1.product_name as Product_2,
	p.list_price,
	b.brand_name
from production.products as p 
left join production.products as p1
on p.brand_id = p1.brand_id 
AND p.list_price = p1.list_price
AND p.product_id < p1.product_id
inner join production.brands as b
	on p.brand_id = b.brand_id;


--Task 43: Find all pairs of customers who live in the same
--city and state.Avoid duplicates (don't show A-B and B-A both).

select 
	c.first_name + ' ' + c.last_name as Customer_1,
	c1.first_name + ' ' + c1.last_name as Customer_2,
	c.city,
	c.state
from sales.customers as c
inner join sales.customers as c1
on c.state = c1.state
And c.city = c1.city
And c.customer_id < c1.customer_id;


-- Task 44: List staff members
-- who were hired at the same store as their manager.

select 
	s.first_name + ' ' + s.last_name as staff_name,
	m.first_name + ' ' + m.last_name as manager_name,
	s.store_id
from sales.staffs as s
inner join sales.staffs as m
on s.manager_id = m.staff_id
AND s.store_id = m.store_id;


--|| Cross Join ||
-- Task 45: Generate a list of every possible combination of 
-- brand and category. Show brand name and category name.

select 
	b.brand_name as Brand_name,
	c.category_name as Category_name
from production.brands as b
cross join production.categories as c;


-- Task 46: Using the result of a CROSS JOIN between brands and categories,
-- find brand-category combinations that have NO products
-- (LEFT JOIN thecross join result against products and filter for NULLs).

select 
	b.brand_name,
	c.category_name
from production.brands as b
cross join production.categories as c 
left join production.products as p
ON p.brand_id = b.brand_id AND p.category_id = c.category_id
where p.product_id is NULL;


-- Task 47: Generate a report showing every store paired with
-- every product,along with the stock quantity.
-- If a store doesn't carry a product, show 0.
-- Hint: CROSS JOIN stores with products,
-- then LEFT JOIN with production.stocks.


select 
	p.product_name,
	st.store_name,
	isnull(s.quantity,0) as quantity
from production.products as p
cross join sales.stores as st
left join production.stocks as s
on s.product_id = p.product_id
AND s.store_id = st.store_id;



--Task 48: Create all possible staff-store assignments
--(every staff paired with every store), 
--then show which ones are the actual current assignments.

select
	s.first_name + ' ' + s.last_name as Staff_name,
	st.store_name,
	IIF(s.store_id = st.store_id, 'Actual', 'Possible') 
from sales.staffs as s
cross join sales.stores as st
order by s.staff_id, st.store_id;



--Task 49: List all brands and the products that belong to them.
--Ensure ALL brands appear, even if they have no products.
--Use a RIGHT JOIN (products RIGHT JOIN brands).

select 
	p.product_name,
	b.brand_name
	from production.products as p
	right join production.brands as b
	on b.brand_id = p.brand_id;

--|| Right Join ||
--Task 50: Show all stores and the orders placed at each store.
--Use a RIGHT JOIN so that stores with zero orders still appear.

select
o.order_status,
s.store_name
from sales.orders as o
right join sales.stores as s
on o.store_id = s.store_id
order by o.order_status asc;


--Task 51: List all categories with their product count. Use a RIGHT
-- JOIN to ensure categories with no products show a count of 0.

select 
c.category_name,
count(p.product_id) as product_count
from production.categories as c
right join production.products as p
on c.category_id = p.category_id
group by c.category_name;


--Task 52: Show all staff members and the orders they handled.
--Use a RIGHT JOIN on orders RIGHT JOIN staffs,
--so staff who handled zero orders still appear.

select 
s.first_name +' '+ s.last_name as Staff_name,
count(o.order_id) as order_handled
from sales.orders as o
right join sales.staffs as s
on o.staff_id = s.staff_id
group by s.first_name +' '+ s.last_name;


--|| Left Anti Join (LEFT JOIN + WHERE IS NULL) ||
--Task 53: Find all customers who have NEVER placed an order.
select
	c.customer_id as Never_placed_an_order,
	c.first_name + ' '+ c.last_name as Customer_name,
	o.order_status
from sales.customers as c
left join sales.orders as o
on c.customer_id = o.customer_id
where o.order_id is NUll;


-- Task 54: Find all products that are NOT currently in stock
-- at ANY store. Hint: LEFT JOIN production.products with
-- production.stocks, filter WHERE store_id IS NULL.

select 
	p.product_name as products_that_are_NOT_currently_in_stock,
	p.product_id,
	s.quantity
from production.products as p
left join production.stocks as s
	on p.product_id = s.product_id
	AND s.quantity > 0
where s.store_id is NULL;


-- Task 55: Find brands that have NO products in the database.

select 
b.brand_name as NO_products_in_the_database
from production.brands as b
left join production.products as p
on b.brand_id = p.brand_id
where p.product_id is NULL;


--Task 56: Find all products that have never been ordered.
-- Hint: LEFT JOIN production.products with sales.order_items,
--filter WHERE order_id IS NULL.

select 
	p.product_name as Product_Never_Ordered
from production.products as p
left join sales.order_items as ot
	on p.product_id = ot.product_id
where order_id is NULL;


--Task 57: Find stores that have never had any staff 
--assigned to them.

select 
	s.store_name as Store_Without_Staff
from sales.stores as s
left join sales.staffs as st
	on s.store_id = st.store_id
where st.store_id is NULL;


-- Task 58: Find staff members who have never
-- handled a single order.

select 
	s.first_name +' '+ s.last_name as Staff_name
from sales.staffs as s
left join sales.orders as o
on s.staff_id = o.staff_id
where o.order_id is NULL;



-- Task 59: Find categories where no product has a
--- list price above 2000.
-- Hint: LEFT anti-join categories against a subquery
-- of categories that DO have products above 2000.

select 
c.category_name
from production.categories as c
left join production.products as p
on c.category_id = p.category_id 
group by c.category_id , c.category_name
having max(p.list_price) <= 2000;



-- Task 60: Find customers who placed orders but
-- never ordered any product from the brand 'Trek'.
-- Hint: This combines a regular join(customers who ordered) 
-- with a left anti pattern (never ordered Trek).

select  distinct
	c.first_name + ' '+ c.last_name as Customer_name
	from sales.customers as c
inner join sales.orders as o
	on c.customer_id = o.customer_id
left join (
	select distinct o.customer_id
	from sales.orders as o
	inner join sales.order_items as ot
	on o.order_id = ot.order_id
inner join production.products as p
	on ot.product_id = p.product_id
inner join production.brands as b
	on p.brand_id = b.brand_id
where b.brand_name = 'Trek')
as Trek_Orders
on c.customer_id = Trek_Orders.customer_id
where Trek_Orders.customer_id is NULL;
