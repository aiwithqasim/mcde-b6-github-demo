select * from sales.customers

-- Self Join

-- Task 41: List each staff member alongside their manager's full name. If a staff member has  
-- no manager (top-level), still show them with NULL for manager name.





select 
s.staff_id,
s.first_name + '' + s.last_name as 'staff full name',
s.manager_id,
m.first_name + '' + m.last_name as 'manager full name'

from 
sales.staffs as s 
left join sales.staffs as m 
on  s.manager_id = m.staff_id
-- where s.manager_id is  null -- optional not lagao 


--  Task 42: Find pairs of products from the same brand that have the exact same list price.
-- Show both product names and the brand name.

select 
p.product_id,
oi.list_price,
b.brand_id,
b.brand_name

from 

production.products as p 
left join  production.brands as b 
on b.brand_id = p.brand_id
left join sales.order_items as oi 
on p.list_price = oi.list_price


-- Cross Join



-- Task 45: Generate a list of every possible combination of brand and category. Show brand name and category name.

-- Hint: This is useful when you want to find which brand-category combos have no products.

select 
c.category_name,
b.brand_name
from

production.categories as c 
cross join  production.brands as b 



-- Task 46: Using the result of a CROSS JOIN between brands and categories, find brand-category combinations 
-- that have NO products (LEFT JOIN the cross join result against products and filter for NULLs).

select 
c.category_name,
b.brand_name,
p.product_id
from

production.categories as c 
cross join  production.brands as b 
left  join production.products as p
on c.category_id = p.category_id
where  p.product_id is  null

-- Right Join



-- Task 49: List all brands and the products that belong to them. Ensure ALL brands appear, even if they 
-- have no products. Use a RIGHT JOIN (products RIGHT JOIN brands).

select 
b.brand_id,
p.product_id,
p.product_name,
b.brand_name

from  
production.brands as b
left join  production.products as p 
on b.brand_id = p.brand_id



-- Task 50: Show all stores and the orders placed at each store. Use a RIGHT JOIN so that stores with zero orders still appear.
-- Left Anti Join (LEFT JOIN + WHERE IS NULL)

select  
s.store_id,
o.order_id,
o.order_status,
s.store_name

from 
sales.stores as s 
left  join sales.orders as o

on s.store_id = o.store_id

where o.order_status is   null -- not 


-- Task 53: Find all customers who have NEVER placed an order.
-- Hint: LEFT JOIN sales.customers with sales.orders, then filter WHERE order_id IS NULL.
select 
c.customer_id,
o.order_id,
o.order_status,
c.first_name + '' + c.last_name 'customer full name '

from 
sales.customers as c 
full outer join sales.orders as o
on o.customer_id = c.customer_id 
where order_id is  null

-- Task 54: Find all products that are NOT currently in stock at ANY store.

-- Hint: LEFT JOIN production.products with production.stocks, filter WHERE store_id IS NULL.

select 
st.store_id,
p.product_id

from 
production.products as p 
left join production.stocks as st 
on p.product_id = st.product_id
where st.store_id is null

-- Task 56: Find all products that have never been ordered.
-- Hint: LEFT JOIN production.products with sales.order_items, filter WHERE order_id IS NULL.


select 
p.product_id,
oi.order_id

from production.products as p 

left join  sales.order_items as oi 
on p.product_id = oi.product_id 
where oi.order_id is null



-- Task 59: Find categories where no product has a list price above 2000.

-- Hint: LEFT anti-join categories against a subquery of categories that DO have products above 2000.
 -- ai se kia hy
SELECT
    c.category_id,
    c.category_name
FROM production.categories AS c
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) AS p
    ON c.category_id = p.category_id
WHERE p.category_id IS NULL;

-- Task 60: Find customers who placed orders but never ordered any product from the brand 'Trek'.
-- Hint: This combines a regular join (customers who ordered) with a left anti pattern (never ordered Trek).

select 
c.customer_id,
o.order_id,
oi.order_id,
p.product_id,
b.brand_id

from sales.customers as c
left join sales.orders as o 
on c.customer_id = o.customer_id
left join sales.order_items as oi  
on oi.order_id = o.order_id
left join production.products as p
on p.product_id = oi.product_id
left join production.brands as b 
on b.brand_id = p.brand_id

 WHERE b.brand_name = 'Trek'





 SELECT DISTINCT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS [customer full name]
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT DISTINCT
        o.customer_id
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    INNER JOIN production.products AS p
        ON oi.product_id = p.product_id
    INNER JOIN production.brands AS b
        ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) AS trek_customers
    ON c.customer_id = trek_customers.customer_id
WHERE trek_customers.customer_id IS NULL;