--- CTE TYPES ---
--Non-Recursive CTE: 2 types - Standalone and Nested CTE
--Recursive CTE

--Standalone CTE: Defined and Used independently. Runs independently as its self-containe
			--and dooesn't rely on other CTEs or queries

--Problem/Use Case sample
--Step1: Find the total sales per customer\

WITH CTE_TotalSales AS (
SELECT 
CustomerId,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)
--Main Query
SELECT 
c.*,cte.TotalSales
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales cte
ON c.CustomerID = cte.CustomerID

--Multiple Standalone CTEs

--Problem/Use Case
--#Step1: Find the total sales per customer
--#Step2: Find the last order date per customer

WITH CTE_TotalSales AS (  --Find the total sales per customer
SELECT 
CustomerId,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
),
CTE_CustomerLastOrderDate AS  --Find the last order date per customer
(
SELECT 
CustomerId,
	MAX(OrderDate) AS LastOrderDate
FROM Sales.Orders
GROUP BY CustomerID
)

SELECT cte1.*,cte2.LastOrderDate  
FROM CTE_TotalSales cte1
LEFT JOIN
CTE_CustomerLastOrderDate cte2
ON cte1.CustomerID = cte2.CustomerID

WITH CTE_TotalSales AS (   --Find the total sales per customer
SELECT 
CustomerId,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
),
CTE_CustomerLastOrderDate AS  --Find the last order date per customer
(
SELECT 
CustomerId,
	MAX(OrderDate) AS LastOrderDate
FROM Sales.Orders
GROUP BY CustomerID
)

SELECT c.*,cte1.*,cte2.LastOrderDate
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales cte1 ON c.CustomerID = cte1.CustomerID
LEFT JOIN
CTE_CustomerLastOrderDate cte2
ON cte1.CustomerID = cte2.CustomerID

--Nested CTE--
--CTE inside another CTE 
--A nested CTE uses the result of another CTE, so it can't run independently.

--Problem/Usecase
--Step1: Find the total sales per customer
--Step2: Find the last order date per customer
--Step3: Rank Customers based on total sales per customer

WITH CTE_TotalSales AS (   --Find the total sales per customer 
SELECT 
CustomerId,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
),
CTE_CustomerLastOrderDate AS  --Find the last order date per customer
(
SELECT 
CustomerId,
	MAX(OrderDate) AS LastOrderDate
FROM Sales.Orders
GROUP BY CustomerID
),
NESTED_CTE AS(
SELECT c.*,cte1.TotalSales,cte2.LastOrderDate
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales cte1 ON c.CustomerID = cte1.CustomerID
LEFT JOIN
CTE_CustomerLastOrderDate cte2
ON cte1.CustomerID = cte2.CustomerID
)
SELECT 
* ,
RANK() OVER(ORDER BY TotalSales DESC) AS SaleRank
FROM NESTED_CTE;

--Problem/Usecase
--Step1: Find the total sales per customer
--Step2: Find the last order date per customer
--Step3: Rank Customers based on total sales per customer
--Step4: Segment Customers based on their total sales


--Find the total sales per customer
WITH CTE_TotalSales AS (   
SELECT 
CustomerId,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
),
--Find the last order date per customer
CTE_CustomerLastOrderDate AS  
(
SELECT 
CustomerId,
	MAX(OrderDate) AS LastOrderDate
FROM Sales.Orders
GROUP BY CustomerID
),
--Rank Customers based on total sales per customer
CTE_CustomerRank AS(
SELECT 
* ,
RANK() OVER(ORDER BY TotalSales DESC) AS SaleRank
FROM CTE_TotalSales
),
--Segment Customers based on their total sales
CTE_CustomerSegments AS(
SELECT 
* ,
NTILE(3) OVER(ORDER BY TotalSales DESC) AS CustomerSegment
FROM CTE_TotalSales
)
SELECT c.*,
cte1.TotalSales,
cte2.LastOrderDate,
cte3.SaleRank,
CASE cte4.CustomerSegment
	WHEN 1 THEN 'HighSales'
	WHEN 2 THEN 'MediumSales'
	WHEN 3 THEN 'LowSales'
END AS SalesSegment
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales cte1 
ON c.CustomerID = cte1.CustomerID
LEFT JOIN
CTE_CustomerLastOrderDate cte2
ON cte1.CustomerID = cte2.CustomerID
LEFT JOIN CTE_CustomerRank cte3
ON cte3.CustomerID = cte2.CustomerID
LEFT JOIN CTE_CustomerSegments cte4
ON cte4.CustomerID = cte2.CustomerID
ORDER BY TotalSales DESC


--Recursive CTE: Self-referencing query that repeatedly processes 
			--data untill a specific condition is met

--Generate a sequence of numbers from 1 to 20

WITH Series AS(
	--Anchor Query
	SELECT 1 AS Number
	UNION ALL
	--Recursive Query
	SELECT Number + 1 AS Num FROM Series
	WHERE Number < 20
	)
--Main Query
SELECT * 
FROM Series;

WITH Series AS(
	--Anchor Query
	SELECT 1 AS Number
	UNION ALL
	--Recursive Query
	SELECT Number + 1 AS Num FROM Series
	WHERE Number < 200 --By Default SQL Server has maximum recursion has 100
	)
--Main Query
SELECT * 
FROM Series
OPTION (MAXRECURSION 1000) --In order to overcome above recursion limitation we have to use this

--Show the employee hierarchy by displaying each employee's level within the organization
--Anchor Query
WITH RecursiveCTE AS(
SELECT 
 EmployeeID,
 FirstName,
 ManagerID,
 Department,
 1 AS Level
FROM Sales.Employees e1
WHERE ManagerID IS NULL
UNION ALL
SELECT e2.EmployeeID,
 e2.FirstName,
 e2.ManagerID,
 e2.Department,
 Level + 1  
FROM Sales.Employees e2
INNER JOIN RecursiveCTE rcte
ON e2.ManagerID = rcte.EmployeeID
)
SELECT *
FROM RecursiveCTE