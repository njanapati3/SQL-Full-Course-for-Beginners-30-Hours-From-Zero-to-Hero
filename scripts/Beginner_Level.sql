
select * from customers
where country='Germany'
order by score asc

select first_name,country 
from customers
where country='Germany'

select * from customers 
order by country asc,score desc

SELECT 
country,
AVG(score) AS avg_score
FROM customers where score!=0
GROUP BY country
HAVING AVG(score)>430

--Return Unique list of all countries

SELECT DISTINCT country 
from customers

--Retrive only 3 customers

SELECT TOP 2 * from customers
order by score asc

select * from orders

--Get the Two Most Recent Orders
select TOP 2 * from orders order by order_date desc

/*Create table Persons 
with columns: id,person_name,birth_date,and phone */

CREATE TABLE persons(
	id INT NOT NULL,
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR(15) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY (id)
);

select * from persons

--Add a new column called email to the persons table

ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL

--Remove the column phone from the persons table
ALTER TABLE persons
DROP COLUMN phone 

--Remove table persons from the databse
DROP TABLE persons


INSERT INTO customers (id,first_name,country,score)
VALUES 
	(10,'Sahra',NULL,NULL)

select * from customers

--Insert data from 'customers' into 'persons'
INSERT INTO persons(id, person_name, birth_date, phone)
SELECT
id,
first_name,
NULL,
'Unknown'
FROM customers

SELECT * from persons

-- Change the score of customer 6 to 0

SELECT * FROM customers

UPDATE customers
SET score=0
WHERE id=6

/* Change the score of customer 10 to 0 
and update the country to UK */

UPDATE customers
SET score=0,
	country='UK'
WHERE id=10

/* Update all customers with a NULL 
Score by setting their score to 0 */

UPDATE customers
SET score = 0
WHERE score IS NULL

SELECT * 
FROM customers
WHERE score IS NULL


--Delete all customers with an ID greater than 5

DELETE FROM customers
WHERE id > 5

SELECT *
FROM customers
WHERE id > 5

--Dlete all data from table persons
TRUNCATE TABLE persons



 