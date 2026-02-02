# SQL Server Best Practices

## Naming Conventions

### General Rules
- Use **meaningful and descriptive names**
- Be **consistent** throughout the database
- Use **PascalCase** for objects (e.g., `CustomerOrders`)
- Use **lowercase with underscores** for column names (e.g., `customer_id`)
- Avoid special characters and spaces

### Tables
```sql
-- Good
CREATE TABLE Customers (...);
CREATE TABLE OrderDetails (...);

-- Bad
CREATE TABLE tbl_customers (...);
CREATE TABLE order-details (...);
```

### Columns
```sql
-- Good
customer_id, first_name, order_date

-- Bad
custID, fn, date1
```

### Indexes
```sql
-- Naming Pattern: idx_TableName_ColumnName(s)
CREATE INDEX idx_Customers_LastName ON Customers(last_name);
CREATE INDEX idx_Orders_CustomerDate ON Orders(customer_id, order_date);
```

### Stored Procedures
```sql
-- Naming Pattern: usp_Action_Object or sp_Action_Object
CREATE PROCEDURE usp_Get_CustomerOrders (...);
CREATE PROCEDURE usp_Update_ProductPrices (...);
```

### Views
```sql
-- Naming Pattern: v_Purpose or vw_Purpose
CREATE VIEW v_ActiveCustomers AS (...);
CREATE VIEW vw_OrderSummary AS (...);
```

## Query Writing Best Practices

### 1. Use Explicit Column Names
```sql
-- Good
SELECT customer_id, first_name, last_name
FROM Customers;

-- Bad
SELECT *
FROM Customers;
```

### 2. Use Table Aliases
```sql
-- Good
SELECT c.customer_id, o.order_date
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id;

-- Bad
SELECT customer_id, order_date
FROM Customers
INNER JOIN Orders ON Customers.customer_id = Orders.customer_id;
```

### 3. Use Explicit JOIN Syntax
```sql
-- Good
SELECT *
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id;

-- Bad
SELECT *
FROM Customers c, Orders o
WHERE c.customer_id = o.customer_id;
```

### 4. Avoid Functions on Indexed Columns in WHERE
```sql
-- Good
SELECT * FROM Orders
WHERE order_date >= '2024-01-01';

-- Bad (prevents index usage)
SELECT * FROM Orders
WHERE YEAR(order_date) = 2024;
```

### 5. Use EXISTS Instead of IN for Subqueries
```sql
-- Good (for large datasets)
SELECT * FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o
    WHERE o.customer_id = c.customer_id
);

-- Less efficient
SELECT * FROM Customers
WHERE customer_id IN (
    SELECT customer_id FROM Orders
);
```

### 6. Use UNION ALL Instead of UNION
```sql
-- Good (when duplicates are acceptable)
SELECT customer_id FROM Customers
UNION ALL
SELECT customer_id FROM ArchivedCustomers;

-- Slower (removes duplicates)
SELECT customer_id FROM Customers
UNION
SELECT customer_id FROM ArchivedCustomers;
```

## Index Management

### When to Create Indexes
✅ **Primary keys** (automatic clustered index)  
✅ **Foreign keys** for join operations  
✅ **Frequently filtered columns** in WHERE clauses  
✅ **Columns used in ORDER BY**  
✅ **Columns in GROUP BY**  

### When NOT to Create Indexes
❌ **Small tables** (< 1000 rows)  
❌ **Columns with low cardinality** (few unique values)  
❌ **Columns frequently updated**  
❌ **Wide columns** (VARCHAR(MAX), TEXT)  

### Index Maintenance
```sql
-- Check index fragmentation
SELECT 
    OBJECT_NAME(ps.object_id) AS TableName,
    i.name AS IndexName,
    ps.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ps
INNER JOIN sys.indexes i ON ps.object_id = i.object_id AND ps.index_id = i.index_id
WHERE ps.avg_fragmentation_in_percent > 30;

-- Reorganize index (< 30% fragmentation)
ALTER INDEX idx_name ON table_name REORGANIZE;

-- Rebuild index (> 30% fragmentation)
ALTER INDEX idx_name ON table_name REBUILD;

-- Update statistics
UPDATE STATISTICS table_name;
```

## Performance Optimization

### 1. Use SET NOCOUNT ON in Stored Procedures
```sql
CREATE PROCEDURE usp_GetCustomers
AS
BEGIN
    SET NOCOUNT ON;  -- Reduces network traffic
    SELECT * FROM Customers;
END;
```

### 2. Use Proper Data Types
```sql
-- Good
customer_id INT NOT NULL,
status VARCHAR(20) NOT NULL,
amount DECIMAL(10,2) NOT NULL

-- Bad
customer_id VARCHAR(50),  -- Wastes space
status TEXT,              -- Poor performance
amount FLOAT              -- Precision issues
```

