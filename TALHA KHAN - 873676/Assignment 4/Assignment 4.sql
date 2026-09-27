
USE BikeStores;
GO


   ---SELF JOIN
  

-- Task 41: List each staff member alongside their manager's full name. If a staff member has no manager (top-level), still show them with NULL for manager name.

SELECT
    e.first_name + ' ' + e.last_name AS staff_full_name,
    m.first_name + ' ' + m.last_name AS manager_full_name
FROM sales.staffs AS e
LEFT JOIN sales.staffs AS m
    ON e.manager_id = m.staff_id;



-- Task 42: Find pairs of products from the same brand that have the exact same list price. Show both product names and the brand name.
SELECT
    b.brand_name,
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    p1.list_price
FROM production.products AS p1
INNER JOIN production.products AS p2
    ON p1.brand_id = p2.brand_id
    AND p1.list_price = p2.list_price
    AND p1.product_id < p2.product_id   
INNER JOIN production.brands AS b
    ON p1.brand_id = b.brand_id
ORDER BY b.brand_name, p1.list_price;



  --- CROSS JOIN
   

-- Task 45: Generate a list of every possible combination of brand and category.Show brand name and category name.

SELECT
    b.brand_name,
    c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c
ORDER BY b.brand_name, c.category_name;


-- Task 46: Using the CROSS JOIN of brands and categories, find brand-category combinations that have NO products (LEFT JOIN the cross join result against products, filter for NULLs).

SELECT
    bc.brand_name,
    bc.category_name
FROM (
    SELECT
        b.brand_id,
        b.brand_name,
        c.category_id,
        c.category_name
    FROM production.brands AS b
    CROSS JOIN production.categories AS c
) AS bc
LEFT JOIN production.products AS p
    ON bc.brand_id = p.brand_id
    AND bc.category_id = p.category_id
WHERE p.product_id IS NULL
ORDER BY bc.brand_name, bc.category_name;


   ---RIGHT JOIN

-- Task 49: List all brands and the products that belong to them. Ensure ALL brands appear, even if they have no products. Use a RIGHT JOIN.

SELECT
    b.brand_name,
    p.product_name
FROM production.products AS p
RIGHT JOIN production.brands AS b
    ON p.brand_id = b.brand_id
ORDER BY b.brand_name;


-- Task 50: Show all stores and the orders placed at each store. Use a RIGHT JOIN so that stores with zero orders still appear.

SELECT
    st.store_name,
    o.order_id,
    o.order_date
FROM sales.orders AS o
RIGHT JOIN sales.stores AS st
    ON o.store_id = st.store_id
ORDER BY st.store_name, o.order_date;


   ---- LEFT ANTI JOIN (LEFT JOIN + WHERE IS NULL)

-- Task 53: Find all customers who have NEVER placed an order.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Task 54: Find all products that are NOT currently in stock at ANY store.
SELECT
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN production.stocks AS s
    ON p.product_id = s.product_id
WHERE s.store_id IS NULL;


-- Task 56: Find all products that have never been ordered.

SELECT
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;


-- Task 59: Find categories where no product has a list price above 2000.
SELECT
    c.category_id,
    c.category_name
FROM production.categories AS c
LEFT JOIN (
    SELECT DISTINCT category_id
    FROM production.products
    WHERE list_price > 2000
) AS expensive_cats
    ON c.category_id = expensive_cats.category_id
WHERE expensive_cats.category_id IS NULL;


-- Task 60: Find customers who placed orders but never ordered any product from the brand 'Trek'.

SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name
FROM sales.customers AS c
INNER JOIN sales.orders AS o          -- customers who did order something
    ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT DISTINCT o2.customer_id
    FROM sales.orders AS o2
    INNER JOIN sales.order_items AS oi
        ON o2.order_id = oi.order_id
    INNER JOIN production.products AS p
        ON oi.product_id = p.product_id
    INNER JOIN production.brands AS b
        ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) AS trek_customers
    ON c.customer_id = trek_customers.customer_id
WHERE trek_customers.customer_id IS NULL;

