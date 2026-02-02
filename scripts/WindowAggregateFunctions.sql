--- AGGREGATE FUNCTIONS ---

--Find the total number of Orders
SELECT 
	COUNT(*) AS TotalNumOrders
FROM orders 

--Find the total sales of all orders
SELECT 
	COUNT(*) AS TotalNumOrders,
	SUM(sales) AS TotalSales
FROM orders 

--Find the average sales of all orders
SELECT 
    COUNT(*) AS TotalNumOrders,
	SUM(sales) AS TotalSales,
	AVG(sales) AS AvgSales
FROM orders

--Find the highest sales of all orders
SELECT
	 COUNT(*) AS TotalNumOrders,
	SUM(sales) AS TotalSales,
	AVG(sales) AS AvgSales,
	MAX(sales) AS HighestSales
FROM orders

--Find the lowest sales of all orders
SELECT
	 COUNT(*) AS TotalNumOrders,
	SUM(sales) AS TotalSales,
	AVG(sales) AS AvgSales,
	MAX(sales) AS HighestSales,
	MIN(sales) AS LowestSales
FROM orders

--Find the total Sales for each product
SELECT 
ProductID,
SUM(sales) AS ToatalSales
FROM Sales.Orders
GROUP BY ProductID 

--Find the total sales for each product,
--additionally provide details such as order id and order date
SELECT 
OrderID,
OrderDate,
ProductID,
SUM(sales) OVER(PARTITION BY productid) AS ToatalSales
FROM Sales.Orders

--Find the toatal sales across all orders
--additionally provide details such as order id and order date
SELECT 
OrderID,
OrderDate,
ProductID,
SUM(sales) OVER() AS ToatalSales
FROM Sales.Orders

--Find the toatal sales across all orders,
--Find the total sales for each product,
--additionally provide details such as order id and order date
SELECT 
OrderID,
OrderDate,
ProductID,
Sales,
SUM(sales) OVER() AS ToatalSales,
SUM(sales) OVER(PARTITION BY productid) AS ToatalSalesProduct
FROM Sales.Orders

--Find the toatal sales across all orders,
--Find the total sales for each product,
--Find the total sales for each combination of product and order status
--additionally provide details such as order id and order date 

SELECT 
OrderID,
OrderDate,
ProductID,
Sales,
SUM(sales) OVER() AS ToatalSales,
SUM(sales) OVER(PARTITION BY productid) AS ToatalSalesProduct,
SUM(sales) OVER(PARTITION BY ProductID,OrderStatus) As TotalSalesOrderStatus
FROM Sales.Orders

SELECT * FROM Sales.Orders

--Rank each order based on their sales from highest to lowest
--Additionally provide details such as order Id, order date
SELECT 
OrderID,
OrderDate,
ProductID,
Sales,
RANK() OVER(ORDER BY Sales DESC) AS RankVal
FROM Sales.Orders

--Find the total number of Orders
--Find the total number of Orders for each customers
--Additionally provide details such as order id, order date

SELECT	
	OrderID,
	OrderDate,
	CustomerID,
	COUNT(*) OVER() AS TotalOrders,
	COUNT(*) OVER(PARTITION BY CustomerID) TotalOrdersByCustomers
FROM Sales.Orders

--Find the total number of customers
--Additionally provide all customers details

SELECT 
	*,
	COUNT(*) OVER () AS TotalCustomers
FROM Sales.Customers

--Find the total number of customers
--Additionally provide all customers details
--Find the toal number of scores for the customers

SELECT 
	*,
	COUNT(*) OVER() AS TotalCustomers,
	COUNT(Score) OVER() AS TotalScore,
	COUNT(Lastname) OVER() AS TotalLastName
FROM Sales.Customers

--Check whether the table orders contains any duplicate rows

SELECT 
	OrderID,
	COUNT(*) OVER(PARTITION BY OrderID) CheckPK
	FROM Sales.Orders

