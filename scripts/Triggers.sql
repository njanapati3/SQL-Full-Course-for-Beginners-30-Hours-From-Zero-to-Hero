-- Create the Employee log table

CREATE TABLE Sales.EmployeeLogs(
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDate DATE
);

--Creating a trigger
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN 
	INSERT INTO Sales.EmployeeLogs(EmployeeID,LogMessage,LogDate)
	SELECT 
		EmployeeID,
		'New Employee Added = ' + CAST(EmployeeID AS VARCHAR),
		GETDATE()
	FROM INSERTED
END

SELECT * 
FROM Sales.Employees

INSERT INTO Sales.Employees
VALUES
(6, 'Narendra', 'Janapati', 'HR', '1998-07-03', 'M', 80000, 2)

SELECT * 
FROM Sales.Employees

SELECT * 
FROM Sales.EmployeeLogs