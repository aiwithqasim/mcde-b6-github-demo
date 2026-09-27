--Q1)Rewrite this derived table query as a CTE:

WITH store_counts AS (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
)
SELECT AVG(order_count) AS avg_orders
FROM store_counts;


--Q2)Filter High-Value Mountain Bikes


WITH cte_high_value_products AS (
    SELECT product_id, product_name, category_id, list_price
    FROM production.products
    WHERE list_price > 2000
)
SELECT 
    p.product_id,
    p.product_name,
    p.list_price,
    c.category_name
FROM cte_high_value_products p
INNER JOIN production.categories c 
    ON p.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';



--Q3) Multiple CTEs in One WITH Clause


WITH customer_order_counts AS (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
customer_revenue AS (
    SELECT 
        o.customer_id, 
        SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_revenue
    FROM sales.orders o
    INNER JOIN sales.order_items i ON o.order_id = i.order_id
    GROUP BY o.customer_id
)
SELECT 
    oc.customer_id,
    oc.order_count,
    cr.total_revenue
FROM customer_order_counts oc
INNER JOIN customer_revenue cr 
    ON oc.customer_id = cr.customer_id;



    --Q4) Recursive CTE: Numbers and Squares (1 to 10)


    WITH NumberSequence AS (
    -- Anchor Member
    SELECT 1 AS n, 1 * 1 AS square
    
    UNION ALL
    
    -- Recursive Member
    SELECT n + 1, (n + 1) * (n + 1)
    FROM NumberSequence
    WHERE n < 10
)
SELECT n, square
FROM NumberSequence;



--Q5) Modified Recursive Org Chart (with Manager Name & Level)


WITH OrgChartCTE AS (
    -- Anchor Member: Top Managers (jin ka manager_id NULL hai)
    SELECT 
        e.staff_id,
        e.first_name,
        e.last_name,
        e.manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_first_name,
        0 AS level
    FROM sales.staffs e
    WHERE e.manager_id IS NULL

    UNION ALL

    -- Recursive Member: Direct Reports
    SELECT 
        e.staff_id,
        e.first_name,
        e.last_name,
        e.manager_id,
        m.first_name AS manager_first_name,
        m.level + 1 AS level
    FROM sales.staffs e
    INNER JOIN OrgChartCTE m 
        ON e.manager_id = m.staff_id
)
SELECT 
    staff_id,
    first_name,
    last_name,
    manager_first_name,
    level
FROM OrgChartCTE
ORDER BY level, staff_id;



--Q6) Think About It: A CTE is defined once but referenced twice in the same outer query. A colleague says "CTEs are faster than subqueries because the database computes the result once and reuses it." Is this claim accurate? What would you need to do if you genuinely needed the result computed only once and reused?



 
 

 -------------------------------------------------------------------------------
 THEORETICAL ANSWER:
 -------------------------------------------------------------------------------
 1. IS THE CLAIM ACCURATE?
    NO. The claim is completely INACCURATE.
    
    In SQL Server, a CTE (Common Table Expression) is a non-materialized logical 
    construct (syntactic sugar). SQL Server does NOT cache, store, or materialize 
    CTE intermediate results in memory or disk. 
    
    When a CTE is referenced twice in the outer query, the SQL Server query 
    optimizer expands the CTE definition and executes the underlying query logic 
    TWICE. Therefore, performance is identical to using subqueries or derived 
    tables—there is no speed advantage from automatic caching.

 2. WHAT IS THE SOLUTION FOR SINGLE EXECUTION AND REUSE?
    To genuinely compute a result ONCE and reuse it multiple times across joins 
    or outer queries, you must use a TEMPORARY TABLE (#temp_table) or a 
    TABLE VARIABLE (@table_variable).
    
    Writing data to a Temporary Table physically stores the computed dataset in 
    TempDB once. Subsequent references query the pre-computed table structure 
    without re-evaluating heavy joins, aggregations, or filter logic.
*******************************************************************************/

-- =============================================================================
-- DEMONSTRATION 1: CTE Approach (Query logic is evaluated TWICE)
-- =============================================================================
-- Notice: Referencing CTE_StoreOrders twice forces SQL Server to perform 
-- the aggregation on sales.orders twice behind the scenes.

WITH CTE_StoreOrders AS (
    SELECT store_id, COUNT(*) AS total_orders
    FROM sales.orders
    GROUP BY store_id
)
SELECT 
    s1.store_id AS Store_A,
    s2.store_id AS Store_B,
    s1.total_orders
FROM CTE_StoreOrders s1
INNER JOIN CTE_StoreOrders s2 
    ON s1.total_orders = s2.total_orders 
    AND s1.store_id < s2.store_id;


-- =============================================================================
-- DEMONSTRATION 2: Temp Table Approach (Computes ONCE and Reuses)
-- =============================================================================
-- Step 1: Compute the result ONCE and store physically in a Temporary Table
SELECT store_id, COUNT(*) AS total_orders
INTO #StoreOrdersTemp
FROM sales.orders
GROUP BY store_id;

-- Step 2: Query the Temp Table multiple times efficiently without re-computation
SELECT 
    t1.store_id AS Store_A,
    t2.store_id AS Store_B,
    t1.total_orders
FROM #StoreOrdersTemp t1
INNER JOIN #StoreOrdersTemp t2 
    ON t1.total_orders = t2.total_orders 
    AND t1.store_id < t2.store_id;

-- Step 3: Clean up the Temp Table
DROP TABLE #StoreOrdersTemp;