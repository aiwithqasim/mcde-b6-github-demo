# Chapter 6: Common Table Expressions (CTEs) - Exercise Solutions

Here are the solutions to the CTE exercises. These queries are written using standard SQL Server (T-SQL) syntax, which is typical for the BikeStores dataset.

### Exercise 6.2

**Prompt:** Write a CTE called `cte_high_value_products` that returns products with `list_price > 2000`. Then query the CTE to return only Mountain Bikes from that list, joining to `production.categories`.

```sql
WITH cte_high_value_products AS (
    SELECT 
        product_id,
        product_name,
        category_id,
        list_price
    FROM production.products
    WHERE list_price > 2000
)
SELECT 
    hvp.product_name,
    hvp.list_price,
    c.category_name
FROM cte_high_value_products hvp
JOIN production.categories c ON hvp.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes';
```

### Exercise 6.3

**Prompt:** Write two CTEs in one `WITH` clause: one that counts orders per customer, and one that sums revenue per customer. Join them in the outer query to return `customer_id`, `order_count`, and `total_revenue` side by side.

```sql
WITH CustomerOrderCounts AS (
    SELECT 
        customer_id,
        COUNT(order_id) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),
CustomerRevenue AS (
    SELECT 
        o.customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT 
    oc.customer_id,
    oc.order_count,
    cr.total_revenue
FROM CustomerOrderCounts oc
JOIN CustomerRevenue cr ON oc.customer_id = cr.customer_id;
```
*(Note: You could technically achieve this without two CTEs by doing all aggregations in one query, but this exercise perfectly demonstrates how to chain multiple CTEs by separating concerns.)*

### Exercise 6.4

**Prompt:** Using a recursive CTE, generate a list of numbers from 1 to 10. Each row should have the number and its square (n * n).

```sql
WITH NumberSeries AS (
    -- Anchor Member: The starting point
    SELECT 
        1 AS n, 
        1 * 1 AS squared
    
    UNION ALL
    
    -- Recursive Member: References the CTE itself
    SELECT 
        n + 1, 
        (n + 1) * (n + 1)
    FROM NumberSeries
    WHERE n < 10 -- The termination condition
)
SELECT n, squared
FROM NumberSeries;
```

### Exercise 6.5

**Prompt:** Using the recursive CTE org chart from section 9.6.2 as a starting point, modify it to also show the manager's `first_name` alongside each employee. Add a `level` column (0 for the top manager, 1 for their direct reports, 2 for the next level down).

```sql
WITH OrgChart AS (
    -- Anchor Member: Find the top boss (where manager_id IS NULL)
    SELECT 
        staff_id,
        first_name,
        last_name,
        manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_first_name, -- Top boss has no manager
        0 AS org_level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive Member: Join employees to their managers (the anchor)
    SELECT 
        e.staff_id,
        e.first_name,
        e.last_name,
        e.manager_id,
        m.first_name AS manager_first_name, -- Pull the manager's name from the previous level
        m.org_level + 1 AS org_level
    FROM sales.staffs e
    JOIN OrgChart m ON e.manager_id = m.staff_id
)
SELECT 
    staff_id,
    first_name,
    last_name,
    manager_first_name,
    org_level
FROM OrgChart
ORDER BY org_level, staff_id;
```

### Exercise 6.6

**Prompt:** Think About It: A CTE is defined once but referenced twice in the same outer query. A colleague says "CTEs are faster than subqueries because the database computes the result once and reuses it." Is this claim accurate? What would you need to do if you genuinely needed the result computed only once and reused?

*   **Is this claim accurate?** No, the claim is inaccurate in most major RDBMS platforms (especially SQL Server). A standard CTE is purely a logical construct, sometimes called syntactic sugar. It acts as an inline view. If you reference a CTE twice in your outer query, the SQL Server query engine will literally execute the logic of that CTE two separate times under the hood. It does **not** persist the data in memory.
*   **What to do for single computation:** If a complex, resource-intensive query is referenced multiple times and you need to guarantee it is only evaluated once, you should use a **Temporary Table** (e.g., `#TempTable`) or a Table Variable. You insert the data into the temp table first, and then run your main queries against the temp table. This writes the data to `tempdb`, ensuring the heavy lifting is strictly done once.