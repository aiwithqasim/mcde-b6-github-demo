--               Section 3 — JOINs
-- Task 12:  List every product along with its brand name and category name.
SELECT pp.product_name,
       pb.brand_name,
       pc.category_name
FROM   production.products AS pp
       INNER JOIN
       production.brands AS pb
       ON pp.brand_id = pb.brand_id
       INNER JOIN
       production.categories AS pc
       ON pp.category_id = pc.category_id;

-- Task 13:  List all orders with the customer's full name (first_name + last_name), order date, and order status.
SELECT so.order_id,
       sc.first_name + ' ' + sc.last_name AS full_name,
       so.order_date,
       so.order_status
FROM   sales.orders AS so
       LEFT OUTER JOIN
       sales.customers AS sc
       ON so.customer_id = sc.customer_id;

-- Task 14:  Show every order item with the product name, quantity, list price, and discount.
SELECT pp.product_name,
       soi.quantity,
       soi.list_price,
       soi.discount
FROM   sales.order_items AS soi
       LEFT OUTER JOIN
       production.products AS pp
       ON soi.product_id = pp.product_id;

-- Task 15:  List each staff member's full name alongside their store name.
SELECT ssf.first_name + ' ' + ssf.last_name AS full_name,
       sst.store_name
FROM   sales.staffs AS ssf
       LEFT OUTER JOIN
       sales.stores AS sst
       ON ssf.store_id = sst.store_id;

-- Task 16:  List staff members along with their manager's full name.
SELECT e.first_name + ' ' + e.last_name AS employee,
       m.first_name + ' ' + m.last_name AS manager
FROM   sales.staffs AS e
       LEFT OUTER JOIN
       sales.staffs AS m
       ON e.manager_id = m.staff_id;

-- Task 17:  Show all stores and the products they have in stock, including the product name and quantity. Only show items where quantity > 0.
SELECT ss.store_name,
       ps.product_id,
       pp.product_name,
       ps.quantity
FROM   sales.stores AS ss
       LEFT OUTER JOIN
       production.stocks AS ps
       ON ss.store_id = ps.store_id
          AND ps.quantity > 0
       LEFT OUTER JOIN
       production.products AS pp
       ON ps.product_id = pp.product_id;

-- Task 18:  List all customers who placed at least one order. Show customer name and order date.
SELECT sc.first_name + ' ' + sc.last_name AS full_name,
       so.order_date
FROM   sales.customers AS sc
       INNER JOIN
       sales.orders AS so
       ON sc.customer_id = so.customer_id;

-- Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.
SELECT sc.first_name + ' ' + sc.last_name AS full_name,
       order_id,
       order_status
FROM   sales.customers AS sc
       LEFT OUTER JOIN
       sales.orders AS so
       ON sc.customer_id = so.customer_id;
       