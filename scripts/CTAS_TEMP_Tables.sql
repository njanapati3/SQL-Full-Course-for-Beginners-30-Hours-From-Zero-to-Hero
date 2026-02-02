--Creating CTAS

SELECT  
	DATENAME(month, OrderDate) AS OrderMonth,
	COUNT(OrderID) AS TotalOrders
INTO Sales.MonthlyOrders --this is the syntax in SQL Server
FROM Sales.Orders
GROUP BY DATENAME(month,OrderDate)

--MY SQL / ORACLE / other DB Syntax is simple, it is similar to views in SQL Server
CREATE TABLE Sales.MonthlyOrders AS (
SELECT  
	DATENAME(month, OrderDate) AS OrderMonth,
	COUNT(OrderID) AS TotalOrders
FROM Sales.Orders
GROUP BY DATENAME(month,OrderDate)
)

SELECT * 
FROM Sales.MonthlyOrders

DROP TABLE Sales.MonthlyOrders

--To Update the CTAS we need to DROP the table first
--and then CREATE the TABLE or else use the T-SQL Syntax


--Create Temporary Table / Temp Table
--Temporary Table: A temp table is a table which is acive during a session 
--and dropped automatically after the session disconnected.

SELECT 
*
INTO #Orders  --# is the representation of Temp Table, and it is given before table name
FROM Sales.Orders

SELECT 
*
FROM #Orders

--Delete records from Temp Table
--This only delete the records from temp table it doesn't affect in main table.
DELETE FROM #Orders
WHERE OrderStatus = 'Delivered'

--Create a new table using temp table
SELECT *
INTO Sales.OrdersTest
FROM #Orders