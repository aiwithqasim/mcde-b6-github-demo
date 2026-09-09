--Self Join

--Task 41: List each staff member alongside their manager's full name. If a staff member has no manager (top-level), still show them with NULL for manager name.
select 
    s.first_name + ' ' + s.last_name as staff_member,
    m.first_name + ' ' + m.last_name as manager_name
from sales.staffs as s
LEFT JOIN sales.staffs as m 
    on s.manager_id = m.staff_id;
--Task 42: Find pairs of products from the same brand that have the exact same list price. Show both product names and the brand name.
select 
    p1.product_name as product_1,
    p2.product_name as product_2,
    b.brand_name,
    p1.list_price
from production.products as p1
join production.products as p2 
    on p1.brand_id = p2.brand_id 
   and p1.list_price = p2.list_price
   and p1.product_id < p2.product_id  
join production.brands as b 
    on p1.brand_id = b.brand_id;


--Cross Join



--Task 45: Generate a list of every possible combination of brand and category. Show brand name and category name.
--Hint: This is useful when you want to find which brand-category combos have no products.

select 
    b.brand_name,
    c.category_name
from production.brands as b
cross join production.categories as c;
--Task 46: Using the result of a CROSS JOIN between brands and categories, find brand-category combinations that have NO products (LEFT JOIN the cross join result against products and filter for NULLs).

select 
    b.brand_name,
    c.category_name
from production.brands as b
cross join production.categories as c
left join production.products as p 
    on b.brand_id = p.brand_id 
   and c.category_id = p.category_id
where p.product_id is null;


--Right Join

--Task 49: List all brands and the products that belong to them. Ensure ALL brands appear, even if they have no products. Use a RIGHT JOIN (products RIGHT JOIN brands).

select 
    b.brand_id,
    b.brand_name,
    p.product_id,
    p.product_name
from production.products as p
right join production.brands as b
    on p.brand_id = b.brand_id;

--Task 50: Show all stores and the orders placed at each store. Use a RIGHT JOIN so that stores with zero orders still appear.
select 
    s.store_id,
    s.store_name,
    o.order_id,
    o.order_date,
    o.order_status
from sales.orders as o
right join sales.stores as s
    on o.store_id = s.store_id;


--Left Anti Join (LEFT JOIN + WHERE IS NULL)

--Task 53: Find all customers who have NEVER placed an order.
--Hint: LEFT JOIN sales.customers with sales.orders, then filter WHERE order_id IS NULL.
select 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    o.order_id
from sales.customers as c
left join sales.orders as o 
    on c.customer_id = o.customer_id
where o.order_id is null;

--Task 54: Find all products that are NOT currently in stock at ANY store.
--Hint: LEFT JOIN production.products with production.stocks, filter WHERE store_id IS NULL.
select 
    p.product_id,
    p.product_name
from production.products as p
left join production.stocks as s 
    on p.product_id = s.product_id
where s.store_id is null;

--Task 56: Find all products that have never been ordered.
--Hint: LEFT JOIN production.products with sales.order_items, filter WHERE order_id IS NULL.
select 
    p.product_id,
    p.product_name
from production.products as p
left join sales.order_items as oi 
    on p.product_id = oi.product_id
where oi.order_id is null;


--Task 59: Find categories where no product has a list price above 2000.
--Hint: LEFT anti-join categories against a subquery of categories that DO have products above 2000.
select 
    c.category_id,
    c.category_name
from production.categories as c
left join (
    select distinct category_id 
    from production.products 
    where list_price > 2000
) as expensive_cats 
    on c.category_id = expensive_cats.category_id
where expensive_cats.category_id IS NULL;


--Task 60: Find customers who placed orders but never ordered any product from the brand 'Trek'.
--Hint: This combines a regular join (customers who ordered) with a left anti pattern (never ordered Trek).

select distinct
    c.customer_id,
    c.first_name,
    c.last_name
from sales.customers as c
join sales.orders as o 
    on c.customer_id = o.customer_id
left join (
    select distinct o2.customer_id
    from sales.orders as o2
    join sales.order_items as oi on o2.order_id = oi.order_id
    join production.products as p on oi.product_id = p.product_id
    join production.brands as b on p.brand_id = b.brand_id
    where b.brand_name = 'Trek'
) as trek_buyers 
    on c.customer_id = trek_buyers.customer_id
where trek_buyers.customer_id is null;