SELECT * FROM(
SELECT 
	OrderID,
	COUNT(*) OVER(PARTITION BY OrderID) CheckPK
	FROM Sales.OrdersArchive
	)a WHERE CheckPK>1

--Find the total sales across all orders
--And the total sales for each product
--Additionally provide details such as order Id, order date

SELECT 
OrderDate,
OrderID,
ProductID,
SUM(Sales) OVER() AS TotalSales,
SUM(Sales) OVER(PARTITION BY ProductID) as TotalSalesByProduct
FROM Sales.Orders

--Find the percentage contribution of each product's sales to the total sales

SELECT 
OrderDate,
OrderID,
ProductID,
SUM(Sales) OVER() AS TotalSales,
SUM(Sales) OVER(PARTITION BY ProductID) as TotalSalesByProduct,
ROUND((CAST(Sales AS Float)/SUM(Sales) OVER())*100,2) AS PercentageOfProductSales
FROM Sales.Orders

--Find the average sales across all orders
--And find the average sales for each product
--Additionally provide details such as 
SELECT 
OrderDate,
OrderID,
ProductID,
Sales,
AVG(Sales) OVER() AS TotalSales,
AVG(Sales) OVER(PARTITION BY ProductID) as TotalSalesByProduct
FROM Sales.Orders

--Find the average scores of customers 
--Additionally provide details such as Customer ID and Last Name

SELECT 
CustomerID,
FirstName,
Score,
AVG(COALESCE(Score,0)) OVER() AS AvgScore
FROM Sales.Customers

--Find all orders where sales are higher then the average sales across all orders
SELECT * FROM(
SELECT 
OrderID,
ProductID,
Sales,
AVG(Sales) OVER() AS AvgSales
FROM Sales.Orders
)t WHERE Sales>AvgSales

--Find the highest and lowest sales of all orders
--Find the highest and lowest sales for each product
--Additionally provide details such order ID, order date

SELECT 
	OrderId,
	OrderDate,
	Sales,
	ProductID,
	MAX(Sales) OVER() AS HighestSales,
	MAX(Sales) OVER(PARTITION BY ProductID) AS HighestSalesByProduct,
	MIN(Sales) OVER() AS LowestSales,
	MIN(Sales) OVER(PARTITION BY ProductID) AS LowestSalesByProduct
FROM Sales.Orders

--Show the employees who have the highest salaries
SELECT * FROM(
SELECT
EmployeeID,
FirstName,
Salary,
MAX(Salary) OVER() AS HighestSalary
FROM Sales.Employees
)a WHERE Salary = HighestSalary

--Find the deviation of each sales from the minimum and maximum sales amounts
SELECT 
	OrderId,
	OrderDate,
	Sales,
	ProductID,
	MAX(Sales) OVER() AS HighestSales,
	--MAX(Sales) OVER(PARTITION BY ProductID) AS HighestSalesByProduct,
	MIN(Sales) OVER() AS LowestSales,
	Sales - MIN(Sales) OVER() AS DeviationFromMin,
	MAX(Sales) OVER()  - Sales AS DeviationFromMax
	--MIN(Sales) OVER(PARTITION BY ProductID) AS LowestSalesByProduct
FROM Sales.Orders

--Calculate moving average of sales for each product over time
SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AS AvgByProduct,
	AVG(Sales) OVER(PARTITION BY ProductID Order BY OrderDate ASC) MovingAvg
FROM Sales.Orders

--Calculate the moving average of sales for each product over timer,
--including only the next order.
SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AS AvgByProduct,
	AVG(Sales) OVER(PARTITION BY ProductID Order BY OrderDate ASC) MovingAvg,
	AVG(Sales) OVER(PARTITION BY ProductID Order BY OrderDate ASC ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg
FROM Sales.Orders


SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS SumByProduct,
	SUM(Sales) OVER(PARTITION BY ProductID Order BY OrderDate ASC) MovingSum,
	SUM(Sales) OVER(PARTITION BY ProductID Order BY OrderDate ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) RollingSum
FROM Sales.Orders

---ROW_NUMBER()---
--#Assign a unique number to each row
--#It doesn't handle ties
--#Unique Ranking without gaps/skipping

--Rank the orders based on their sales from highest to lowest
SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) AS RowNum
FROM Sales.Orders

