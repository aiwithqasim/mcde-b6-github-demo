use bikestores;

		--	      		SECTION 3				--

					 -----JOINs-----

	--Task 15: List each staff member's full name alongside their store name.--

	-- SOLUTION:

	SELECT 
	(sta.first_name + ' ' + sta.last_name) as [Full Name] ,
	sto.store_name 
	from sales.staffs as sta
	left join sales.stores as sto
	on sta.store_id = sto.store_id;
	
	-----------------------------------------------------------------------------------------------

	--Task 14:Show every order item with the product name, quantity, list price, and discount.--

	-- SOLUTION:

	select
		pp.product_name as [Order Item] ,
		so.quantity,
		so.list_price,
		so.discount
	from sales.order_items AS so
	join production.products AS pp
	on pp.product_id = so.product_id
	
	----------------------------------------------------------------------------------------------
	--Task 12: List every product along with its brand name and category name.--

	-- SOLUTION:

	SELECT
	pp.product_name,
	pb.brand_name,
	pc.category_name
	from production.products AS pp
	join production.brands AS pb
 	on pp.brand_id = pb.brand_id
	join production.categories AS pc
	on pc.category_id = pp.category_id 
	----------------------------------------------------------------------------------------------
	/*Task 13: List all orders with the customer's full name (first_name + last_name),
	order date, and order status.*/

	-- SOLUTION:

	select 
	(sc.first_name + '  ' + sc.last_name) AS [Customer Name],
	so.order_date,
	so.order_status
	from sales.customers AS sc
	join sales.orders AS so
	on sc.customer_id = so.customer_id
	----------------------------------------------------------------------------------------------

	--Task 16:List Staff Members along with their Managers full name hint: using(Self-Join)--

	-- SOLUTION:
	
	SELECT
		(s1.first_name + ' ' + s1.last_name) AS [Staff Member],
		(s2.first_name + ' ' + s2.last_name) AS [Manager]
	FROM sales.staffs AS s1
	JOIN sales.staffs AS s2
		ON s1.manager_id = s2.staff_id;
	----------------------------------------------------------------------------------------------

	/*TASK 17:Show all stores and the products they have in stock, including the product name and
	quantity. Only show items where quantity > 0.*/

	-- SOLUTION:

	select
	p.product_id,
	s.store_name,
	pp.product_name,
	p.quantity
	from sales.stores AS s
	join production.stocks AS p
	ON s.store_id = p.store_id
	join production.products as pp
	on p.product_id = pp.product_id
	where p.quantity > 0
	order by product_name asc
	----------------------------------------------------------------------------------------------
	/*Task 18: List all customers who placed at least one order.
	Show customer name and order date.
Hint: An INNER JOIN naturally eliminates non-ordering customers.*/
	
	-- SOLUTION:
	
	select 
	(c.first_name + '  ' + c.last_name) AS [Customer Name],
	o.order_date
	from sales.customers AS c
	inner join sales.orders AS o
	on c.customer_id = o.customer_id
	order by [Customer Name] ASC

	----------------------------------------------------------------------------------------------

		/*Task 19: List ALL customers and their orders (if any).
		Customers who never ordered should still
		appear with NULL order data.
		Hint: Use a LEFT JOIN.*/

		-- SOLUTION:
	
		select 
		(c.first_name + '  ' + c.last_name) AS [Customer Name],
		o.order_date,
		i.quantity
		from sales.customers AS c
		left join sales.orders AS o
		on c.customer_id = o.customer_id
		left join sales.order_items AS i
		on o.order_id = i.order_id
		order by [Customer Name] ASC


		----------------------------------------------------------------------------------------------

