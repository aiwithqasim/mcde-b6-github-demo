--task 01

SELECT
    p.product_id,
    p.product_name,
    p.list_price
FROM production.products AS p
WHERE p.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products AS p2
    WHERE p2.brand_id = p.brand_id
);

--task 02

SELECT
    o.order_id,
    o.customer_id,
    o.order_date
FROM sales.orders AS o
WHERE o.customer_id IN (
    SELECT c.customer_id
    FROM sales.customers AS c
    WHERE c.state IN ('NY', 'CA')
);

--task 03

select
c.first_name + ' ' + c.last_name as customer_name,
c.customer_id
from sales.customers as c
left join sales.orders as o 
on c.customer_id = o.customer_id
where o.customer_id is null;

--task 04

select 
avg(item_count) as avg_of_item_count
from (
select order_id,
count(*) as item_count
from sales.order_items
group by order_id
) as x;

--task 06

select 
c.customer_id,
c.first_name,
o.order_id,
o.order_date
from sales.customers as c
cross apply ( select top 3
o.order_id,
o.order_date 
from sales.orders as o
where c.customer_id = o.customer_id
order by order_date desc) as o;

--task 07

/*
IN is better when I only need to check whether a value exists in the results of a subquery. 
ANY is useful when I want to compare a value with at least one value returned by the subquery,
such as using > ANY or < ANY.

ALL is used when a condition must be true for every value returned by a subquery. 
For example, a business might ask, “Which products are more expensive than every product
in a particular category?” This is not naturally expressed with IN because IN checks for
matching values, while ALL compares a value against every value returned by the subquery.
*/
