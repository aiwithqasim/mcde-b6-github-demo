--TASK-45

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

--TASK-46

SELECT 
    b.brand_name,
    c.category_name
FROM 
    production.brands b
CROSS JOIN 
    production.categories c
LEFT JOIN 
    production.products p 
    ON p.brand_id = b.brand_id 
   AND p.category_id = c.category_id
WHERE 
    p.product_id IS NULL
ORDER BY 
    b.brand_name, 
    c.category_name;

--TASK-47

SELECT 
    s.store_name,
    p.product_name,
    ISNULL(st.quantity, 0) AS stock_quantity
FROM sales.stores AS s
CROSS JOIN production.products AS p
LEFT JOIN production.stocks AS st
    ON s.store_id = st.store_id AND p.product_id = st.product_id
ORDER BY s.store_name, p.product_name;

--TASK-48

SELECT 
    st.first_name+' '+st.last_name as staff_name,
    ss.store_name
FROM sales.staffs as st
CROSS JOIN sales.stores as ss
order by
 staff_name,
 ss.store_name;