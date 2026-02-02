--find the running total of sales for each month

SELECT 
MONTH(OrderDate) AS Month,
SUM(Sales) AS TotalSales,
SUM(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) AS RunningTotal
FROM Sales.Orders
GROUP BY MONTH(OrderDate);

--Using CTE

WITH CTE_MonthlySummary AS (
    SELECT 
        MONTH(OrderDate) AS Month,
        SUM(Sales) AS TotalSales,
        COUNT(OrderID) AS NumOfOrders,
        SUM(Quantity) AS TotalQuantities
    FROM Sales.Orders
    GROUP BY MONTH(OrderDate)
)
SELECT 
    Month,
    TotalSales,
    SUM(TotalSales) OVER(ORDER BY Month) AS RunningTotal
FROM CTE_MonthlySummary;

--Creating View

CREATE VIEW V_MonthlySummary AS
(
    SELECT 
        MONTH(OrderDate) AS Month,
        SUM(Sales) AS TotalSales,
        COUNT(OrderID) AS NumOfOrders,
        SUM(Quantity) AS TotalQuantities
    FROM Sales.Orders
    GROUP BY MONTH(OrderDate)
    )

--Creating View under Sales schema
CREATE VIEW Sales.V_MonthlySummary AS
(
    SELECT 
        MONTH(OrderDate) AS Month,
        SUM(Sales) AS TotalSales,
        COUNT(OrderID) AS NumOfOrders,
        SUM(Quantity) AS TotalQuantities
    FROM Sales.Orders
    GROUP BY MONTH(OrderDate)
    );

SELECT *
FROM Sales.V_MonthlySummary

--Generating running totals from view

SELECT 
    Month,
    TotalSales,
    SUM(TotalSales) OVER(ORDER BY Month) AS RunningTotal
FROM Sales.V_MonthlySummary;

--Drop a view

DROP VIEW V_MonthlySummary

--Updating a View
--First DROP existing View and then Create new View

--Provide a view that combines details from orders, products, customers, and employees
SELECT
o.OrderID,
o.OrderDate,
p.Product,
p.Category,
COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') AS CustomerName,
c.Country AS CustomerCountry,
COALESCE(e.FirstName,'') + ' ' + COALESCE(e.LastName,'') AS EmployeeName,
e.Department,
o.Sales,
o.Quantity
FROM Sales.Orders o
LEFT JOIN Sales.Products p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Employees e
ON o.SalesPersonID = e.EmployeeID

SELECT * FROM Sales.Orders
SELECT * FROM Sales.Products
SELECT * FROM Sales.Customers
SELECT * FROM Sales.Employees

CREATE VIEW Sales.V_OrderDetails AS (
SELECT
o.OrderID,
o.OrderDate,
p.Product,
p.Category,
COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') AS CustomerName,
c.Country AS CustomerCountry,
COALESCE(e.FirstName,'') + ' ' + COALESCE(e.LastName,'') AS EmployeeName,
e.Department,
o.Sales,
o.Quantity
FROM Sales.Orders o
LEFT JOIN Sales.Products p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Employees e
ON o.SalesPersonID = e.EmployeeID
)

SELECT * FROM Sales.V_OrderDetails

--Provide a view for EU Sales Team
--that combines details from all tables
--and excludes Data related to the USA

SELECT *
FROM Sales.V_OrderDetails
WHERE CustomerCountry != 'USA'

CREATE VIEW Sales.V_OrderDetailsEU AS (
SELECT
o.OrderID,
o.OrderDate,
p.Product,
p.Category,
COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') AS CustomerName,
c.Country AS CustomerCountry,
COALESCE(e.FirstName,'') + ' ' + COALESCE(e.LastName,'') AS EmployeeName,
e.Department,
o.Sales,
o.Quantity
FROM Sales.Orders o
LEFT JOIN Sales.Products p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Employees e
ON o.SalesPersonID = e.EmployeeID
WHERE c.Country != 'USA'
)

SELECT *
FROM Sales.V_OrderDetailsEU
