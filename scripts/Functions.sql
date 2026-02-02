--CONCAT

SELECT 
first_name,
country,
CONCAT(first_name,'',country) as name_country
FROM customers

--Convert firstname to lowercase
SELECT 
first_name,
country,
CONCAT(first_name,'',country) as name_country,
LOWER(first_name) as lower_firstname,
UPPER(first_name) as upper_firstname
FROM customers

--TRIM function
SELECT 
first_name,
country,
LEN(first_name) as len_firstname,
TRIM(first_name) as Trim_firstname,
LEN(TRIM(first_name)) as lenTrim_firstname
FROM customers

--REPLACE
SELECT
'77-3101-3104' as phone,
REPLACE('77-3101-3104','-','') as clean_phone

SELECT
'employees.txt' as old_file,
REPLACE('employees.txt','.txt','.csv') as clean_phone

--LEN 
 SELECT 
first_name,
country,
LEN(first_name) as len_firstname
FROM customers

--LEFT
SELECT
LEFT(first_name,3) as left_name,
RIGHT(first_name,3) as right_name
FROM customers
 
--SUBSTRING
SELECT
SUBSTRING(first_name,3,2) as substr_name,
SUBSTRING(first_name,3) as after_name
FROM customers

--Number Functions
SELECT
-3.681 as K,
ROUND(3.141,2) AS round_2,
ROUND(3.141,1) AS round_1,
ROUND(3.141,0) AS round_0,
ABS(-3.681) AS abs_val

--DATE TIME Functions
SELECT
OrderID,
OrderDate,
ShipDate,
CreationTime
FROM sales.Orders

SELECT
OrderID,
CreationTime,
'2025-12-10' AS Hardcoded_Date,
GETDATE() as CurrentDay
FROM sales.Orders

--Date Part Extractions
SELECT
OrderID,
CreationTime,
YEAR(CreationTime) Year,
MONTH(CreationTime) Month,
DAY(CreationTime) Day,
DATEPART(month,CreationTime) month2,
DATEPART(year,CreationTime) year2,
DATEPART(week,CreationTime) week2,
DATEPART(quarter,CreationTime) quarter2,
DATEPART(hour,CreationTime) hour2,
DATEPART(MINUTE,CreationTime) minute2,
DATEPART(WEEKDAY,CreationTime) weekday2
FROM sales.Orders

--DATENAME
 SELECT
OrderID,
CreationTime,
DATENAME(year,CreationTime) Year,
DATENAME(month,CreationTime) Month,
DATENAME(day,CreationTime) Day,
DATENAME(WEEKDAY,CreationTime) day2,
DATENAME(WEEK,CreationTime) week
FROM sales.Orders  

--DATETRUNC
 SELECT
OrderID,
CreationTime,
DATETRUNC(MINUTE,CreationTime) trunc_mins,
DATETRUNC(month,CreationTime) trunc_month,
DATETRUNC(year,CreationTime) trunc_year
FROM sales.orders

--EOMONTH
 SELECT
OrderID,
CreationTime,
EOMONTH(CreationTime) EndOfMonth,
DATETRUNC(month,CreationTime) StartofMonth,
CAST(DATETRUNC(month,CreationTime) AS DATE) StartofMonth2
FROM sales.orders

--How many orders were placed each month
SELECT
DATENAME(month,CreationTime) as Month,
COUNT(*) as NumOfOrders
FROM sales.Orders
GROUP BY DATENAME(month,CreationTime)

--Show all orders that were placed during the month of february
SELECT 
DATENAME(month,OrderDate) as MonthName,
*
FROM sales.Orders
WHERE DATENAME(month,OrderDate)='February'

SELECT 
OrderID,
CreationTime,
FORMAT(CreationTime, 'MM-dd-yyyy') USA,
FORMAT(CreationTime, 'dd') dd,
FORMAT(CreationTime, 'ddd') ddd,
FORMAT(CreationTime, 'dddd') dddd,
FORMAT(CreationTime, 'MM') MM,
FORMAT(CreationTime, 'MMM') MMM,
FORMAT(CreationTime, 'MMMM') MMMM
FROM sales.Orders 


--Show CreationTime using the following format:
--Day Wed Jan Q1 2025 12:34:56 PM
SELECT
OrderID,
CreationTime,
'Day ' + FORMAT(CreationTime, 'ddd MMM ') + 'Q' + 
DATENAME(quarter,CreationTime) + FORMAT(CreationTime, ' yyyy hh:mm:ss tt') AS FormatDate
FROM sales.Orders 

--CONVERT
SELECT
OrderID,
CreationTime,
CONVERT(VARCHAR,CreationTime) as DateConversion,
CONVERT(VARCHAR,CreationTime,32) as us,
CONVERT(VARCHAR,CreationTime,34) as uk,
CONVERT(DATE,'10-20-2025') as b
FROM sales.Orders 

--CAST
SELECT 
CAST('124' AS INT) as intval,
CAST(123 as VARCHAR) as varcharval ,
CAST('2025-12-10' AS DATE) dateval,
CAST('2025-12-10' AS DATETIME2) datetimeval,
CreationTime,
CAST(CreationTime AS DATE) dateval2
FROM sales.Orders

--DATEADD
SELECT 
OrderID,
OrderDate,
DATEADD(day,-10,OrderDate) tendaysback,
DATEADD(year,2,OrderDate) twoyearsahead,
DATEADD(month,-3,OrderDate) threemonthsback
FROM sales.Orders

