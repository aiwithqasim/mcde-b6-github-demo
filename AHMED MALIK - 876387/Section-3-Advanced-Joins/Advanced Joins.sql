


---- # SELF JOIN #  ----

-- Task 41 is Completed!! --

SELECT
    s.first_name + ' ' + s.last_name AS staff_name,
    m.first_name + ' ' + m.last_name AS manager_name
FROM sales.staffs AS s
LEFT JOIN sales.staffs AS m
   ON s.manager_id = m.staff_id;

-----------------------------------------------------

--  Task 42 is Completed!! --

SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    b.brand_name,
    p1.list_price
FROM production.products AS p1
JOIN production.products AS p2
    ON p1.brand_id = p2.brand_id
    AND p1.list_price = p2.list_price
    AND p1.product_id < p2.product_id
JOIN production.brands AS b
    ON p1.brand_id = b.brand_id;


-------x---------------x---------------x-------------


--- # CROSS JOIN # ---

-- Task 45 is Completed!! --

SELECT
     b.brand_name,
     c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c


---------------------------------------------------


-- Task 46 is Completed!! --

SELECT
     b.brand_name,
     c.category_name
FROM production.brands AS b
CROSS JOIN production.categories AS c
LEFT JOIN production.products AS p
  ON p.brand_id = b.brand_id
  AND  p.category_id = c.category_id
WHERE p.product_id IS NULL;


-----x-----------x--------------x---------------x--------------


--- # RIGHT JOIN # ---

-- Task is 49 is Completed!! --

SELECT 
    b.brand_name,
    p.product_name
FROM production.products AS p
RIGHT JOIN production.brands AS b
  ON p.brand_id  = b.brand_id;


------------------------------------------------------


-- Task 50 is Completed!! --

SELECT
    s.store_name,
    o.order_id,
    o.order_date
FROM sales.orders AS o
RIGHT JOIN sales.stores AS s
   ON o.store_id = s.store_id;


----------x----------------x----------------x--------------
   
    
--- # LEFT ANTI JOIN + WHERE IS NULL # ----

-- Task 53 is Completed!! --

SELECT
   c.customer_id,
   c.first_name,
   c.last_name
FROM  sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


----------------------------------------------------


-- Task 54 is Completed!! --

SELECT
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN production.stocks AS s
    ON p.product_id = s.product_id
WHERE s.store_id IS NULL;


---------------------------------------------------


-- Task 56 is Completed!! --

SELECT
    p.product_id,
    p.product_name
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;


----------------------------------------------------


-- Task 59 is completed!! --


