# SQL Server Quick Reference Cheatsheet

## Basic Queries

### SELECT Statement
```sql
SELECT column1, column2 FROM table_name;
SELECT * FROM table_name;
SELECT DISTINCT column1 FROM table_name;
SELECT TOP 10 * FROM table_name;
```

### WHERE Clause
```sql
SELECT * FROM table_name WHERE condition;
SELECT * FROM table_name WHERE column1 = 'value';
SELECT * FROM table_name WHERE column1 > 100;
SELECT * FROM table_name WHERE column1 BETWEEN 10 AND 100;
SELECT * FROM table_name WHERE column1 IN ('A', 'B', 'C');
SELECT * FROM table_name WHERE column1 LIKE 'A%';
SELECT * FROM table_name WHERE column1 IS NULL;
```

### ORDER BY
```sql
SELECT * FROM table_name ORDER BY column1 ASC;
SELECT * FROM table_name ORDER BY column1 DESC;
SELECT * FROM table_name ORDER BY column1, column2 DESC;
```

### GROUP BY & HAVING
```sql
SELECT column1, COUNT(*) 
FROM table_name 
GROUP BY column1;

SELECT column1, AVG(column2) 
FROM table_name 
GROUP BY column1 
HAVING AVG(column2) > 100;
```

## Joins

```sql
-- INNER JOIN
SELECT * FROM table1 t1
INNER JOIN table2 t2 ON t1.id = t2.id;

-- LEFT JOIN
SELECT * FROM table1 t1
LEFT JOIN table2 t2 ON t1.id = t2.id;

-- RIGHT JOIN
SELECT * FROM table1 t1
RIGHT JOIN table2 t2 ON t1.id = t2.id;

-- FULL OUTER JOIN
SELECT * FROM table1 t1
FULL OUTER JOIN table2 t2 ON t1.id = t2.id;

-- CROSS JOIN
SELECT * FROM table1 CROSS JOIN table2;
```

## Window Functions

### Ranking Functions
```sql
ROW_NUMBER() OVER(ORDER BY column1)
RANK() OVER(ORDER BY column1)
DENSE_RANK() OVER(ORDER BY column1)
NTILE(4) OVER(ORDER BY column1)
```

### Analytical Functions
```sql
LEAD(column1) OVER(ORDER BY date_column)
LAG(column1) OVER(ORDER BY date_column)
FIRST_VALUE(column1) OVER(ORDER BY column1)
LAST_VALUE(column1) OVER(ORDER BY column1)
```

### Aggregate Window Functions
```sql
SUM(column1) OVER(PARTITION BY column2 ORDER BY column3)
AVG(column1) OVER(PARTITION BY column2)
COUNT(*) OVER(PARTITION BY column2)
MAX(column1) OVER(PARTITION BY column2)
MIN(column1) OVER(PARTITION BY column2)
```

## Common Table Expressions (CTE)

```sql
WITH CTE_Name AS (
    SELECT column1, column2
    FROM table_name
    WHERE condition
)
SELECT * FROM CTE_Name;

-- Recursive CTE
WITH RecursiveCTE AS (
    SELECT column1, 1 AS Level
    FROM table_name
    WHERE condition
    UNION ALL
    SELECT t.column1, r.Level + 1
    FROM table_name t
    INNER JOIN RecursiveCTE r ON t.parent_id = r.column1
)
SELECT * FROM RecursiveCTE;
```

## Subqueries

```sql
-- Scalar Subquery
SELECT * FROM table1
WHERE column1 > (SELECT AVG(column1) FROM table1);

-- IN Subquery
SELECT * FROM table1
WHERE column1 IN (SELECT column1 FROM table2);

-- EXISTS Subquery
SELECT * FROM table1 t1
WHERE EXISTS (SELECT 1 FROM table2 t2 WHERE t1.id = t2.id);
```

## Data Manipulation

