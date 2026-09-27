--5.1 - Write a query using a scalar subquery that returns all products with
--a list_price above the average price in their brand. Use a correlated subquery in WHERE.
SELECT 
p1.product_name,
p1.list_price,
p1.brand_id
FROM production.products p1 
WHERE list_price > 
(
  SELECT 
  AVG(p.list_price)
  FROM production.products p
  WHERE  p1.brand_id = p.brand_id
  GROUP BY brand_id
)
ORDER BY brand_id ;

--5.2 - Write a query using IN that returns all orders placed by customers living in New York or California.
SELECT 
o.order_id,
o.customer_id,
o.order_date,
o.order_status
FROM sales.orders o
WHERE o.customer_id IN (
  SELECT c.customer_id 
  FROM sales.customers c
  WHERE c.state IN ('NY','CA')
);

--5.3 - The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:

--SELECT customer_id FROM sales.customers
--WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders);
SELECT 
c.customer_id,
c.first_name,
c.last_name
FROM sales.customers c
WHERE NOT EXISTS(
  SELECT 1 
  FROM sales.orders o
  WHERE o.customer_id = c.customer_id
);

--5.4 - Using a derived table in FROM, write a query that 
--finds the average number of items per order across all orders.
SELECT 
AVG(items_per_order) AS avg_num_items_per_order
FROM(
   SELECT 
   order_id,
   COUNT(item_id) AS items_per_order
   FROM  sales.order_items
   GROUP BY order_id
) AS item_counts;


--5.5 - Rewrite the EXISTS example from section 8.6 using IN instead. 
--Which version is safer and why?
-- Customers who placed at least one order in 2017
SELECT
customer_id,
first_name,
last_name,
city
FROM sales.customers c
WHERE c.customer_id IN (
    SELECT customer_id 
    FROM sales.orders o
    WHERE YEAR(o.order_date) = 2017
);
--The `EXISTS` version is safer because it only checks whether a matching record exists.
--The `IN` version compares the value with a list returned by the subquery, and `NULL` values can 
--sometimes cause unexpected results. Both versions can give the same result in this example.


--5.6 - Use CROSS APPLY to return the top 3 most recent orders for each customer. 
--Show customer_id, first_name, order_id, and order_date.
SELECT 
c.customer_id,
c.first_name,
o.order_id,
o.order_date
FROM sales.customers c
CROSS APPLY(
  SELECT TOP 3
  order_id,
  order_date
  FROM sales.orders 
  WHERE customer_id = c.customer_id
  ORDER BY order_date DESC
) AS o;



--5.7 - Think About It: = ANY (subquery) is functionally identical to IN (subquery). 
--Given that, when would you choose ANY over IN, and when would you choose ALL? 
--What business question naturally maps to ALL that cannot be expressed cleanly with IN?
--
--I would use `IN` when I just want to check if a value is present in the list returned 
--by the subquery because it is easier to understand.

--I would use `ANY` when I want to compare a value with the values returned by the subquery 
--and check if the condition is true for at least one value.

--I would use `ALL` when I want the condition to be true for every value returned by the subquery.

--For example, a business question for `ALL` could be: “Find products that are more expensive than every product in a certain group.” `IN` cannot express this properly because `IN` checks for matching values, while `ALL` checks the condition against every value.
