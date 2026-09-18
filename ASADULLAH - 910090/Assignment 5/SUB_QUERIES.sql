-- 5.1
SELECT p.product_id,
       p.product_name,
       p.brand_id,
       p.list_price
FROM   production.products AS p
WHERE  p.list_price > (SELECT AVG(p2.list_price)
                       FROM   production.products AS p2
                       WHERE  p2.brand_id = p.brand_id);

-- 5.2
SELECT *
FROM   sales.orders
WHERE  customer_id IN (SELECT customer_id
                       FROM   sales.customers
                       WHERE  state IN ('NY', 'CA'));

-- 5.3
SELECT c.customer_id
FROM   sales.customers AS c
WHERE  NOT EXISTS (SELECT 1
                   FROM   sales.orders AS o
                   WHERE  o.customer_id = c.customer_id);

-- 5.4
SELECT AVG(item_count) AS avg_items_per_order
FROM   (SELECT   order_id,
                 COUNT(*) AS item_count
        FROM     sales.order_items
        GROUP BY order_id) AS order_summary;

-- 5.5
SELECT customer_id,
       first_name,
       last_name
FROM   sales.customers
WHERE  customer_id IN (SELECT customer_id
                       FROM   sales.orders);

-- 5.6
SELECT   c.customer_id,
         c.first_name,
         o.order_id,
         o.order_date
FROM     sales.customers AS c CROSS APPLY (SELECT   TOP 3 order_id,
                                                          order_date
                                           FROM     sales.orders AS o
                                           WHERE    o.customer_id = c.customer_id
                                           ORDER BY o.order_date DESC) AS o
ORDER BY c.customer_id, o.order_date DESC;


--5.7 
-- Think About It: = ANY (subquery) is functionally identical to IN (subquery). Given that, when would you choose ANY over IN, 
-- and when would you choose ALL? What business question naturally maps to ALL that cannot be expressed cleanly with IN?
/*= ANY (subquery) is functionally equivalent to IN (subquery) because both check whether a value matches at least one value returned 
by the subquery. 
In practice, IN is generally clearer when checking membership in a set, 
while ANY is useful when making comparisons 
such as > ANY or < ANY. 
ALL is used when a comparison must be true for every value returned by the subquery. A natural business question 
for ALL would be: "Which products have a price higher than every product in a particular category?" This cannot be expressed cleanly
with IN because IN checks equality/membership, whereas ALL allows us to express a universal comparison against an entire set of values*/