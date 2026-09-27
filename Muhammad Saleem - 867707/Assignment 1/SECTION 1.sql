

--Task 1:  List all products with their name, model year, and list price.
SELECT PRODUCT_NAME , MODEL_YEAR, LIST_PRICE FROM production.products

--Task 2:  Find all products whose list price is greater than 1000. Show product name and price.
SELECT PRODUCT_NAME, LIST_PRICE FROM production.products WHERE list_price>1000

--Task 3:  List all customers from the state of New York (NY).
SELECT first_name FROM sales.customers WHERE state= 'NY';

--Task 4:  Find all orders placed in the year 2017.
SELECT ORDER_ID FROM sales.orders WHERE ORDER_DATE>= '2017-01-01' AND ORDER_DATE<'2018-01-01' 

--Task 5:  List products whose name contains the word 'Trek'.
SELECT PRODUCT_NAME FROM production.products WHERE PRODUCT_NAME LIKE '%TREK%'

--Task 6:  Find all products priced between 500 and 1500.
SELECT PRODUCT_NAME,LIST_PRICE FROM production.products WHERE LIST_PRICE >=500 AND LIST_PRICE<=1500

--Task 7:  List all distinct cities where customers are located.
SELECT DISTINCT city FROM sales.customers

--Task 8:  Find all orders that have NOT been shipped yet.
SELECT ORDER_ID FROM sales.orders WHERE shipped_date IS NULL