--SELF JOIN
--TASK 1 List each staff member alongside their manager's full name. 
--If a staff member has no manager (top-level), still show them with NULL for manager name.

SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS staff_full_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_full_name
FROM  sales.staffs as s
LEFT JOIN sales.staffs as m 
ON s.manager_id = m.staff_id;

--TASK 2
--Find pairs of products from the same brand that have the exact same list price. 
--Show both product names and the brand name.

SELECT 
     p.product_name AS product_1,
    p1.product_name AS product_2,
     b.brand_name,
     p.list_price
FROM production.products AS p
JOIN production.products AS p1
ON p.product_id = p1.product_id
JOIN production.brands as b
ON p.brand_id = b.brand_id
ORDER BY
      b.brand_name,
      p.list_price;
--TASK 3
--Find all pairs of customers who live in the same city and state. 
--Avoid duplicates (don't show A-B and B-A both).

SELECT 
    c.first_name  ||  ' '  || c.last_name AS customer_1,
    c1.first_name ||  ' '  || c1.last_name AS customer_2,
    c.city,
    c.state
FROM sales.customers as c
JOIN sales.customers as c1 
ON c.city = c1.city AND c.state = c1.state
AND c.customer_id < c1.customer_id
ORDER BY 
    c.state, 
    c.city;

--TASK 4
--List staff members who were hired at the same store as their manager.

SELECT
     s.staff_id,
     s.first_name,
     s.last_name,
    s1.store_id,
    s1.manager_id
FROM sales.staffs as s
JOIN sales.staffs AS s1
ON s.store_id = s1.store_id
ORDER BY
      s.store_id;

--CROSS JOIN
--TASK 5
--Generate a list of every possible combination of brand and category. Show brand name and category name.

SELECT *
FROM production.brands as b
CROSS JOIN production.categories as c;

--TASK 6
--Using the result of a CROSS JOIN between brands and categories, 
--find brand-category combinations that have NO products 
--(LEFT JOIN the cross join result against products and filter for NULLs).

SELECT 
     b.brand_id,
     b.brand_name,
     c.category_id,
     c.category_name,
     p.product_name,
     p.product_id
FROM production.brands as b
CROSS JOIN production.categories as c
LEFT JOIN production.products as p 
ON p.product_id = b.brand_id AND b.brand_id = p.brand_id
ORDER BY 
    b.brand_name, 
    c.category_name;
    
--TASK 7
--Generate a report showing every store paired with every product, along with the stock quantity. If a store doesn't carry a product, show 0.
--Hint: CROSS JOIN stores with products, then LEFT JOIN with production.stocks.

SELECT
     s.store_id,
     s.store_name,
     p.product_id,
     p.product_name,
    st.quantity
FROM  sales.stores as s
CROSS JOIN production.products AS p
LEFT JOIN production.stocks as st
ON s.store_id = p.product_id;

--TASK 8
--Create all possible staff-store assignments (every staff paired with every store), then show which ones are the actual current assignments

SELECT
    s.staff_id,
    s.first_name,
    s.last_name,
   st.store_id,
   st.store_name
FROM sales.staffs AS s
CROSS JOIN sales.stores AS st

--RIGHT JOIN

--TASK 9
--Task 49: List all brands and the products that belong to them.
--Ensure ALL brands appear, even if they have no products. Use a RIGHT JOIN (products RIGHT JOIN brands).

SELECT
     b.brand_name,
     b.brand_id,
     p.product_name,
     p.product_id
FROM production.products AS p
RIGHT JOIN production.brands AS b
ON p.brand_id = b.brand_id;

--TASK 10
--Show all stores and the orders placed at each store. Use a RIGHT JOIN so that stores with zero orders still appear.

SELECT 
     s.store_id,
     s.store_name,
     o.order_id,
     o.order_date
FROM sales.stores AS s
RIGHT JOIN sales.orders AS o
ON s.store_id = o.store_id
ORDER BY s.store_id ASC;

--TASK 11
-- List all categories with their product count. Use a RIGHT JOIN to ensure categories with no products show a count 0.
SELECT
    c.category_id,
    c.category_name,
    COUNT (p.product_id) AS product_count
    FROM production.categories AS c
    RIGHT JOIN production.products AS p
    ON c.category_id = p.category_id
    GROUP BY c.category_id, category_name;

--TASK 12
--Show all staff members and the orders they handled. Use a RIGHT JOIN on orders RIGHT JOIN staffs, so staff who handled zero orders still appear.

SELECT 
    s.staff_id,
    s.first_name + ' ' + s.last_name AS Full_name,
    o.order_id
FROM sales.orders AS o
RIGHT JOIN sales.staffs AS s
ON o.staff_id = s.staff_id
ORDER BY s.staff_id ASC;

---LEFT ANIT JOIN + WHERE IS NULL

--TASK 13
--
--Find all customers who have NEVER placed an order.
--Hint: LEFT JOIN sales.customers with sales.orders, then filter WHERE order_id IS NULL.

SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS Customer_Full_Name,
    o.order_id
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--TASK 14
--Find all products that are NOT currently in stock at ANY store.
--Hint: LEFT JOIN production.products with production.stocks, filter WHERE store_id IS NULL.

SELECT 
    p.product_id,
    p.product_name,
    s.store_id,
    s.quantity
FROM production.products AS p
LEFT JOIN production.stocks AS s
ON p.product_id = s.product_id
WHERE s.store_id IS NULL;

--TASK 15
--Find brands that have NO products in the database.

SELECT 
    b.brand_id,
    b.brand_name,
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN production.brands AS b
ON p.brand_id = b.brand_id
WHERE p.product_id IS NULL;

--TASK 16
--Find all products that have never been ordered.
--Hint: LEFT JOIN production.products with sales.order_items, filter WHERE order_id IS NULL.

SELECT 
    p.product_id,
    p.product_name,
    o.order_id,
    o.item_id
FROM production.products AS p
LEFT JOIN sales.order_items AS o
ON p.product_id = o.product_id
WHERE order_id IS NULL
ORDER BY p.product_id ASC;

--TASK 17
--Find stores that have never had any staff assigned to them.

SELECT
    s.store_id,
    s.store_name,
   st.staff_id
FROM sales.stores AS s
LEFT JOIN sales.staffs AS st
ON s.store_id = st.store_id
WHERE st.staff_id IS NULL;

--TASK 18
--Find staff members who have never handled a single order.

SELECT
    s.first_name + ' ' + s.last_name AS Staff_Full_Name,
    o.order_id
FROM sales.staffs AS s
LEFT JOIN sales.orders AS o
ON s.staff_id = o.staff_id
WHERE o.order_id IS NULL;

--TASK 19
--Find categories where no product has a list price above 2000.
--Hint: LEFT anti-join categories against a subquery of categories that DO have products above 2000.

SELECT
     c.category_id,
     c.category_name
FROM production.categories AS c
LEFT JOIN (
           SELECT DISTINCT category_id
           FROM production.products
           WHERE list_price >=2000 
) above_2000
ON c.category_id = above_2000.category_id
WHERE above_2000.category_id IS NULL;

--TASK 20
--Find customers who placed orders but never ordered any product from the brand 'Trek'.
--Hint: This combines a regular join (customers who ordered) with a left anti pattern (never ordered Trek).

SELECT
     c.customer_id,
     c.first_name + ' ' + c.last_name AS Customer_full_Name,
     o.order_id
FROM sales.customers AS c
INNER JOIN sales.orders AS o
ON c.customer_id = o.order_id
LEFT JOIN (
            SELECT DISTINCT o.customer_id
            FROM sales.orders AS o
            JOIN sales.order_items AS oi ON o.order_id = oi.order_id
            JOIN production.products AS p ON oi.product_id = p.product_id
            JOIN production.brands AS b ON p.brand_id = b.brand_id
            WHERE b.brand_name = 'Trek'
            )Trek_customers
ON c.customer_id = Trek_customers.customer_id
WHERE Trek_customers.customer_id IS NULL;




