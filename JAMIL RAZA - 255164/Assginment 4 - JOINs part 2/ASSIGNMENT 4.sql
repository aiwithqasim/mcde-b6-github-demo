--- ASSIGNMENT 4

-- SELF JOIN

-- TASK 41: 

SELECT 
S.staff_id,
S.first_name + ' ' + S.last_name AS Staff_Name,
S.manager_id,
M.first_name + ' ' + M.last_name AS Manger_Name
FROM sales.staffs AS S
LEFT JOIN sales.staffs AS M
ON S.manager_id = M.staff_id

-- TASK 42

SELECT
	B.brand_name,
	P1.product_name,
	P2.product_name,
	P1.list_price
FROM production.products AS P1
INNER JOIN production.products AS P2
ON P1.brand_id = P2.brand_id
AND P1.list_price = P2.list_price
AND P1.product_id < P2.product_id
INNER JOIN production.brands AS B
ON P1.brand_id =  B.brand_id
ORDER BY P1.list_price DESC


-- TASK 43

SELECT 
	C1.first_name + ' ' + C1.last_name AS C1_full_name,
	C2.first_name + ' ' + C2.last_name AS C2_full_name
FROM sales.customers AS C1
INNER JOIN sales.customers AS C2
ON  C1.city = C2.city AND C1.state = C2.state 
AND C1.customer_id < C2.customer_id
ORDER BY C1_full_name ASC

--task 44

SELECT 
	S1.staff_id,
	S1.first_name + ' ' + S1.last_name AS emp_fullname,
	S1.manager_id,
	S2.first_name + ' ' + S2.last_name AS mang_fullname,
	S1.store_id,
	S2.store_id
FROM sales.staffs AS S1
INNER JOIN sales.staffs AS S2
ON S1.manager_id = S2.staff_id
WHERE S1.store_id = S2.store_id


--- CROSS JOIN
-- task 45

SELECT 
	B.brand_name,
	C.category_name
FROM production.brands B
CROSS JOIN production.categories C

-- task 46

SELECT 
	B.brand_name,
	C.category_name,
	P.product_name
FROM production.brands B
CROSS JOIN production.categories C
LEFT JOIN production.products P
ON P.brand_id = B.brand_id
AND P.category_id = C.category_id
WHERE P.product_id IS NULL


-- TASK 47

SELECT
	S1.store_name,
	P.product_name,
	ISNULL(S2.quantity,0) AS quantity
FROM sales.stores S1
CROSS JOIN production.products P
LEFT JOIN production.stocks S2
ON P.product_id = S2.product_id
AND S2.store_id = S1.store_id

--- TASK 48

SELECT
    STA.first_name + ' ' + STA.last_name AS staff_name,
    STO.store_name,
    CASE 
        WHEN STA.store_id = STO.store_id THEN 'Actual Assignment'
        ELSE 'Hypothetical'
    END AS assignment_status
FROM sales.staffs STA
CROSS JOIN sales.stores STO
ORDER BY STA.staff_id, STO.store_id;


---- RIGHT JOINS

-- Task 49
SELECT
    B.brand_name,
    P.product_name
FROM production.products P
RIGHT JOIN production.brands B
    ON P.brand_id = B.brand_id
ORDER BY B.brand_name;


-- Task 50
SELECT
    ST.store_name,
    O.order_id,
    O.order_date,
    O.order_status
FROM sales.orders O
RIGHT JOIN sales.stores ST
    ON O.store_id = ST.store_id
ORDER BY ST.store_name;


-- Task 51
SELECT
    C.category_name,
    COUNT(P.product_id) AS product_count
FROM production.products P
RIGHT JOIN production.categories C
    ON P.category_id = C.category_id
GROUP BY C.category_name
ORDER BY product_count DESC;


-- Task 52
SELECT
    STA.first_name + ' ' + STA.last_name AS staff_name,
    O.order_id,
    O.order_date
FROM sales.orders O
RIGHT JOIN sales.staffs STA
    ON O.staff_id = STA.staff_id
ORDER BY staff_name;

---- LEFT ANTI JOIN

-- Task 53
SELECT
    C.customer_id,
    C.first_name + ' ' + C.last_name AS customer_name,
    C.email
FROM sales.customers C
LEFT JOIN sales.orders O
    ON C.customer_id = O.customer_id
WHERE O.order_id IS NULL;


-- Task 54
SELECT
    P.product_id,
    P.product_name
FROM production.products P
LEFT JOIN production.stocks SK
    ON P.product_id = SK.product_id
WHERE SK.store_id IS NULL;


-- Task 55
SELECT
    B.brand_id,
    B.brand_name
FROM production.brands B
LEFT JOIN production.products P
    ON B.brand_id = P.brand_id
WHERE P.product_id IS NULL;


-- Task 56
SELECT
    P.product_id,
    P.product_name
FROM production.products P
LEFT JOIN sales.order_items OI
    ON P.product_id = OI.product_id
WHERE OI.order_id IS NULL;


-- Task 57
SELECT
    ST.store_id,
    ST.store_name
FROM sales.stores ST
LEFT JOIN sales.staffs STA
    ON ST.store_id = STA.store_id
WHERE STA.staff_id IS NULL;


-- Task 58
SELECT
    STA.staff_id,
    STA.first_name + ' ' + STA.last_name AS staff_name
FROM sales.staffs STA
LEFT JOIN sales.orders O
    ON STA.staff_id = O.staff_id
WHERE O.order_id IS NULL;


-- Task 59
SELECT
    C.category_id,
    C.category_name
FROM production.categories C
LEFT JOIN production.products P
    ON C.category_id = P.category_id
    AND P.list_price > 2000          -- filter JOIN mein, WHERE mein nahi
WHERE P.product_id IS NULL;


-- Task 60
SELECT DISTINCT
    C.customer_id,
    C.first_name + ' ' + C.last_name AS customer_name
FROM sales.customers C
INNER JOIN sales.orders O                    
    ON C.customer_id = O.customer_id
LEFT JOIN (
        SELECT DISTINCT O2.customer_id
    FROM sales.orders O2
    INNER JOIN sales.order_items OI ON O2.order_id = OI.order_id
    INNER JOIN production.products P ON OI.product_id = P.product_id
    INNER JOIN production.brands B ON P.brand_id = B.brand_id
    WHERE B.brand_name = 'Trek'
) AS TREK
    ON C.customer_id = TREK.customer_id
WHERE TREK.customer_id IS NULL;