---RANK()---Skipps
--#Assign a rank to each row
--#It handles ties
--#It leaves gaps in ranking/Assign same rank for same values and skip the number for next rank
--#Ex: In Olympics if two players achive the first place they both gets gold medal and next person[third] gets bronze. Silver is skipped.

--Rank the orders based on their sales from highest to lowest
SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) AS RowNum,
	RANK() OVER(ORDER BY Sales DESC) AS Rank
FROM Sales.Orders

---DENSE_RANK()---No Skipping
--#Assign a rank to each row
--#It handles ties
--#It doesn't leaves gaps in ranking/Assign same rank for same values and won't skip the number for next rank 

--Rank the orders based on their sales from highest to lowet
SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) AS SalesRowNum,
	RANK()       OVER(ORDER BY Sales DESC) AS SalesRank,
	DENSE_RANK() OVER(ORDER BY Sales DESC) AS SalesDenseRank
FROM Sales.Orders

--#TOP-N ANALYSIS
--Find the top highest sales for each product
SELECT * FROM(
SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS SalesRowNum
FROM Sales.Orders
)a WHERE SalesRowNum=1

--#BOTTOM-N ANALYISIS
--Find the lowest 2 customers based on their total sales

SELECT * FROM (
SELECT 
	OrderID,
	ProductID,
	Sales,
	CustomerID,
	SUM(Sales) OVER(PARTITION BY CustomerID) AS SalesRowNum,

FROM Sales.Orders
ORDER BY SalesRowNum
)a WHERE SalesRowNum <= 2

SELECT 
	* 
FROM(
SELECT 
CustomerID,
SUM(Sales) AS TotalSales,
ROW_NUMBER() OVER(ORDER BY SUM(Sales) ASC) AS TotalSalesRowNum
FROM Sales.Orders
GROUP BY CustomerID
)a WHERE TotalSalesRowNum <=2 

--ASSIGN UNIQUE IDS
--Assign Unique IDs to the rows of the OrdersArchive table

SELECT 
ROW_NUMBER() OVER(ORDER BY OrderID,OrderDate) AS SeqNum,
*
FROM Sales.OrdersArchive\

--Identify duplicate rows in the table 'Orders Archive'
--and return a clean result without any duplicates

SELECT * FROM(
SELECT 
ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) As RowNum,
*
FROM Sales.OrdersArchive
)a WHERE RowNum=1

---NTILE()---

SELECT
OrderID,
Sales,
NTILE(1) OVER(ORDER BY Sales DESC) AS OneBucket,
NTILE(2) OVER(ORDER BY Sales DESC) AS TwoBucket,
NTILE(3) OVER(ORDER BY Sales DESC) AS ThreeBucket,
NTILE(4) OVER(ORDER BY Sales DESC) AS FourBucket
FROM Sales.Orders

--Segement all orders into 3 categories: high, medium and low sales
--Data Segmentation: Divides a dataset into distinct subsets based on certain criteria
SELECT 
	*,
	CASE Segment
		WHEN 1 THEN 'high'
		WHEN 2 THEN 'medium'
		ELSE 'low'
	END AS SalesSegments
FROM
(
SELECT
OrderID,
Sales,
NTILE(3) OVER (ORDER BY Sales DESC) AS Segment
FROM Sales.Orders)a

--In order to export the data, divide the orders into 2 groups
SELECT
NTILE(2) OVER(ORDER BY OrderID) AS TwoBuckets,
*
FROM Sales.Orders

---CUME_DSIT()---
--#Cumulative Distribution calculates the distribution of data points within a window
--CUME_DIST = (Position of Row / Number of Rows)      [Note: In case of ties it takes the greater position value]

