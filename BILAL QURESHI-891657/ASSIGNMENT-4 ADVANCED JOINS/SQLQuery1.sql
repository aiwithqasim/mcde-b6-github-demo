--task41
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS staff_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name
FROM 
    sales.staffs e
LEFT JOIN 
    sales.staffs m ON e.manager_id = m.staff_id;

    --task42
    SELECT 
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    b.brand_name,
    p1.list_price
FROM 
    production.products p1
JOIN 
    production.products p2 ON p1.brand_id = p2.brand_id 
    AND p1.list_price = p2.list_price 
    AND p1.product_id < p2.product_id
JOIN 
    production.brands b ON p1.brand_id = b.brand_id;

    --task43
    SELECT 
    CONCAT(c1.first_name, ' ', c1.last_name) AS customer_1,
    CONCAT(c2.first_name, ' ', c2.last_name) AS customer_2,
    c1.city,
    c1.state
FROM 
    sales.customers c1
JOIN 
    sales.customers c2 ON c1.city = c2.city 
    AND c1.state = c2.state 
    AND c1.customer_id < c2.customer_id;

    --task44
    SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS staff_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    e.store_id
FROM 
    sales.staffs e
JOIN 
    sales.staffs m ON e.manager_id = m.staff_id
WHERE 
    e.store_id = m.store_id;

    --task45
    SELECT 
    b.brand_name,
    c.category_name
FROM 
    production.brands b
CROSS JOIN 
    production.categories c;

    --task46
    SELECT 
    b.brand_name,
    c.category_name
FROM 
    production.brands b
CROSS JOIN 
    production.categories c
LEFT JOIN 
    production.products p ON b.brand_id = p.brand_id AND c.category_id = p.category_id
WHERE 
    p.product_id IS NULL;

    --task47
    SELECT 
    s.store_name,
    p.product_name,
    COALESCE(st.quantity, 0) AS stock_quantity
FROM 
    sales.stores s
CROSS JOIN 
    production.products p
LEFT JOIN 
    production.stocks st ON s.store_id = st.store_id AND p.product_id = st.product_id;

    --task48
    SELECT 
    stf.first_name,
    stf.last_name,
    s.store_name,
    CASE 
        WHEN stf.store_id = s.store_id THEN 'Actual Assignment'
        ELSE 'Possible Assignment'
    END AS assignment_status
FROM 
    sales.staffs stf
CROSS JOIN 
    sales.stores s;

    --task49
    SELECT 
    b.brand_name,
    p.product_name
FROM 
    production.products p
RIGHT JOIN 
    production.brands b ON p.brand_id = b.brand_id;

    --task50
    SELECT 
    s.store_name,
    o.order_id,
    o.order_date
FROM 
    sales.orders o
RIGHT JOIN 
    sales.stores s ON o.store_id = s.store_id;

    --task51
    SELECT 
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM 
    production.products p
RIGHT JOIN 
    production.categories c ON p.category_id = c.category_id
GROUP BY 
    c.category_name;

    --task52
    SELECT 
    stf.first_name,
    stf.last_name,
    o.order_id,
    o.order_date
FROM 
    sales.orders o
RIGHT JOIN 
    sales.staffs stf ON o.staff_id = stf.staff_id;

    --task53
    SELECT 
    c.customer_id,
    c.first_name,
    c.last_name
FROM 
    sales.customers c
LEFT JOIN 
    sales.orders o ON c.customer_id = o.customer_id
WHERE 
    o.order_id IS NULL;

    --task54
    SELECT 
    p.product_id,
    p.product_name
FROM 
    production.products p
LEFT JOIN 
    production.stocks st ON p.product_id = st.product_id
WHERE 
    st.store_id IS NULL;

    --task55
    SELECT 
    b.brand_id,
    b.brand_name
FROM 
    production.brands b
LEFT JOIN 
    production.products p ON b.brand_id = p.brand_id
WHERE 
    p.product_id IS NULL;

    --task56
    SELECT 
    p.product_id,
    p.product_name
FROM 
    production.products p
LEFT JOIN 
    sales.order_items oi ON p.product_id = oi.product_id
WHERE 
    oi.order_id IS NULL;

    --task57
    SELECT 
    s.store_id,
    s.store_name
FROM 
    sales.stores s
LEFT JOIN 
    sales.staffs stf ON s.store_id = stf.store_id
WHERE 
    stf.staff_id IS NULL;

    --task58
    SELECT 
    stf.staff_id,
    stf.first_name,
    stf.last_name
FROM 
    sales.staffs stf
LEFT JOIN 
    sales.orders o ON stf.staff_id = o.staff_id
WHERE 
    o.order_id IS NULL;

    --task59
    SELECT 
    c.category_id,
    c.category_name
FROM 
    production.categories c
WHERE c.category_id NOT IN (
    SELECT DISTINCT p.category_id 
    FROM production.products p 
    WHERE p.list_price > 2000
);

--task60
SELECT DISTINCT 
    c.customer_id,
    c.first_name,
    c.last_name
FROM 
    sales.customers c
JOIN 
    sales.orders o ON c.customer_id = o.customer_id
WHERE c.customer_id NOT IN (
    SELECT DISTINCT o2.customer_id
    FROM sales.orders o2
    JOIN sales.order_items oi ON o2.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.brands b ON p.brand_id = b.brand_id
    WHERE b.brand_name = 'Trek'
);
 