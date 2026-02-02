--Generate a report showing the total sales for each category:
 --High: If the sales higher than 50
 --Medium: If the sales between 20 and 50
 --Low: If the sales equal or lower than 20
--Sort the result from lowest to highest
SELECT 
Category,
SUM(Sales) AS TotalSales
FROM
(
SELECT *,
CASE
	WHEN Sales>50 THEN 'High'
	WHEN Sales>20 AND Sales<=50 THEN 'Medium'
	ELSE 'Low' 
END AS Category
FROM sales.orders) AS A
GROUP BY Category
ORDER BY TotalSales DESC

--Retrive employee details with gender displayed as full text
SELECT
EmployeeID,
FirstName,
LastName,
Gender,
CASE
	WHEN Gender = 'M' THEN 'Male'
	WHEN Gender = 'F' THEN 'Female'
	ELSE 'Not Available'
END AS NewGender
FROM Sales.Employees

--Retrive customers details with abbreviated country code
SELECT
	CustomerID,
	FirstName,
	LastName,
	Country,
	CASE
		WHEN Country='Germany' THEN 'GE'
		WHEN Country='USA' THEN 'US'
		ELSE 'N/A'
	END AS AbbrCountry,
		CASE Country        --Use this format only if you are sure with the single column logic
		WHEN 'Germany' THEN 'GE'
		WHEN 'USA' THEN 'US'
		ELSE 'N/A' 
	END AS QuickFormat
FROM Sales.Customers 

--CASE
--#Uscase: Handling NULL values
--Find the average score of customers and treat NULLs as 0
--Additionally provide details such as CustomerID and LastName
SELECT 
CustomerID,
LastName,
CASE 
	WHEN Score IS NULL THEN 0
	ELSE Score
END AS Score,
AVG(CASE 
	WHEN Score IS NULL THEN 0
	ELSE Score
END) OVER()
FROM Sales.Customers

--CASE
--#Usecase: Conditional Aggregations (Apply aggregate functions only on subsets of data that fulfill certain conditions)

--Count how many times each customer has made an order with sales greater than 30
SELECT 
CustomerID,
 COUNT(*) AS NumOfTimes
FROM Sales.Orders
WHERE sales>30
GROUP BY CustomerID

SELECT CustomerID,
SUM(CASE 
		WHEN Sales > 30 THEN 1
		ELSE 0
		END) AS NumOfTimes
FROM Sales.Orders
GROUP BY CustomerID