---PERCENT_RANK()
--#Calculates the realative position of each row
--PERCENT_RANK = (Position of Row - 1 / Number of Rows -1)  [Note: In case of ties it takes position of first occurence]

--Find the products the fall within the highest 40% of the prices
SELECT *,
PercentageRank * 100 || '%' AS PercentageValue
FROM(
SELECT 
*,
CUME_DIST() OVER(ORDER BY Price DESC) AS PercentageRank
FROM Sales.Products
)a WHERE PercentageRank * 100 <= 40

--Find the products the fall within the highest 40% of the prices
SELECT *,
PercentageRank * 100 || '%' AS PercentageValue
FROM(
SELECT 
*,
PERCENT_RANK() OVER(ORDER BY Price DESC) AS PercentageRank
FROM Sales.Products
)a WHERE PercentageRank * 100 <= 40

--- LEAD() LAG() ---

--Analyze the month-over-month performance by finding the percentaage change 
--in sales between the current and previous months
SELECT 
	*,
	ROUND(CAST(MoMChange AS Float)/PreviousMonthSales * 100,2) AS MoMPercentChange
FROM(
SELECT 
Month(OrderDate) OrderMonth,
SUM(Sales) AS CurrentMonthSales,
LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) AS PreviousMonthSales,
(SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate))) AS MoMChange
FROM Sales.Orders
GROUP BY MONTH(OrderDate)
)a

--In order to analyze customer loyalty, rank customers
--based on the average days between their orders



SELECT CustomerID,
AVG(DaysDiff) AS AvgOrderDays,
RANK() OVER(ORDER BY COALESCE(NULLIF(AVG(DaysDiff),0),999999)) AS RankVal
FROM(
SELECT 
	CustomerID,
	COALESCE(DATEDIFF(DAY,CurrentOrderDate,NextOrderDate),0) AS DaysDiff,
	AVG(COALESCE(DATEDIFF(DAY,CurrentOrderDate,NextOrderDate),0)) OVER(PARTITION BY CustomerID ORDER BY CustomerID) AS DaysAVG
FROM(
SELECT 
	OrderID,
	CustomerID,
	OrderDate AS CurrentOrderDate,
	LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY CustomerID,OrderDate) AS NextOrderDate
FROM Sales.Orders
)a
)b
GROUP BY CustomerID

--- FIRST_VALUE() and LAST_VALUE()
--Find the lowest and highest sales for each product
SELECT 
ProductID,
LowestSalesValue,
HighestSalesValue,
MinSalesValue,
MaxSalesValue
FROM(
SELECT 
ProductID,
Sales,
FIRST_VALUE(Sales) OVER(PARTITION BY ProductID Order BY Sales) AS LowestSalesValue,
FIRST_VALUE(Sales) OVER(PARTITION BY ProductID Order BY Sales DESC) AS HighestSalesValue,
LAST_VALUE(Sales)  OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS LowestFuncVal,
LAST_VALUE(Sales)  OVER(PARTITION BY ProductID ORDER BY Sales DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) AS LowestFuncVal2,
MIN(Sales) OVER(PARTITION BY ProductID) AS MinSalesValue,
MAX(Sales) OVER(PARTITION BY ProductID) AS MaxSalesValue
FROM Sales.Orders
)a
GROUP BY ProductID,LowestSalesValue,
HighestSalesValue,MinSalesValue,
MaxSalesValue

--Find the lowest and highest sales for each product
--Find the difference in sales between the current and the lowest sales
SELECT 
ProductID,
Sales,
FIRST_VALUE(Sales) OVER(PARTITION BY ProductID Order BY Sales) AS LowestSalesValue,
FIRST_VALUE(Sales) OVER(PARTITION BY ProductID Order BY Sales DESC) AS HighestSalesValue,
(Sales - (FIRST_VALUE(Sales) OVER(PARTITION BY ProductID Order BY Sales))) AS LowestSalesDifference
FROM Sales.Orders

