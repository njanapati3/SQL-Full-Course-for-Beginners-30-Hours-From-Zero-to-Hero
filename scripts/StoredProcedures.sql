--Step1: Write a Query
--For US Customers find the total number of customers and the average score

SELECT 
	COUNT(*) AS TotalCustomers,
	AVG(Score) AS AvgScore
FROM Sales.Customers
WHERE Country = 'USA'

--Step2: Turning the query into Stored Procedure
CREATE PROCEDURE GetCustomerSummary AS
BEGIN
	SELECT 
	COUNT(*) AS TotalCustomers,
	AVG(Score) AS AvgScore
FROM Sales.Customers
WHERE Country = 'USA'
END

--Executing Procedure

EXEC GetCustomerSummary

--For German Customers find the total number of customers and the average score
DROP PROCEDURE GetCustomerSummary

CREATE PROCEDURE GetCustomerSummary @Country VARCHAR(50)
AS
BEGIN
	SELECT 
	COUNT(*) AS TotalCustomers,
	AVG(Score) AS AvgScore
FROM Sales.Customers
WHERE Country = @Country
END

EXEC GetCustomerSummary @Country = 'USA'

EXEC GetCustomerSummary @Country = 'Germany';

--Alter Store Procedure
ALTER PROCEDURE GetCustomerSummary @Country VARCHAR(50) = 'USA'
--CREATE PROCEDURE GetCustomerSummary @Country VARCHAR(50) = 'USA'
AS
BEGIN
	BEGIN TRY
		DECLARE @TotalCustomers INT, @AvgScore FLOAT
		
		-----=============================-----
		-- Step1: Prepare and Cleanup
		-----=============================-----

		IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
		BEGIN
			PRINT('Updating NULL Scores to Zero');
			UPDATE Sales.Customers
			SET Score = 0
			WHERE Score IS NULL AND Country = @Country
		END

		ELSE
		BEGIN
			PRINT('No NULL Scores found.');
		END;

		-----=============================-----
		-- Step2: Generating Summary Report
		-----=============================-----
		--Calculate Total Customers, Avg Scores for specific country
		SELECT 
			@TotalCustomers = COUNT(*),
			@AvgScore = AVG(Score)
		FROM Sales.Customers
		WHERE Country = @Country
		GROUP BY Country;

		PRINT 'Total Customers from ' + @Country + ': ' + CAST(@TotalCustomers AS VARCHAR);
		PRINT 'Average Score from ' + @Country + ': ' + CAST(@AvgScore AS VARCHAR);
		
		-- Calculate total No. of Orders and Total Sales for specific country
		SELECT 
			COUNT(OrderID) AS TotalOrders,
			SUM(Sales) AS TotalSales
		FROM Sales.Orders o
		JOIN Sales.Customers c
		ON c.CustomerID = o.CustomerID
		WHERE c.Country = @Country;
	END TRY
	BEGIN CATCH
		-----=============================-----
		-- Error Handling
		-----=============================-----
		PRINT('An Error Occured.');
		PRINT('Error Message: ' + ERROR_MESSAGE());
		PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR));
		PRINT('Error Line: ' + CAST(ERROR_LINE() AS VARCHAR));
		PRINT('Error Procedure: ' + ERROR_PROCEDURE());
	END CATCH
END

--Execute Stored Procedure
EXEC GetCustomerSummary 
EXEC GetCustomerSummary @Country = 'Germany'

-- Find the total No. of Orders and Total Sales
SELECT 
COUNT(OrderID) AS TotalOrders,
SUM(Sales) AS TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA'

---Error Handling in Stored Procedure
--Please refer in the procedure