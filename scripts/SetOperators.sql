--Combine data from employees and customers into one table
SELECT 
FirstName,
LastName
FROM sales.Customers
UNION
SELECT 
FirstName,
LastName
FROM sales.Employees
ORDER BY FirstName

-- Combine the data from employees and customers into one table, including duplicates
SELECT 
FirstName,
LastName
FROM sales.Customers
UNION ALL
SELECT 
FirstName,
LastName
FROM sales.Employees
ORDER BY FirstName 

--Find the employees who are not customers at the same time
SELECT FirstName,
LastName
FROM sales.employees
EXCEPT
SELECT FirstName,
LastName
FROM sales.customers

--Find the employees who are also customers.
SELECT FirstName,
LastName
FROM sales.employees
INTERSECT
SELECT FirstName,
LastName
FROM sales.customers

--Find the employees who are also customers.
SELECT e.FirstName,
e.LastName
FROM sales.employees e
INNER JOIN
sales.customers c
on e.FirstName = c.FirstName
--Order data are stored in separate tables (Orders and Orders Archive)
--Combine all data into one report without duplcates
SELECT *
FROM sales.orders
EXCEPT
SELECT *
FROM sales.OrdersArchive

