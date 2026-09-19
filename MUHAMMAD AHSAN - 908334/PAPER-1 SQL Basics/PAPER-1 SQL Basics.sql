
/*List every order with the customer's full name, 
store name, and the full name of the staff member who handled it*/
SELECT
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    st.store_name,
    s.first_name + ' ' + s.last_name AS staff_name
FROM sales.orders AS o
INNER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN sales.stores AS st
    ON o.store_id = st.store_id
INNER JOIN sales.staffs AS s
    ON o.staff_id = s.staff_id;

/*)  Show each product with its brand name and category name. 
Include products even if they have no brand or category assigned*/
SELECT
    p.product_name,
    b.brand_name,
    c.category_name
FROM production.products AS p
LEFT JOIN production.brands AS b
    ON p.brand_id = b.brand_id
LEFT JOIN production.categories AS c
    ON p.category_id = c.category_id;

/*Find all customers who have never placed an order. Return their name, city, and email*/
SELECT
    c.first_name + ' ' + c.last_name AS full_name,
	c.city,
	c.email
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;





