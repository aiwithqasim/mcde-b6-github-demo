--1.  (Easy)  List every order with the customer's full name, store name, and the full name of the staff member who handled it.

select
o.order_id,c.first_name+' '+c.last_name as customer_name,
s.first_name+' '+s.last_name as staff_name,
sto.store_name
from
sales.customers c
join sales.orders o
on c.customer_id=o.customer_id
join sales.staffs s
on o.staff_id = s.staff_id
join sales.stores sto
 on s.store_id = sto.store_id 

 --2.  (Easy)  Show each product with its brand name and category name. Include products even if they have no brand or category assigned.

 select p.product_id,
 p.product_name,
 c.category_name,
 b.brand_name
 from production.products p
 left join
 production.categories c
 on p.category_id=c.category_id
 left join production.brands b
 on p.brand_id=b.brand_id

 --3.  (Medium)  Find all customers who have never placed an order. Return their name, city, and email.

 select c.first_name+' '+c.last_name as customer_name,
 c.city,
 c.email from
 sales.customers c
 left join sales.orders o 
 on c.customer_id=o.customer_id
 where o.order_id is null

--4.  (Easy)  Calculate total revenue per store. Revenue = quantity * list_price * (1 - discount). Sort from highest to lowest.

select sto.store_name ,sum(oi.quantity * oi.list_price * (1-oi.discount) ) as Revenue from
		sales.stores sto
		join sales.orders o
			on sto.store_id=o.store_id
		join sales.order_items oi
			on o.order_id=oi.order_id
group by sto.store_name
order by Revenue desc

--5.  (Medium)  For each brand, show the number of products, the average list price, and the highest list price. Only include brands with more than 5 products.


	select 
		b.brand_name,
		count(p.product_id) as product_count,
		avg(p.list_price) as average_list_price,
		max(p.list_price) as highest_list_price 
	from production.brands b
	join production.products p
	on b.brand_id=p.brand_id
	group by b.brand_name
	having count(p.product_id)>5
	order by product_count desc;

--6.  (Medium)  Show the number of orders and total revenue per month for the year 2017, ordered chronologically.

select 
    month(o.order_date) as order_month,
    count(distinct o.order_id) as total_orders,
    round(sum(oi.quantity * oi.list_price * (1 - oi.discount)), 2) as total_revenue
from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where year(o.order_date) = 2017
group by month(o.order_date)
order by order_month asc;
--7.  (Medium)  Find all products priced above the average list price of their own category.
--Hint: Use a correlated subquery.


select
p1.product_id,
p1.product_name,
p1.category_id,
p1.list_price
from production.products as p1
where p1.list_price >
(
select avg(p2.list_price) 
from production.products as p2
where p2.category_id=p1.category_id
)  

--8.  (Medium)  List the customers who have placed more orders than the average number of orders per customer.
select 
    c.customer_id,
    c.first_name+' '+c.last_name as customer_name,
    count(o.order_id) as order_count
from sales.customers c
join sales.orders o on c.customer_id = o.customer_id
group by c.customer_id, c.first_name, c.last_name
having count(o.order_id) > (
    select avg(order_count)
    from (
        select count(order_id) as order_count
        from sales.orders
        group by  customer_id
    ) as customer_order_counts
)
order by order_count desc;

--9.  (Hard)  Using a CTE, calculate each customer's total spend, then return the top 10 customers with their spend and rank.
--Add a second CTE that labels each customer as "High" (above the overall average spend) or "Regular".

--for this help is taken from AI
with customer_spend as (
    select 
        c.customer_id,
        c.first_name+' '+ c.last_name as customer_name,
        sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_spend
    from sales.customers c
    join sales.orders o on c.customer_id = o.customer_id
    join sales.order_items oi on o.order_id = oi.order_id
    group by c.customer_id, c.first_name, c.last_name
),

customer_tier as (
    select 
        customer_id,
        customer_name,
        total_spend,
        rank() over (order by total_spend desc) as spend_rank,
        case 
       when total_spend > (select avg(total_spend) from customer_spend) then 'high'
        else 'regular'
        end as customer_tier
    from customer_spend
)

select 
    spend_rank,
    customer_id,
    customer_name,
    round(total_spend, 2) as total_spend,
    customer_tier
from customer_tier
where spend_rank <= 10
order by spend_rank asc;
-----gene