--Calculate the age of employees
SELECT *,
DATEDIFF(year,BirthDate,GETDATE()) as AGE
FROM sales.Employees

--Find the average shipping duration in days for each month
SELECT 
DATENAME(month,ShipDate) as Month,
AVG(DATEDIFF(day,OrderDate,ShipDate)) as AvgShipDayDuration
FROM sales.Orders
GROUP BY DATENAME(month,ShipDate)

--Time Gap Analysis
--Find the number of days between each order and the prevous order
SELECT 
	OrderID,
	OrderDate,
	LAG(OrderDate,1) OVER (Order BY OrderDate) as PrevOrderDate,
	DATEDIFF(day,LAG(OrderDate,1) OVER (Order BY OrderDate),OrderDate) as numofdays
FROM sales.orders

--ISDATE
--Note: ISDATE can only understands YYYY-MM-DD format, since its ISO standard and also Year
--Reason why Year is TRUE and Month is False, SQL sever can understands year format 
--and in the backend converts it to (2025-01-01) but month doesn't recognise
SELECT
ISDATE('123') DateCheck1,
ISDATE('2025-12-10') DateCheck2,
ISDATE('20-08-2025') DateCheck3,
ISDATE('2025') YearCheck,
ISDATE('07') MonthCheck

----- Aggregate Functions -----
uSE SalesDB
--Find the average score of the customers
SELECT
customerid,
score,
AVG(score) OVER () AvgWithoutNull,
AVG(COALESCE(Score,0)) OVER() as AvgWithNull
FROM sales.Customers

SELECT DISTINCT * FROM sales.customers

SELECT AVG(score) 
from sales.Customers

--Display the full name of customers in a single field 
--by merging their first and last names, and 
--add 10 bonus poitns to each customers score
SELECT 
FirstName,
LastName,
FirstName + LastName as Fullname,
CONCAT(FirstName, LastName) as Fullname2,
Score,
COALESCE(Score,0) + 10 as bonusScore
FROM sales.customers

--Important points for joins when having NULLs
--NULL is not equal to NULL in a JOIN, so we need to use ISNULL or 
--COALESCE to replace NULLS with empty string ''
--so ON '' = '' it matches, please have a look with below example

SELECT * 
FROM sales.Customers c1
INNER JOIN sales.Customers c2
ON COALESCE(c1.LastName,'') = COALESCE(c2.LastName,'')
--see here COALESCE used only on the join columns to provide the match 
--and not in the SELECT so in the ouput we see NULL values for LastName

--ORDER BY having NULLS -- Since NULL is unknown value SQL treat it as a least value

SELECT Score
FROM sales.Customers
ORDER BY Score ASC
/*
Score
NULL
350
500
750
900 */


SELECT Score
FROM sales.Customers
ORDER BY Score DESC
/*
Score
900
750
500
350
NULL
 */

--Sort the customers from lowest to highest scores, with nulls appearing last

SELECT 
	CustomerID,
	Score as CusScore,
	CASE WHEN Score IS NULL 
		THEN 1 ELSE 0 END Flag
FROM Sales.Customers
ORDER BY  Flag,CusScore

--Find the Sales price for each order by dividing sales by quantity
SELECT 
*
FROM sales.orders

SELECT 
ProductID,
Sales,
Quantity,
(sales/NULLIF(quantity,0)) as sales_price
FROM sales.orders

--Identify customers who have no scores
SELECT 
*
FROM sales.customers 
WHERE Score IS NULL

--List all customers who have scores
SELECT *
FROM sales.customers
WHERE Score IS NOT NULL

--List all details for customers who have not placed any orders
SELECT * 
FROM sales.Orders

SELECT c.*
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL

WITH ORDERS AS (
SELECT 1 Id, 'A' Category UNION
SELECT 2,  NULL UNION
SELECT 3, '' UNION
SELECT 4, '  '
)
SELECT *,
LEN(Category) AS LenCat, --LEN doesn't count empty strings 
--if there is no data after the space and also it excludes empty strings 
--end of the value so we have to use DATALENGTH
DATALENGTH(Category) AS DataLenCat
FROM ORDERS

--IMPORTANT NOTE---
--#NULL:             means UNKNOWN, special marker datatype, very minimal storge, best performace
--#Empty String(''): known EMPTY value, String datatype, Occupies memory, Fast performance but not as NULL
--#Blank Space(' '): known SPACE value, String datatype, Occupies memory for each space, Slow

--TRIM Function
WITH ORDERS AS (
SELECT 1 Id, 'A' Category UNION
SELECT 2,  NULL UNION
SELECT 3, '' UNION
SELECT 4, '  '
)
SELECT *, 
LEN(Category) AS LenCat,
DATALENGTH(Category) AS DataLenCat,
TRIM(Category) AS TrimCat,
NULLIF(TRIM(Category),'') AS TempCat,
--Use above when inserting into DB since its fast and less storage
COALESCE(NULLIF(TRIM(Category),''),'Unknown') AS NewCat, 
--Use above only if the value will be presented as a report and not stored in DB since it occupies more storage
LEN(TRIM(Category)) AS TrimLenCat,
DATALENGTH(TRIM(Category)) AS TrimDataLenCat
FROM ORDERS
