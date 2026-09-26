Use BikeStores
Go




-- 5.1 - Write a query using a scalar subquery that returns all products
-- with a list_price above the average price in their brand. 
-- Use a correlated subquery in WHERE.

select * 
from production.products p
where  list_price > 
(
select AVG(list_price)
from production.products b
where b.brand_id = p.brand_id
group by b.brand_id)
order by list_price,brand_id asc;



-- 5.2 - Write a query using IN that returns all 
-- orders placed by customers living in New York or California.

select * from sales.customers
where state in (
select state from sales.customers
where state = 'NY' OR state = 'CA')
order by zip_code;


-- 5.3 - The following query is meant to 
-- find customers who never ordered, but has a NULL trap. Fix it:

SELECT * FROM sales.customers c
WHERE not exists (SELECT 1 FROM sales.orders o
where o.customer_id = c.customer_id);

SELECT top 5 * FROM sales.orders;
SELECT top 5* FROM sales.customers;

-- 5.4 - Using a derived table in FROM, write a query
--that finds the average number of items per order across all orders.

select AVG(order_count) as Average_per_item
from (
	select order_id,
	sum(quantity) as order_count
	from sales.order_items
	group by order_id)
	as items_per_order;


--5.5 - Rewrite the EXISTS example from
--section 8.6 using IN instead.Which version is safer and why?

-- Customers who placed at least one order in 2017
SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM sales.customers 
WHERE customer_id in  (
    SELECT customer_id
    FROM sales.orders 
    WHERE YEAR(order_date) = 2017
);


--5.6 - Use CROSS APPLY to return the top 3 most recent orders for each
-- customer. Show customer_id, first_name, order_id, and order_date.
select top 3
    c.customer_id,
    c.first_name,
    o.order_id,
    o.order_date
from sales.customers c
cross apply(
    select top 3
    o.order_id,
    o.order_date
    from sales.orders o
    where customer_id = c.customer_id
    order by order_date desc
    ) as o;

--5.7 - Think About It: = ANY (subquery) is functionally identical
--to IN (subquery). Given that, when would you choose ANY over IN,
--and when would you choose ALL? What business question naturally
--maps to ALL that cannot be expressed cleanly with IN?

----Quetion 1
--"Find all products whose list price is greater than the list price
-- of at least one product in the 'Mountain Bikes' category."

select * 
from production.products
where list_price > Any (
    select list_price
    from production.products
        where category_id in(
            select category_id
            from production.categories
                where category_name = 'Mountain Bikes')
);



--Question 2 — For ALL (universal comparison)

--"Find all customers who placed orders on every date that
--any order was placed in 2017."
select 
    customer_id,
    first_name +' '+ last_name as customer_name,
    email
    from sales.customers
    where customer_id in (
    select 
    customer_id
    from sales.orders
    where YEAR(order_date) = 2017);



--Find all products whose list price is greater than the list 
--price of at least one product in the 'Children Bicycles'category."

select  
    product_id,
    product_name
from production.products
where list_price > any(
select list_price
from production.products
where category_id = (
select category_id
from production.categories
where category_name = 'Children Bicycles')
);