### 3. Avoid DISTINCT When Not Needed
```sql
-- Good (if duplicates impossible due to keys)
SELECT customer_id, order_date
FROM Orders;

-- Bad (unnecessary)
SELECT DISTINCT customer_id, order_date
FROM Orders;
```

### 4. Use LIMIT/TOP to Test Queries
```sql
-- Good for testing
SELECT TOP 100 * FROM LargeTable;

-- Bad (retrieves all data)
SELECT * FROM LargeTable;
```

### 5. Batch Large Operations
```sql
-- Good (batch processing)
DECLARE @BatchSize INT = 1000;
WHILE 1 = 1
BEGIN
    DELETE TOP (@BatchSize) FROM Orders
    WHERE order_date < '2020-01-01';
    
    IF @@ROWCOUNT < @BatchSize BREAK;
END;

-- Bad (locks table for long time)
DELETE FROM Orders WHERE order_date < '2020-01-01';
```

## Error Handling

### Use TRY-CATCH Blocks
```sql
CREATE PROCEDURE usp_UpdateCustomer
    @customer_id INT,
    @new_email VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        UPDATE Customers
        SET email = @new_email
        WHERE customer_id = @customer_id;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        -- Log error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
    END CATCH;
END;
```

## Security Best Practices

### 1. Use Parameterized Queries
```sql
-- Good (prevents SQL injection)
CREATE PROCEDURE usp_GetCustomer
    @customer_id INT
AS
BEGIN
    SELECT * FROM Customers
    WHERE customer_id = @customer_id;
END;

-- Bad (SQL injection risk)
-- Never build dynamic SQL from user input without parameterization
```

### 2. Principle of Least Privilege
```sql
-- Grant only necessary permissions
GRANT SELECT ON Customers TO ReportUser;
GRANT EXECUTE ON usp_GetCustomers TO AppUser;

-- Avoid
GRANT ALL PERMISSIONS TO User;  -- Too broad
```

### 3. Use Views for Data Access Control
```sql
-- Create view with filtered data
CREATE VIEW v_PublicCustomers AS
SELECT customer_id, first_name, last_name, email
FROM Customers
WHERE status = 'Active';

-- Grant access to view instead of table
GRANT SELECT ON v_PublicCustomers TO PublicUser;
```

## Code Documentation

### Comment Your Code
```sql
/*
===============================================================================
Procedure Name: usp_Get_MonthlyReport
Description:    Generates monthly sales report for specified period
Parameters:     @StartDate - Report start date
                @EndDate - Report end date
Author:         Your Name
Created:        2024-01-15
Modified:       2024-02-01 - Added customer segmentation
===============================================================================
*/
CREATE PROCEDURE usp_Get_MonthlyReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Step 1: Get base sales data
    SELECT 
        customer_id,
        SUM(sales_amount) AS total_sales
    FROM Orders
    WHERE order_date BETWEEN @StartDate AND @EndDate
    GROUP BY customer_id;
    
    -- Step 2: Additional logic here...
END;
```

## Transaction Management

### Use Transactions Appropriately
```sql
-- Good
BEGIN TRANSACTION;

    -- Multiple related operations
    UPDATE Inventory SET quantity = quantity - 1 WHERE product_id = 1;
    INSERT INTO Orders (product_id, quantity) VALUES (1, 1);

    IF @@ERROR <> 0
        ROLLBACK TRANSACTION;
    ELSE
        COMMIT TRANSACTION;
```

## Maintenance Tasks

### Regular Maintenance Schedule
```sql
-- Weekly: Update Statistics
EXEC sp_updatestats;

-- Weekly: Reorganize Indexes (fragmentation 5-30%)
ALTER INDEX ALL ON table_name REORGANIZE;

-- Monthly: Rebuild Indexes (fragmentation > 30%)
ALTER INDEX ALL ON table_name REBUILD;

-- Daily: Check Database Integrity
DBCC CHECKDB;

-- As Needed: Shrink Database (use sparingly)
DBCC SHRINKDATABASE(database_name);
```

## Common Anti-Patterns to Avoid

❌ **Using SELECT * in production code**  
❌ **Not using parameterized queries**  
❌ **Creating indexes on every column**  
❌ **Using NOLOCK hint everywhere**  
❌ **Not handling NULL values properly**  
❌ **Using CURSOR when set-based operation possible**  
❌ **Not normalizing data properly**  
❌ **Ignoring execution plans**  
❌ **Hard-coding values instead of using parameters**  
❌ **Not backing up databases regularly**  

## Summary Checklist

✅ Use meaningful naming conventions  
✅ Write explicit, readable queries  
✅ Create appropriate indexes  
✅ Monitor and maintain indexes  
✅ Use proper data types  
✅ Implement error handling  
✅ Secure your database  
✅ Document your code  
✅ Use transactions properly  
✅ Perform regular maintenance  
✅ Monitor performance  
✅ Avoid common anti-patterns  
