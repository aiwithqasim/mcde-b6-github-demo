
   --EXCERCISE 5.1 -  Write a query using a scalar subquery that returns all products with a list_price 
   --above the average price in their brand. Use a correlated subquery in WHERE.
   SELECT 
   O.product_name,
   O.list_price,
   O.brand_id
   FROM production.products O
   WHERE   O.list_price >
   (
   SELECT AVG(i.list_price) 
   FROM production.products i
   where i.brand_id=o.brand_id
   );


   --5.2 - Write a query using IN that returns all orders placed by customers living in New York or California.

   SELECT 
   o.order_id,
   o.customer_id,
   o.order_date,
   o.order_status
   FROM sales.orders o
   WHERE o.customer_id in
   (
   SELECT i.customer_id 
   FROM sales.customers i
   WHERE
   o.customer_id=i.customer_id and
   i.state in ('NY','CA')
   );

   --5.3 - The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:
   --=============================================================
   --SELECT customer_id FROM sales.customers
        --WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders);
   --==================================================================

   select
   o.customer_id,
   o.first_name 
   from sales.customers o
   where not exists 
   (
   select 1
   from sales.orders as i
   where i.customer_id=o.customer_id
   )

   --5.4 - Using a derived table in FROM, write a query that finds the average number of items per order across all orders.

   -- Average number of orders per staff member
SELECT
    AVG(item_count) AS average_number_of_orders
FROM (
    SELECT
        order_id,
        sum(quantity) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS total_orders;

--5.5 - Rewrite the EXISTS example from section 8.6 using IN instead. Which version is safer and why?

select 
    customer_id,
    first_name,
    last_name,
    city
    from sales.customers
    where customer_id in(
    select customer_id from sales.orders
    where year(order_date)=2017
    );

    --EXISTS is better because it uses true/false saving us from null or unknown

--5.6 - Use CROSS APPLY to return the top 3 most recent orders for each customer.
--Show customer_id, first_name, order_id, and order_date.

select c.customer_id,
c.first_name as customer_name,
o.order_id,
o.order_date
from sales.customers c
cross apply (
select top 3
order_id,
order_date
from sales.orders
where customer_id=c.customer_id
order by order_date desc
) o
order by c.first_name, o.order_date desc

--5.7 - Think About It: = ANY (subquery) is functionally identical to IN (subquery).
--Given that, when would you choose ANY over IN, and when would you choose ALL?
--What business question naturally maps to ALL that cannot be expressed cleanly with IN?

--ANY can be used with logical operator (>,<,<>) IN only see that a value matches at least one item in table.
--we use ALL when we want the condition to be true for every row 
--with IN we cannot do range comparision, but with ALL we can compare to all of the range (Rows)