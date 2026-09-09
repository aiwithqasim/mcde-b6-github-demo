			--Assignment 4 JOINS TASK 
use BikeStores;
go

                                    --SELF JOIN:

--Task 41:List each staff member alongside their manager's full name. If a staff member has no manager
--(top-level), still show them with NULL for manager name.
SELECT 
    e.first_name + ' ' + e.last_name AS employee,
    m.first_name + ' ' + m.last_name AS manager
FROM 
    sales.staffs e
LEFT JOIN 
    sales.staffs m ON e.manager_id = m.staff_id;

--Task 41: END


--Task 42:Find pairs of products from the same brand that have the exact same list price.
--Show both product names and the brand name.
SELECT 
    b.brand_name,
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    p1.list_price
FROM 
    production.products p1
INNER JOIN 
    production.products p2 ON p1.brand_id = p2.brand_id 
                          AND p1.list_price = p2.list_price 
                          AND p1.product_id < p2.product_id
INNER JOIN 
    production.brands b ON p1.brand_id = b.brand_id;

--Task 42:END


--Task 43:Find all pairs of customers who live in the same city and state.Avoid duplicates
--(don't show A-B and B-A both).
SELECT 
    c1.first_name + ' ' + c1.last_name AS customer_1,
    c2.first_name + ' ' + c2.last_name AS customer_2,
    c1.city,
    c1.state
FROM 
    sales.customers c1
INNER JOIN 
    sales.customers c2 ON c1.city = c2.city 
                      AND c1.state = c2.state 
                      AND c1.customer_id < c2.customer_id;

--Task 43:END


--Task 44:List staff members who were hired at the same store as their manager.
SELECT 
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name,
    st.store_name
FROM 
    sales.staffs s
INNER JOIN 
    sales.staffs m ON s.manager_id = m.staff_id 
                  AND s.store_id = m.store_id
INNER JOIN 
    sales.stores st ON s.store_id = st.store_id;

--Task 44 END

                                    --Cross Join
--Task 45: Generate a list of every possible combination of brand and category. Show brand name and category name.
SELECT 
    b.brand_name,
    c.category_name
FROM 
    production.brands b
CROSS JOIN 
    production.categories c
ORDER BY 
    b.brand_name, 
    c.category_name;

--Task 45: END


--Task 46: Using the result of a CROSS JOIN between brands and categories, find brand-category combinations
--that have NO products (LEFT JOIN the cross join result against products and filter for NULLs).
SELECT 
    b.brand_name,
    c.category_name
FROM 
    production.brands b
CROSS JOIN 
    production.categories c
LEFT JOIN 
    production.products p ON b.brand_id = p.brand_id 
                         AND c.category_id = p.category_id
WHERE 
    p.product_id IS NULL
ORDER BY 
    b.brand_name, 
    c.category_name;

--Task 46: END


--Task 47: Generate a report showing every store paired with every product, along with the stock quantity. 
--If a store doesn't carry a product, show 0.
SELECT 
    st.store_name,
    p.product_name,
    ISNULL(s.quantity, 0) AS stock_quantity
FROM 
    sales.stores st
CROSS JOIN 
    production.products p
LEFT JOIN 
    production.stocks s ON st.store_id = s.store_id 
                       AND p.product_id = s.product_id
ORDER BY 
    st.store_name, 
    p.product_name;

--Task 47:END


--Task 48:Create all possible staff-store assignments (every staff paired with every store), 
--then show which ones are the actual current assignments.
SELECT 
    st.first_name + ' ' + st.last_name AS staff_name,
    s.store_name,
    CASE 
        WHEN st.store_id = s.store_id THEN 'Yes'
        ELSE 'No'
    END AS is_actual_assignment
FROM 
    sales.staffs st
CROSS JOIN 
    sales.stores s
ORDER BY 
    staff_name, 
    store_name;

--Task 48:END
                      --RIGHT JOINS

--Task 49:List all brands and the products that belong to them. Ensure ALL brands appear, even if they 
--have no products. Use a RIGHT JOIN (products RIGHT JOIN brands).
SELECT 
    b.brand_name,
    p.product_name
FROM 
    production.products p
RIGHT JOIN 
    production.brands b ON p.brand_id = b.brand_id
ORDER BY 
    b.brand_name;

--Task 49:END


--Task 50: Show all stores and the orders placed at each store. Use a RIGHT JOIN so that stores with zero 
--orders still appear.
SELECT 
    ss.store_name,
    so.order_id,
    so.order_date,
    so.order_status
FROM 
    sales.orders so
RIGHT JOIN 
    sales.stores ss ON so.store_id = ss.store_id
ORDER BY 
    ss.store_name, 
    so.order_id;

--Task 50:END


--Task 51: List all categories with their product count. Use a RIGHT JOIN to ensure categories with no
--products show a count of 0.
SELECT 
    c.category_name,
    COUNT(p.product_id) AS total_products
FROM 
    production.products p
RIGHT JOIN 
    production.categories c ON p.category_id = c.category_id
GROUP BY 
    c.category_id, 
    c.category_name
ORDER BY 
    c.category_name;
    
--Task 51: END


--Task 52:Show all staff members and the orders they handled. Use a RIGHT JOIN on orders RIGHT JOIN staffs,
--so staff who handled zero orders still appear.
SELECT 
    st.staff_id,
    st.first_name + ' ' + st.last_name AS staff_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM 
    sales.orders o
RIGHT JOIN 
    sales.staffs st ON o.staff_id = st.staff_id
ORDER BY 
    st.staff_id, 
    o.order_id;

--Task 52:END
                        --Left Anti Join (LEFT JOIN + WHERE IS NULL)

--Task 53:Find all customers who have NEVER placed an order.
SELECT 
    s.customer_id,
    s.first_name + ' ' + s.last_name AS full_name,
    so.order_id
FROM 
    sales.customers s
LEFT JOIN 
    sales.orders so ON s.customer_id = so.customer_id
WHERE 
    so.order_id IS NULL;

--Task 53:END


--Task 54: Find all products that are NOT currently in stock at ANY store.
SELECT 
    p.product_id,
    p.product_name
FROM 
    production.products p
LEFT JOIN 
    production.stocks st ON p.product_id = st.product_id
WHERE 
    st.store_id IS NULL
ORDER BY 
    p.product_name;

--Task 54:END


--Task 55: Find brands that have NO products in the database.
SELECT 
    b.brand_id,
    b.brand_name
FROM 
    production.brands b
LEFT JOIN 
    production.products pp ON b.brand_id = pp.brand_id
WHERE 
    pp.product_id IS NULL
ORDER BY 
    b.brand_name;

--Task 55:END


--Task 56:Find all products that have never been ordered.
SELECT 
    p.product_id,
    p.product_name
FROM 
    production.products p
LEFT JOIN 
    sales.order_items oi ON p.product_id = oi.product_id
WHERE 
    oi.order_id IS NULL
ORDER BY 
    p.product_name;

--Task 56:END

--Task 57:Find stores that have never had any staff assigned to them.
SELECT 
    st.store_id,
    st.store_name
FROM 
    sales.stores st
LEFT JOIN 
    sales.staffs sf ON st.store_id = sf.store_id
WHERE 
    sf.staff_id IS NULL;

--Task 57:END


--Task 58: Find staff members who have never handled a single order.
SELECT 
    sf.staff_id,
    sf.first_name + ' ' + sf.last_name AS staff_name
FROM 
    sales.staffs sf
LEFT JOIN 
    sales.orders so ON sf.staff_id = so.staff_id
WHERE 
    so.order_id IS NULL;

--Task 58: END


--Task 59: Find categories where no product has a list price above 2000.
SELECT 
    c.category_id,
    c.category_name
FROM 
    production.categories c
LEFT JOIN 
    production.products p ON c.category_id = p.category_id
GROUP BY 
    c.category_id, 
    c.category_name
HAVING 
    MAX(p.list_price) <= 2000 
    OR MAX(p.list_price) IS NULL;

--Task 59: END


--Task 60: Find customers who placed orders but never ordered any product from the brand 'Trek'.
SELECT DISTINCT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name
FROM 
    sales.customers c
INNER JOIN 
    sales.orders o ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT DISTINCT o2.customer_id
    FROM sales.orders o2
    INNER JOIN sales.order_items oi ON o2.order_id = oi.order_id
    INNER JOIN production.products p ON oi.product_id = p.product_id
    INNER JOIN production.brands b ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) trek_orders ON c.customer_id = trek_orders.customer_id
WHERE 
    trek_orders.customer_id IS NULL
ORDER BY 
    customer_name;
--Task 60: END
