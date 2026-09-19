 -- task 41 
 SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name
FROM sales.staffs s
LEFT JOIN sales.staffs m 
    ON s.manager_id = m.staff_id;


    --- task 42 

    SELECT 
    b.brand_name,
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    p1.list_price
FROM production.products p1
JOIN production.products p2 
    ON p1.brand_id = p2.brand_id 
   AND p1.list_price = p2.list_price 
   AND p1.product_id < p2.product_id
JOIN production.brands b 
    ON p1.brand_id = b.brand_id;



    -- Task  43 
    SELECT 
    CONCAT(c1.first_name, ' ', c1.last_name) AS customer_1,
    CONCAT(c2.first_name, ' ', c2.last_name) AS customer_2,
    c1.city,
    c1.state
FROM sales.customers c1
JOIN sales.customers c2 
    ON c1.city = c2.city 
   AND c1.state = c2.state 
   AND c1.customer_id < c2.customer_id;


   -- Task 44 
   SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    s.store_id
FROM sales.staffs s
JOIN sales.staffs m 
    ON s.manager_id = m.staff_id 
   AND s.store_id = m.store_id;

 --  Cross Join Tasks
    --Task 45

    SELECT 
    b.brand_name,
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c;

-- Task 46 

SELECT 
    b.brand_name,
    c.category_name
FROM production.brands b
CROSS JOIN production.categories c
LEFT JOIN production.products p 
    ON b.brand_id = p.brand_id 
   AND c.category_id = p.category_id
WHERE p.product_id IS NULL;


---task 47 
SELECT 
    s.store_name,
    p.product_name,
    ISNULL(st.quantity, 0) AS stock_quantity
FROM sales.stores s
CROSS JOIN production.products p
LEFT JOIN production.stocks st 
    ON s.store_id = st.store_id 
   AND p.product_id = st.product_id;


   -- Task 48 

   SELECT 
    CONCAT(st.first_name, ' ', st.last_name) AS staff_name,
    s.store_name,
    CASE 
        WHEN st.store_id = s.store_id THEN 'Actual Assignment'
        ELSE 'Possible Combo'
    END AS assignment_status
FROM sales.staffs st
CROSS JOIN sales.stores s;



          -- Right Join Tasks
          -- Task 49

          SELECT 
    p.product_name,
    b.brand_name
FROM production.products p
RIGHT JOIN production.brands b 
    ON p.brand_id = b.brand_id;


    -- Task 50 

    SELECT 
    s.store_name,
    o.order_id
FROM sales.orders o
RIGHT JOIN sales.stores s 
    ON o.store_id = s.store_id;

    -- Task 51 
    SELECT 
    c.category_name,
    COUNT(p.product_id) AS total_products
FROM production.products p
RIGHT JOIN production.categories c 
    ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name;

-- Task 52 

SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    o.order_id
FROM sales.orders o
RIGHT JOIN sales.staffs s 
    ON o.staff_id = s.staff_id;



    --Left Anti Join Tasks
    -- Task 53 

    SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM sales.customers c
LEFT JOIN sales.orders o 
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Task 54 

SELECT 
    p.product_id,
    p.product_name
FROM production.products p
LEFT JOIN production.stocks s 
    ON p.product_id = s.product_id
WHERE s.store_id IS NULL;


--Task 55

SELECT 
    b.brand_id,
    b.brand_name
FROM production.brands b
LEFT JOIN production.products p 
    ON b.brand_id = p.brand_id
WHERE p.product_id IS NULL;


--Task 56

SELECT 
    p.product_id,
    p.product_name
FROM production.products p
LEFT JOIN sales.order_items oi 
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;


--Task 57 
SELECT 
    s.store_id,
    s.store_name
FROM sales.stores s
LEFT JOIN sales.staffs st 
    ON s.store_id = st.store_id
WHERE st.staff_id IS NULL;


-- Task 58 

SELECT 
    st.staff_id,
    CONCAT(st.first_name, ' ', st.last_name) AS staff_name
FROM sales.staffs st
LEFT JOIN sales.orders o 
    ON st.staff_id = o.staff_id
WHERE o.order_id IS NULL;

-- Task 59
SELECT 
    c.category_id,
    c.category_name
FROM production.categories c
LEFT JOIN (
    SELECT DISTINCT category_id 
    FROM production.products 
    WHERE list_price > 2000
) p_expensive 
    ON c.category_id = p_expensive.category_id
WHERE p_expensive.category_id IS NULL;

-- Task 60 


SELECT DISTINCT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM sales.customers c
JOIN sales.orders o 
    ON c.customer_id = o.customer_id
LEFT JOIN (
    SELECT DISTINCT o2.customer_id
    FROM sales.orders o2
    JOIN sales.order_items oi ON o2.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.brands b ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
) trek_buyers 
    ON c.customer_id = trek_buyers.customer_id
WHERE trek_buyers.customer_id IS NULL;


       ---DONE ALL ASSIMENT 
