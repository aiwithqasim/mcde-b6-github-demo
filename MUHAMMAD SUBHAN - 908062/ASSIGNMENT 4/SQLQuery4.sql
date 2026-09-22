--5.1 - Write a query using a scalar subquery that returns all products with
--a list_price above the average price in their brand. Use a correlated subquery in WHERE.

select 
p.product_id,
p.product_name,
p.list_price,
p.brand_id
from production.products as p 
where p.list_price > (
	select avg (p2.list_price)
	from production.products as p2
	where p2.brand_id = p.brand_id
);

select * from sales.stores
--5.2 - Write a query using IN that returns all orders placed by customers living in New York or California.

select 
c.first_name + ' ' + c.last_name as _full_name,
c.state
from
sales.customers as c
where state in ('NY' , 'CA');


--5.3 - The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:
--SELECT customer_id FROM sales.customers
--WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders);

select customer_id from sales.customers
where customer_id not in (
select customer_id from sales.orders
where customer_id is not null 
);
--5.4 - Using a derived table in FROM, write a query that finds the average number of items per order across all orders.

SELECT AVG(items_per_order) AS avg_items_per_order
FROM (
    SELECT order_id, COUNT(*) AS items_per_order
    FROM sales.order_items
    GROUP BY order_id
) AS order_counts;

--5.5 - Rewrite the EXISTS example from section 8.6 using IN instead. Which version is safer and why?

select 
c.customer_id,
c.first_name+ ' ' + c.last_name as full_name,
city
from sales.customers c 
where customer_id in (
select  customer_id
from sales.orders o 
where year (order_date) = 2017
);
--5.6 - Use CROSS APPLY to return the top 3 most recent orders for each customer.
--Show customer_id, first_name, order_id, and order_date.

select 
c.customer_id,
c.first_name,
o.order_id,
o.order_date
from sales.customers c
cross apply (
	select top 3 order_id , order_date
	from sales.orders o 
	where o.customer_id = c.customer_id
	order by order_date desc
) o;


--5.7 - Think About It: = ANY (subquery) is functionally identical to IN (subquery).
--Given that, when would you choose ANY over IN, and when would you choose ALL? 
--What business question naturally maps to ALL that cannot be expressed cleanly with IN?
