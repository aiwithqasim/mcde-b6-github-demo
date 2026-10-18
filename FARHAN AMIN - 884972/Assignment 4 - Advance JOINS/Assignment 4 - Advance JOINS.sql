--Self Join
--Task 41: List each staff member alongside their manager's full name. 
--If a staff member has no manager (top-level), still show them with NULL 
--for manager name.

use BikeStores;
go
select 
e.staff_id AS ID, 
e.first_name + ' ' + e.last_name AS staff_member,
m.first_name + ' ' + m.last_name AS manager_name
from sales.staffs AS e
left join sales.staffs AS m
ON e.manager_id = m.staff_id;


--Task 42: Find pairs of products from the same brand that have the exact same list
--price. Show both product names and the brand name.

select 
b.brand_name,
p1.product_name AS product_1,
p2.product_name AS product_2,
p1.list_price
from production.products AS p1
inner join production.products AS p2
ON p1.brand_id = p2.brand_id
inner join production.brands AS b
ON p2.brand_id = b.brand_id
where p1.list_price = p2.list_price 
      AND p1.product_id < p2.product_id; 


--Task 43: Find all pairs of customers who live in the same city and state. Avoid duplicates (don't 
--show A-B and B-A both)

SELECT 
    A.first_name AS customer_A,
    B.first_name AS customer_B,
    A.city, A.state
FROM sales.customers AS A
JOIN sales.customers AS B 
    ON A.city = B.city AND A.state = B.state AND A.customer_id < B.customer_id; 


--Task 44: List staff members who were hired at the same store 
--as their manager

SELECT 
    s.staff_id,
    s.first_name + ' ' + s.last_name AS staff_name,
    s.store_id,
    s.manager_id
FROM sales.staffs AS s
JOIN sales.staffs AS m 
    ON s.manager_id = m.staff_id
WHERE s.store_id = m.store_id
 

--Cross Join

--Task 45: Generate a list of every possible combination of brand and category. 
--Show brand name and category name.
--Hint: This is useful when you want to find which brand-category combos have 
--no products

select b.brand_name, c.category_name
from production.brands b
cross join production.categories c;


--Task 46: Using the result of a CROSS JOIN between brands and categories, 
--find brand-category combinations that have NO products (LEFT JOIN the cross 
--join result against products and filter for NULLs).

select b.brand_name, c.category_name, p.product_name
from production.brands b
cross join production.categories c
left join production.products p
ON p.category_id = c.category_id AND p.brand_id = b.brand_id
where p.product_id is NULL;


--Task 47: Generate a report showing every store paired with every product, alongwith the stock quantity
--if a store doesnot carry a product show 0
--Hint: CROSS JOIN stores with products, then LEFT JOIN with production.stocks

SELECT 
    s.store_name,
    p.product_name,
    COALESCE(stk.quantity, 0) AS stock_quantity
FROM 
    sales.stores s
CROSS JOIN 
    production.products p
LEFT JOIN 
    production.stocks stk ON s.store_id = stk.store_id AND p.product_id = stk.product_id


--Task 48: Create all possible staff-store assignments (every staff pair 
--with every store), then show which ones are the actual current 
--assignments

SELECT 
    stf.staff_id,
    stf.first_name,
    sto.store_id,
    assigned_store.store_id AS assigned_store
FROM sales.staffs AS stf
CROSS JOIN sales.stores AS sto

LEFT JOIN sales.staffs AS assigned_store 
ON stf.staff_id = assigned_store.staff_id AND sto.store_id = assigned_store.store_id;

    select * from sales.staffs

--Right Join

--Task 49: List all brands and the products that belong to them. 
--Ensure ALL brands appear, even if they have no products. 
--Use a RIGHT JOIN (products RIGHT JOIN brands).

select b.brand_name, p.product_name
from production.products AS p
right join production.brands AS b
ON p.brand_id = b.brand_id;


--Task 50: Show all stores and the orders placed at each store. 
--Use a RIGHT JOIN so that stores with zero orders still appear.

