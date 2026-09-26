--TASK-53

SELECT 
    c.customer_id,
    c.first_name+ ' '+ c.last_name AS customer_name
FROM 
    sales.customers AS c
LEFT JOIN 
    sales.orders AS o 
    ON c.customer_id = o.customer_id
WHERE 
    o.order_id IS NULL
ORDER BY 
    customer_name;

--TASK-54

SELECT 
    p.product_id,
    p.product_name
FROM 
    production.products p
LEFT JOIN 
    production.stocks s 
    ON p.product_id = s.product_id
WHERE 
    s.store_id IS NULL
ORDER BY 
    p.product_name;

--TASK-55

SELECT 
    b.brand_id,
    b.brand_name
FROM 
    production.brands b
LEFT JOIN 
    production.products p 
    ON b.brand_id = p.brand_id
WHERE 
    p.product_id IS NULL
ORDER BY 
    b.brand_name;

--TASK-56
SELECT 
    p.product_id,
    p.product_name
FROM 
    production.products p
LEFT JOIN 
    sales.order_items oi 
    ON p.product_id = oi.product_id
WHERE 
    oi.order_id IS NULL  
ORDER BY 
    p.product_name;

--TASK-57

SELECT 
    s.store_id,
    s.store_name
FROM 
    sales.stores s
LEFT JOIN 
    sales.staffs st 
    ON s.store_id = st.store_id
WHERE 
    st.staff_id IS NULL
ORDER BY 
    s.store_name;

--TASK-58

SELECT 
    st.staff_id,
    st.first_name+ ' '+ st.last_name AS staff_name,
    st.active
FROM 
    sales.staffs st
LEFT JOIN 
    sales.orders o 
    ON st.staff_id = o.staff_id
WHERE 
    o.order_id IS NULL 
ORDER BY 
    staff_name;

--TASK-59

SELECT 
    c.category_id,
    c.category_name
FROM 
    production.categories c
-- Left join against a subquery that finds categories WITH products > 2000
LEFT JOIN 
    (
        SELECT DISTINCT category_id 
        FROM production.products AS p
        WHERE list_price > 2000
    ) AS expensive_categories 
    ON c.category_id = expensive_categories.category_id
WHERE 
    expensive_categories.category_id IS NULL
ORDER BY 
    c.category_name;

--TASK-60

SELECT DISTINCT
    c.customer_id,
    c.first_name+ ' '+ c.last_name AS customer_name
FROM 
    sales.customers c
JOIN 
    sales.orders o ON c.customer_id = o.customer_id
LEFT JOIN 
    (
        SELECT DISTINCT o_sub.customer_id
        FROM sales.orders o_sub
        JOIN sales.order_items oi ON o_sub.order_id = oi.order_id
        JOIN production.products p ON oi.product_id = p.product_id
        JOIN production.brands b ON p.brand_id = b.brand_id
        WHERE b.brand_name = 'Trek'
    ) AS trek_buyers 
    ON c.customer_id = trek_buyers.customer_id
WHERE 
    trek_buyers.customer_id IS NULL
ORDER BY 
    customer_name;

