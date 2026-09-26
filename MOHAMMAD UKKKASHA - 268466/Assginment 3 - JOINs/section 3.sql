--- SECTION 3 JOINS

-- TASK 12

SELECT
B.brand_name,
C.category_name
FROM production.products AS P
INNER JOIN production.brands AS B
ON P.brand_id = B.brand_id
INNER JOIN production.categories AS C
ON P.category_id = C.category_id ;


-- TASK 13 

SELECT 
C.first_name + ' ' + C.last_name,
O.order_date,
O.order_status
FROM sales.orders AS O
INNER JOIN sales.customers AS C
ON O.customer_id = C.customer_id;


-- TASK 14 

SELECT 
OI.order_id,
P.product_name,
OI.quantity,
OI.list_price,
OI.discount
FROM sales.order_items AS OI
INNER JOIN production.products AS P
ON OI.product_id = P.product_id;


-- TASK 15 

SELECT 
STF.first_name + ' ' + STF.last_name,
STO.store_name
FROM sales.staffs AS STF
INNER JOIN sales.stores AS STO
ON STF.store_id = STO.store_id;


---TASK 16

SELECT 
S.first_name ,
S.last_name,
M.first_name + ' ' + M.last_name AS Manger_FullName
FROM sales.staffs AS S
JOIN sales.staffs AS M
ON S.staff_id = M.manager_id;


--- TASK 17 

SELECT 
SR.store_name,
P.product_name,
SO.quantity
FROM sales.stores AS SR
INNER JOIN production.stocks AS SO
ON SR.store_id = SO.store_id
INNER JOIN production.products AS P
ON SO.product_id = P.product_id
WHERE SO.quantity > 0;



--- TASK 18

SELECT 
C.first_name,
C.last_name,
O.order_date
FROM sales.orders AS O
INNER JOIN sales.customers AS C
ON O.customer_id = C.customer_id;

--- TASK 19
SELECT 
C.first_name,
C.last_name,
O.order_date
FROM sales.customers AS C
LEFT JOIN sales.orders AS O
ON O.customer_id = C.customer_id;
