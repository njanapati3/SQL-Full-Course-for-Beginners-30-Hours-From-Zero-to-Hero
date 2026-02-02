--- Types of Subquery ---
--Dependency : 2 types - Correlated Subquery and Non-Correlated Subquery
--Result Types: 3 types - Scalar, Row and Table

--Scalar Subquery [return only one value and one column and one row in the output]
SELECT
AVG(Sales) AS AvgSales
FROM Sales.Orders

--Row Subquery [Retrun only one column and multiple rows]
SELECT 
Sales
FROM Sales.Orders

--Table Subquery [returns multiple columns and multiple rows in the output]
Select 
*
FROM Sales.Orders

--Subquery in FROM Clause

/* Task: Find the products that have a price higher than
	the average price of all products */

SELECT *  --Main Query
FROM
(SELECT ProductID, --Sub Query
Price,
AVG(Price) OVER() AS AvgPrice
FROM Sales.Products)a
WHERE Price>AvgPrice

SELECT *  --Main Query
FROM Sales.Products 
WHERE Price > (
SELECT AVG(Price) AS AvgPrice --Sub Query
FROM Sales.Products)

--Rank Customers based on their total amount of sales

SELECT   --Main Query
CustomerID,
Totalsales ,
RANK() OVER(ORDER BY TotalSales DESC) AS CustomerRank
FROM(
SELECT   --Sub Query
	CustomerID,
	Sales,
	SUM(Sales) OVER(PARTITION BY CustomerID) AS TotalSales
FROM Sales.Orders
)a
GROUP BY CustomerID,
Totalsales 

--Subquery in select should be scalar query since it is being used as a field

--Show the product IDs, product names, prices and the total number of orders

SELECT  --Main Query
ProductID,
Product,
Price,
(SELECT COUNT(*) FROM Sales.Orders)AS TotalNumOrders --Sub Query
FROM Sales.Products

SELECT
COUNT(*) AS TotalOrders
FROM Sales.Orders

--Subquery in JOINS

--Show all customer details and find the total orders of each customer

SELECT   --Main Query
c.*,o.TotalOrders
FROM Sales.Customers c
LEFT JOIN
(SELECT CustomerID, COUNT(*) AS TotalOrders  --Sub Query
FROM Sales.Orders
GROUP BY CustomerID) o
ON c.CustomerID = o.CustomerID

--Subquery in WHERE Clause
SELECT *  --Main Query
FROM Sales.Products 
WHERE Price > (
SELECT AVG(Price) AS AvgPrice --Sub Query
FROM Sales.Products)

--Subquery in IN Operator

--Show the details of German customers made orders

SELECT *  --Main Query 
FROM Sales.Customers
WHERE Country = 'Germany'
AND CustomerID IN (SELECT DISTINCT CustomerID FROM Sales.Orders)  --Sub Query

--Show the details of orders made by customers in Germany

SELECT * FROM
Sales.Orders
WHERE CustomerID IN (SELECT CustomerID FROM Sales.Customers WHERE Country = 'Germany')

--ANY ALL OPERATOR--
--Find female employees whose salaries are greater than the salaries of any male employees

SELECT *  --Main Query
FROM Sales.Employees
WHERE GENDER = 'F' 
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M') --Sub Query
--#Here ANY operator compares with any ONE value in the list,
--#if it was ALL operator it compares with ALL values in the list

--Find female employees whose salaries are greater 
--than the salaries of all male employees

SELECT *  --Main Query
FROM Sales.Employees
WHERE GENDER = 'F' 
AND Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M') --Sub Query

--Correlate Subquery
--Show all customer details and find the total orders for each customer

SELECT --Main Query
*,
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) AS TotalSales --Corelated Sub Query
FROM Sales.Customers c

---EXISTS---
--#Check if a subquery returns any rows

--Show the order details for customers in Germany

SELECT *
FROM Sales.Orders o
WHERE EXISTS (SELECT 1 FROM Sales.Customers c WHERE Country='Germany' AND c.CustomerID = o.CustomerID)

--Show the order details for customers not in Germany
SELECT *
FROM Sales.Orders o
WHERE NOT EXISTS (SELECT 1 FROM Sales.Customers c WHERE Country='Germany' AND c.CustomerID = o.CustomerID)