select
s.store_id, s.store_name, o.order_id, o.order_date
from sales.orders AS o
right join sales.stores AS s
ON o.store_id = s.store_id;

--Task 51: List all categories with their product count. Use a right join
--to ensure categories with no products show a count of 0

SELECT 
    c.category_name,
    COUNT(p.product_id) AS products
FROM production.products AS p
RIGHT JOIN production.categories AS c 
    ON p.category_id = c.category_id
GROUP BY c.category_name;


--Task 52: Show all staff members and the orders they handled. Use a RIGHT 
--JOIN on orders RIGHT JOIN staffs, so staff who handled 0 orders still appear

SELECT 
    s.staff_id,
    s.first_name + ' ' + s.last_name AS staff,
    o.order_id,
    o.order_date
FROM sales.orders AS o
RIGHT JOIN sales.staffs AS s 
    ON o.staff_id = s.staff_id;


--Left Anti Join (LEFT JOIN + WHERE IS NULL)

--Task 53: Find all customers who have NEVER placed an order.
--Hint: LEFT JOIN sales.customers with sales.orders, then filter 
--WHERE order_id IS NULL.

select 
c.customer_id, c.first_name + ' ' + c.last_name AS customer_name,
o.order_id
from sales.customers AS c
left join sales.orders AS o
ON c.customer_id = o.customer_id
where o.order_id is NULL;


--Task 54: Find all products that are NOT currently in stock at ANY store.
--Hint: LEFT JOIN production.products with production.stocks, filter 
--WHERE store_id IS NULL.

select p.product_id, p.product_name, s.store_id
from production.products AS p
left join production.stocks AS s
ON s.product_id = p.product_id
where s.store_id is NULL;


--Task 55: Find brands that have NO products in the database

select  
        b.brand_id,
        b.brand_name,
        p.product_name
from production.brands AS b
LEFT JOIN production.products AS p
ON b.brand_id = p.brand_id
where p.product_id is NULL


--Task 56: Find all products that have never been ordered.
--Hint: LEFT JOIN production.products with sales.order_items, filter 
--WHERE order_id IS NULL.

select p.product_id, p.product_name, oi.order_id
from production.products AS p
left join sales.order_items AS oi
ON oi.product_id = p.product_id
where oi.order_id is NULL;


--Task 57: Find stores that have never had any staff assigned to them

select  
        sto.store_id,
        sto.store_name,
        stf.first_name AS staff
from sales.stores AS sto
LEFT JOIN sales.staffs AS stf
ON sto.store_id = stf.store_id
where stf.staff_id is NULL


--Task 58: Find staff members who have never handled a single order

SELECT 
    s.staff_id,
    s.first_name + ' ' + s.last_name AS staff,
    o.order_id
FROM sales.staffs AS s
LEFT JOIN sales.orders AS o 
    ON s.staff_id = o.staff_id
WHERE o.order_id IS NULL;


--Task 59: Find categories where no product has a list price above 2000.
--Hint: LEFT anti-join categories against a subquery of categories that 
--DO have products above 2000.

SELECT 
    c.category_id,
    c.category_name
FROM production.categories c
LEFT JOIN (SELECT DISTINCT p.category_id
    FROM production.products p
    WHERE p.list_price > 2000) AS expensive_items ON c.category_id = expensive_items.category_id
WHERE expensive_items.category_id IS NULL;


--Task 60: Find customers who placed orders but never ordered any product from
--the brand 'Trek'.
--Hint: This combines a regular join (customers who ordered) with a left 
--anti pattern (never ordered Trek).

SELECT DISTINCT
    c.customer_id, c.first_name + ' ' + c.last_name AS customer_name
FROM 
    sales.customers c
INNER JOIN sales.orders o 
ON c.customer_id = o.customer_id
LEFT JOIN (SELECT DISTINCT o2.customer_id
    FROM sales.orders o2
    JOIN sales.order_items oi ON o2.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.brands b ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek') AS trek_customers 
ON c.customer_id = trek_customers.customer_id
WHERE trek_customers.customer_id IS NULL;