### INSERT
```sql
INSERT INTO table_name (column1, column2)
VALUES ('value1', 'value2');

INSERT INTO table_name (column1, column2)
SELECT column1, column2 FROM another_table;
```

### UPDATE
```sql
UPDATE table_name
SET column1 = 'new_value'
WHERE condition;
```

### DELETE
```sql
DELETE FROM table_name WHERE condition;
TRUNCATE TABLE table_name;
```

## Indexes

```sql
-- Clustered Index
CREATE CLUSTERED INDEX idx_name ON table_name(column1);

-- Non-Clustered Index
CREATE NONCLUSTERED INDEX idx_name ON table_name(column1);

-- Composite Index
CREATE INDEX idx_name ON table_name(column1, column2);

-- Unique Index
CREATE UNIQUE INDEX idx_name ON table_name(column1);

-- Filtered Index
CREATE INDEX idx_name ON table_name(column1)
WHERE condition;

-- Drop Index
DROP INDEX idx_name ON table_name;
```

## Functions

### String Functions
```sql
CONCAT(string1, string2)
UPPER(string)
LOWER(string)
TRIM(string)
LEFT(string, length)
RIGHT(string, length)
SUBSTRING(string, start, length)
REPLACE(string, old, new)
LEN(string)
```

### Date Functions
```sql
GETDATE()
DATEADD(day, 1, date_column)
DATEDIFF(day, date1, date2)
YEAR(date_column)
MONTH(date_column)
DAY(date_column)
DATEPART(month, date_column)
DATENAME(month, date_column)
DATETRUNC(month, date_column)
EOMONTH(date_column)
FORMAT(date_column, 'yyyy-MM-dd')
```

### Numeric Functions
```sql
ROUND(number, decimals)
ABS(number)
CEILING(number)
FLOOR(number)
POWER(number, power)
SQRT(number)
```

### Aggregate Functions
```sql
COUNT(*)
SUM(column)
AVG(column)
MAX(column)
MIN(column)
```

## CASE Statements

```sql
SELECT 
    column1,
    CASE 
        WHEN condition1 THEN 'result1'
        WHEN condition2 THEN 'result2'
        ELSE 'default_result'
    END AS new_column
FROM table_name;
```

## Set Operators

```sql
-- UNION (removes duplicates)
SELECT column1 FROM table1
UNION
SELECT column1 FROM table2;

-- UNION ALL (keeps duplicates)
SELECT column1 FROM table1
UNION ALL
SELECT column1 FROM table2;

-- INTERSECT
SELECT column1 FROM table1
INTERSECT
SELECT column1 FROM table2;

-- EXCEPT
SELECT column1 FROM table1
EXCEPT
SELECT column1 FROM table2;
```

## Views

```sql
-- Create View
CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
WHERE condition;

-- Query View
SELECT * FROM view_name;

-- Drop View
DROP VIEW view_name;
```

## Stored Procedures

```sql
-- Create Procedure
CREATE PROCEDURE proc_name
    @param1 INT,
    @param2 VARCHAR(50)
AS
BEGIN
    SELECT * FROM table_name
    WHERE column1 = @param1;
END;

-- Execute Procedure
EXEC proc_name @param1 = 1, @param2 = 'value';

-- Drop Procedure
DROP PROCEDURE proc_name;
```

## Temporary Tables

```sql
-- Create Temp Table
SELECT * INTO #TempTable
FROM table_name;

-- Use Temp Table
SELECT * FROM #TempTable;
```

## Performance Tips

1. **Use indexes on frequently queried columns**
2. **Avoid SELECT * - specify needed columns**
3. **Use WHERE instead of HAVING when possible**
4. **Use EXISTS instead of IN for large datasets**
5. **Avoid functions on indexed columns in WHERE**
6. **Use appropriate join types**
7. **Update statistics regularly**
8. **Monitor execution plans**
9. **Use UNION ALL instead of UNION when duplicates ok**
10. **Avoid leading wildcards in LIKE (%value)**
