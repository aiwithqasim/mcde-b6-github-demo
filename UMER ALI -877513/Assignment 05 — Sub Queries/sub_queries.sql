
-- Sub Queries

-- task 1
select 
    product_name,
    brand_id,
    list_price
from production.products  p1
where list_price > (
    select
        AVG(list_price) as avg_price 
    from production.products p2
    where p1.brand_id = p2.brand_id
)

-- task 2
select
    order_id
from sales.orders
where customer_id in (
    select 
        customer_id,
        state 
    from sales.customers 
    where city = 'New York' or state = 'California'
)

-- task 3 
--before correction
SELECT customer_id FROM sales.customers
WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders);

--after correction 
select 
    c.customer_id ,
    c.first_name
from sales.customers as c
where not exists(
    select
        o.order_id
    from sales.orders as o
    where o.customer_id = c.customer_id
    )


-- task 4
select
    avg(counted_item) as average_order_item
from (
select
    order_id,
    count(item_id) as counted_item
from sales.order_items 
group by order_id
) as order_item_count

-- task 5
SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM sales.customers c
WHERE customer_id IN (
    SELECT customer_id 
    FROM sales.orders o
    WHERE YEAR(o.order_date) = 2017
);

-- task 6 
SELECT 
    sc.customer_id,
    sc.first_name,
    top_orders.order_id,
    top_orders.order_date
FROM sales.customers sc
CROSS APPLY (
    SELECT TOP 3 
        so.order_id,
        so.order_date
    FROM sales.orders so
    WHERE so.customer_id = sc.customer_id
    ORDER BY so.order_date DESC
) AS top_orders;

-- TASK 7
-- Products jo HAR brand ke average price se mehenge hain
-- (matlab: sabse premium products, koi bhi brand average inko match nahi karta)
SELECT
    product_name,
    list_price
FROM production.products
WHERE list_price >= ALL (
    SELECT AVG(list_price)
    FROM production.products
    GROUP BY brand_id
);