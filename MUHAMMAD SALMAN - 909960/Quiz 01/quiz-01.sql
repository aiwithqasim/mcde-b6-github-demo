--1.  (Easy)  List every order with the 
--customer's full name, store name, and the full name of the staff member who handled it.

select 
c.first_name + ' ' +c.last_name as full_name,
st.store_name,
ord.order_id,
stf.first_name + ' ' + stf.last_name as staff_name
from 
sales.customers as c
inner join sales.orders ord
on
c.customer_id = ord.customer_id
inner join sales.stores as st
on ord.store_id = st.store_id
inner join sales.staffs as stf
on st.store_id = stf.store_id;


--2.  (Easy)  Show each product with its brand name and category name. 
--Include products even if they have no brand or category assigned.

select 
pd.product_name,
brd.brand_name,
cat.category_name
from
production.products as pd
left join production.categories as cat
on pd.category_id = cat.category_id
left join production.brands as brd
on pd.brand_id = brd.brand_id;

--3.  (Medium)  Find all customers who have never placed an order. Return their name, city, and email.

select
*
from sales.customers as c
left join sales.orders as ord
on c.customer_id = ord.customer_id
where ord.order_id is null;


--4.  (Easy)  Calculate total revenue per store. 
--Revenue = quantity * list_price * (1 - discount). Sort from highest to lowest.

select 
st.store_id,
st.store_name,
sum(oi.quantity * list_price * (1 - discount)) as total_revnue
from sales.stores as st
inner join sales.orders as ord
on st.store_id = ord.store_id
inner join sales.order_items as oi
on ord.order_id = oi.order_id
group by st.store_id,st.store_name
order by total_revnue desc;


--5.  (Medium)  For each brand, show the number of products, the average list price, 
--and the highest list price. Only include brands with more than 5 products.

select 
	brd.brand_id,
	brd.brand_name,
	count(pd.product_id) as total_product,
	avg(pd.list_price) as avg_list_price
	from production.products as pd
	inner join production.brands as brd
	on pd.brand_id = brd.brand_id
	group by brd.brand_id,brd.brand_name
	having count(pd.product_id) > 5;


	--6.  (Medium)  Show the number of orders and total revenue per month for the year 2017, 
	--ordered chronologically.

	SELECT 
    MONTH(o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.order_items oi 
    ON o.order_id = oi.order_id
WHERE o.order_date >= '2017-01-01' 
  AND o.order_date < '2018-01-01'
GROUP BY MONTH(o.order_date)
ORDER BY order_month;


--7.  (Medium)  Find all products priced above the average list price of their own category.
--Hint: Use a correlated subquery.

SELECT 
    p1.product_id,
    p1.product_name,
    p1.category_id,
    p1.list_price
FROM production.products p1
WHERE p1.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p1.category_id
);


--8.  (Medium)  List the customers who have placed more orders than the average number of orders per customer.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM sales.customers c
JOIN sales.orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(customer_order_count * 1.0)
    FROM (
        SELECT COUNT(order_id) AS customer_order_count
        FROM sales.orders
        GROUP BY customer_id
    ) AS order_counts
);


9. -- (Hard)  Using a CTE, calculate each customer's total spend, 
--then return the top 10 customers with their spend and rank. 
--Add a second CTE that labels each customer as "High" (above the overall average spend) or "Regular".

WITH customer_spend AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spend
    FROM sales.customers c
    JOIN sales.orders o 
        ON c.customer_id = o.customer_id
    JOIN sales.order_items oi 
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
customer_ranked AS (
    SELECT 
        customer_id,
        first_name,
        last_name,
        total_spend,
        RANK() OVER (ORDER BY total_spend DESC) AS spend_rank,
        CASE 
            WHEN total_spend > (SELECT AVG(total_spend) FROM customer_spend) THEN 'High'
            ELSE 'Regular'
        END AS spend_category
    FROM customer_spend
)
SELECT TOP 10 
    customer_id,
    first_name,
    last_name,
    total_spend,
    spend_rank,
    spend_category
FROM customer_ranked
ORDER BY spend_rank;