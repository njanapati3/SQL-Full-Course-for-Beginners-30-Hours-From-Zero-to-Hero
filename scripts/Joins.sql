/* Retrive all data from customers and orders
	in two different results */
SELECT * 
FROM customers;

SELECT *
FROM orders;

/* Get all customers along with their orders,
but only for customers who have placed an order */
SELECT *
FROM customers c
INNER JOIN orders o
ON c.id = o.customer_id

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales	
FROM customers c
INNER JOIN orders o
ON c.id = o.customer_id

/* Get all customers along with their orders,
including those who have not placed an order */
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales	
FROM customers c
LEFT JOIN orders o
ON c.id = o.customer_id

/* Get all customers along with their orders,
including orders without matching customers */
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales	
FROM customers c
RIGHT JOIN orders o
ON c.id = o.customer_id

--Solving above problem with LEFT JOIN
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales	
FROM orders o
LEFT JOIN customers c
ON c.id = o.customer_id

--Get all customers and all orders, even if there's no match. 
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales	
FROM customers c
FULL JOIN orders o
ON c.id = o.customer_id

--Get all customers who haven't placed an order
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales	
FROM customers c
LEFT JOIN orders o
ON c.id = o.customer_id
WHERE o.customer_id is NULL

--Get all orders without matching customers
SELECT * 
FROM customers c
RIGHT JOIN orders o
ON c.id = o.customer_id
WHERE c.id is NULL

--Solving above problem with LEFT JOIN
SELECT * 
FROM orders o
LEFT JOIN customers c
ON c.id = o.customer_id
WHERE c.id is NULL

--Find customers without orders and orders without customers
SELECT *
FROM customers c
FULL JOIN orders o
ON c.id = o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL

--Solving above problem using INNER JOIN
SELECT c.*
FROM customers c
WHERE EXISTS (
    SELECT 1  -- This is your subquery
    FROM orders o
    WHERE o.customer_id = c.id
);

/*Get all customers along with their orders, but only
for customers who have placed an order */
SELECT *
FROM customers c
LEFT JOIN orders o
ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL

/* Generate all possible combinations of customers and orders */
SELECT * 
FROM customers
CROSS JOIN orders

/* Task: Using SalesDB, Retrive a list of all orders, along with the related customer,product,
and employee details for each order,display: Order ID, 
Customer's name, Product name, Sales, Price, Sales Persons Name */
USE SalesDB

SELECT *
FROM sales.customers

SELECT *
FROM sales.employees

SELECT 
	o.OrderID,
	o.Sales,
	c.FirstName as CustomerName,
	p.Product as ProductName,
	p.Price,
	e.FirstName as SalesPersonName
FROM sales.orders o
LEFT JOIN sales.products p
ON o.ProductID = p.ProductID
LEFT JOIN sales.Customers c
ON o.CustomerID = c.CustomerID
LEFT JOIN sales.Employees e
ON o.SalesPersonID = e.EmployeeID



SELECT *
FROM sales.products

SELECT *
FROM sales.orders