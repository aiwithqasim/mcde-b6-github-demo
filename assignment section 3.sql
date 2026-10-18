
                                                                            (SECTION NO 3)

 --TASK 1

SELECT
    p.product_name,
    pc.category_name,
    pb.brand_name
FROM production.products AS p
inner join production.categories as pc
    ON p.category_id = pc.category_id
    INNER JOIN production.brands AS pb
    ON p.brand_id = pb.brand_id

--TASK 2

 SELECT
    P.FIRST_NAME + ' ' + P.LAST_NAME AS FULL_NAME,
    O.ORDER_DATE, O.ORDER_STATUS
 FROM SALES.ORDERS AS O
 INNER JOIN SALES.CUSTOMERS AS P
   ON O.CUSTOMER_ID = P.CUSTOMER_ID;

--TASK 3

SELECT
P.PRODUCT_NAME, OI.LIST_PRICE,
OI.QUANTITY, OI.DISCOUNT
FROM SALES.ORDER_ITEMS AS OI
INNER JOIN PRODUCTION.PRODUCTS AS P
ON OI.PRODUCT_ID = P.PRODUCT_ID;

--TASK 4

SELECT
s.first_name, + ' ' + s.last_name as full_name, ss.store_name
from sales.staffs as s
inner join sales.stores as ss
on s.store_id = ss.store_id;

--task 5
 select 
 s1.first_name + '  ' + s1.last_name as employee,
 s2.first_name + '  ' + s2.last_name as manager
 from sales.staffs as s1
 left join sales.staffs as s2
 on s2.staff_id = s1.manager_id;


 
--TASK 6;
SELECT stocks.quantity, ss.store_name,p.product_name
from production.stocks as stocks
inner join sales.stores as ss
ON stocks.store_id = ss.store_id
inner join production.products as p
ON stocks.product_id = p.product_id
where stocks.quantity > 0;

--TASK 7;
SELECT cust.first_name,cust.last_name,orders.order_date
FROM sales.customers AS cust
inner join sales.orders AS orders
ON cust.customer_id = orders.customer_id

--TASK 8;
SELECT cust.first_name,cust.last_name,orders.order_date
FROM sales.customers AS cust
left join sales.orders AS orders
ON cust.customer_id = orders.customer_id



























































