--Section 3 — JOINs

--Task 12: List every product along with its brand name and category name.

--SELECT
--    p.product_name,
--    b.brand_name,
--    c.category_name
--FROM production.products AS p
--INNER JOIN production.brands AS b
--    ON p.brand_id = b.brand_id
--INNER JOIN production.categories AS c
--    ON p.category_id = c.category_id;

-- Task 13: List all orders with the customer's full name,
-- order date, and order status.

--SELECT
--    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
--    o.order_date,
--    o.order_status
--FROM sales.orders AS o
--INNER JOIN sales.customers AS c
--    ON o.customer_id = c.customer_id;

--Task 14:  Show every order item with the product name, quantity, list price, and discount.

--SELECT
--    P.PRODUCT_NAME,
--    OI.QUANTITY,
--    OI.LIST_PRICE,
--    OI.DISCOUNT
--FROM SALES.ORDER_ITEMS AS OI
--INNER JOIN PRODUCTION.PRODUCTS AS P
--    ON OI.PRODUCT_ID = P.PRODUCT_ID;

--Task 15:  List each staff member's full name alongside their store name.

--SELECT
--    CONCAT(s.first_name, ' ', s.last_name) AS full_name,
--    st.store_name
--FROM sales.staffs AS s
--INNER JOIN sales.stores AS st
--    ON s.store_id = st.store_id;

--Task 16:  List staff members along with their manager's full name.
----Hint: Use a self-join on the sales.staffs table using manager_id.

--SELECT
--    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
--    CONCAT(m.first_name, ' ', m.last_name) AS manager_name
--FROM sales.staffs AS s
--LEFT JOIN sales.staffs AS m
--    ON s.manager_id = m.staff_id;
--Task 17:  Show all stores and the products they ha
--ve in stock, including the product name and quantity. Only show items where quantity > 0.

--SELECT
--    s.store_name,
--    p.product_name,
--    st.quantity
--FROM production.stocks AS st
--INNER JOIN sales.stores AS s
--    ON st.store_id = s.store_id
--INNER JOIN production.products AS p
--    ON st.product_id = p.product_id
--WHERE st.quantity > 0;

--Task 18:  List all customers who placed at least one order. Show customer name and order date.

--SELECT
--    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
--    o.order_date
--FROM sales.customers AS c
--INNER JOIN sales.orders AS o
--    ON c.customer_id = o.customer_id;
--Task 19:  List ALL customers and their orders (if any). Customers who never ordered should still appear with NULL order data.

--SELECT
--    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
--    o.order_id,
--    o.order_date,
--    o.order_status
--FROM sales.customers AS c
--LEFT JOIN sales.orders AS o
--    ON c.customer_id = o.customer_id;



