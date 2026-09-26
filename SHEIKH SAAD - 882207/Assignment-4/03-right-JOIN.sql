--TASK-49

SELECT 
    b.brand_name,
    p.product_name
FROM 
    production.products AS p
RIGHT JOIN 
    production.brands AS b
    ON p.brand_id = b.brand_id
ORDER BY 
    b.brand_name, 
    p.product_name;

--TASK-50
SELECT 
    s.store_id,
    s.store_name,
    o.order_id,
    o.order_date,
    o.order_status
FROM 
    sales.orders o
RIGHT JOIN 
    sales.stores s
    ON o.store_id = s.store_id
ORDER BY 
    s.store_id, 
    o.order_id;

--TASK-51

SELECT 
    c.category_name,
    COUNT(p.product_id) AS total_products
FROM 
    production.products p
RIGHT JOIN 
    production.categories c
    ON p.category_id = c.category_id
GROUP BY 
    c.category_id, 
    c.category_name
ORDER BY 
    total_products DESC, 
    c.category_name;

--TASK-52

SELECT 
    st.staff_id,
    st.first_name+ ' '+ st.last_name AS staff_name,
    st.email,
    o.order_id,
    o.order_date
FROM 
    sales.orders o
RIGHT JOIN 
    sales.staffs st 
    ON o.staff_id = st.staff_id
ORDER BY 
    st.staff_id, 
    o.order_id;