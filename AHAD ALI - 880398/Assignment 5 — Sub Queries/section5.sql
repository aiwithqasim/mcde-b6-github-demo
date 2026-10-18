---Assigment-- 5


--5.1 - Write a query using a scalar subquery that returns all products with a list_price 
--above the average price in their brand. Use a correlated subquery in WHERE.

      select
         product_name,
         list_price
        from production.products as p1
        where list_price > (
        select AVG(P2. list_price)
        FROM production.products as P2 
       where  P1.brand_id = p2.brand_id
       );



 --  5.2 - Write a query using IN that returns all orders placed by customers living in New York or California. 

 select 
    customer_id,
    order_id
from sales.orders as o
where customer_id in(
 select customer_id 
 from sales.customers 
 where city = 'New York'
 or city = 'california'
 );

-- 5.3 - The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:
-- SELECT customer_id FROM sales.customers
-- WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders);

select 
customer_id 
from sales.customers as c
where 
not exists 
(select 1 from sales.orders as o
where o.customer_id = c.customer_id)

-- 5.4 - Using a derived table in FROM, write a query that finds the average number of
--items per order across all orders.



select avg(order_count) as averahe
from(
select order_id,
count(order_id)as order_count 
from sales.order_items group by order_id 
) as order_itemss

-- 5.5 - Rewrite the EXISTS example from section 8.6 using IN instead. Which version is safer and why?


-- Customers who placed at least one order in 2017
SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM sales.customers c
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
      AND YEAR(o.order_date) = 2017
);


-- 5.6 - Use CROSS APPLY to return the top 3 most recent orders for each customer.
-- Show customer_id, first_name, order_id, and order_date.
select 
c.customer_id,
c.first_name + '' + last_name as full_name,
o.order_id,
o.order_date
from sales.customers as c

cross apply (
select top 3 
order_id,
order_date
from sales.orders
where customer_id = c.customer_id
order by order_date desc
)as o
order by c.customer_id , o.order_date


-- 5.7 - Think About It: = ANY (subquery) is functionally identical to IN (subquery).
-- Given that, when would you choose ANY over IN, and when would you choose ALL? 
--What business question naturally maps to --ALL that cannot be expressed cleanly with IN?
--any ko IN ke jaga  tab use karte hain jab humein check karna ho: kya yeh value list me mojood hy 

--- ALL haer value  check karta hy or match karta hy.

-- ALL ka matlab hai sabhi values ke liye condition true hona.
-- Example: Kaunsa product apni category ke baqi tamam products se zyada mehnga hai?
-- Is tarah ke question mein ALL naturally use hota hai.