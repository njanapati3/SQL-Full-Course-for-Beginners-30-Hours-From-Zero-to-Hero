---INDEX
--Data structure provides quick access to data optimising the speed of the query

--Types of Indexes
--Structure: Two types again : Clustered and Non-Clustered Index
--Storage: Two types : Rowstore Index and Columnstore Index
--Functions: Two types : Unique Index and Filtered Index


--Everything in Database is stored in the form of files called as pages
--PAGE: The smallest unit of data storage in a database (8kb). It stores anything(Data, Metadata, Indexes, etc.)
----Types of Pages:  Data Page and Index Page
--Data Page: Contains data related information
--Index Page: It stores key values (Pointers) to another page. It doesn't store actual rows like data pages.
 

 SELECT *
 INTO Sales.DBCustomers
 FROM Sales.Customers

 --Create Clustered Index
 --Rule: Only one clustered index can be created per table
 CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID 
 ON Sales.DBCustomers (CustomerID)

--To drop the index 
DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers

SELECT *
FROM Sales.DBCustomers
WHERE LastName = 'Brown' --This is a full table scan since we don't have any index on lastname

--if we don't specify any index name before by default it will create NONCLUSTERED INDEX so
--CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName ON Sales.DBCustomers(LastName) this and below one is same
CREATE INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers(LastName) 

SELECT *
FROM Sales.DBCustomers
WHERE LastName = 'Brown' --this time it is index scan

SELECT *
FROM Sales.DBCustomers
WHERE FirstName = 'Anna' --here we don't have any index so it will be full table scan

CREATE INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers(FirstName) 

--Creating the Composite Index
SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500 --this one doesn't have index

--Imp: The columns of index order must match the order in your query
CREATE INDEX idx_DBCustomers_CountryScore 
ON Sales.DBCustomers (Country, Score)

SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500 --this one now uses index

SELECT *
FROM Sales.DBCustomers
WHERE Score > 500 AND Country = 'USA' --this one does't uses index thats why order matters and index recognises from left side

--Leftmost Prefix Rule
--Index works only if you query filters start from the first column in the index and follow its order
--If suppose Index defined on Columns (A,B,C,D)
--Index works when we use the order in query as below
--A
--A,B
--A,B,C
--A,B,C,D
--Index deosn't works when we use the order in query as below
--B
--A,C
--B,C
--A,B,D

--Columnstore Index
--Step1: Row Grouping - It will divide the table into two different row groups,
--ex: if we have 2M records top 1M in one group and another 1M in second group
--Step2: Column Segments - Now the each group the each columns will be splitted from each groups
--Step3: Compression - The data will be compressed wherever possible
--ex: for example incase any column has active/inactive repeating it will replace with 1 and 0 for easier search and reducing storage
--Step4: Store - So unlike above row based indexes this will store the final data in LOB Pages

--Syntax 
--CREATE [CLUSTERED | NONCLUSTERED] [COLUMNSTORE] INDEX index_name ON table_naame (col1,col2) 

--Rowstore
--CREATE CLUSTERED INDEX index_name ON table_naame (col1,col2) 
--CREATE NONCLUSTERED INDEX index_name ON table_naame (col1,col2) 

--Columnstore
--CREATE CLUSTERED COLUMNSTORE INDEX index_name ON table_naame --Can't specify column names here, it will be on entire table
--CREATE NONCLUSTERED COLUMNSTORE INDEX index_name ON table_naame (col1,col2) --this is allowed

--create columnstore index
CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON Sales.DBCustomers

DROP INDEX [idx_DBCustomers_CustomerID] ON Sales.DBCustomers  

--Below query throws error
--Msg 35339, Level 16, State 1, Line 105
--Multiple columnstore indexes are not supported.
--Yes in SQL Server we have to go with only one COLUMNSTORE INDEX either CLUSTERED OR NONCLUSTERED
--Where as Azure SQL it supports
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.DBCustomers (FirstName)

--Storage Efficiency Ranking
--1.Columnstore Index
--2.Heap Table
--3.Rowstore Clustered Index


--Unique Index
--Ensures no duplicate values exist in specific column.
--Benefits
--1.Enforce Uniqueness
--2.Slightly increase query performance

--So writing[during build/create] an unique index is slower than non-unique
--While reading an unique index is faster than non-unique

--Syntax 
--Default NON UNIQUE when not given
--CREATE [UNIQUE] [CLUSTERED | NONCLUSTERED] [COLUMNSTORE] INDEX index_name ON table_name (col1,col2) 

CREATE UNIQUE NONCLUSTERED INDEX idx_unq_Products_Category
ON Sales.Products (Category)

--The above query returns below because when we define unique index it acts like unqiue constraint, 
--so if Category column has the duplicate values it doesn't allow to create
--Once Unqiue index gets created it won't allows to insert new records if it violate this constraint
/*
Msg 1505, Level 16, State 1, Line 132
The CREATE UNIQUE INDEX statement terminated because a duplicate key was found for the object name 'Sales.Products' and the index name 'idx_unq_Products_Category'. The duplicate key value is (Accessories).
The statement has been terminated.
*/

CREATE UNIQUE NONCLUSTERED INDEX idx_unq_Products_Product
ON Sales.Products (Product) --this works because on product column we don't have duplicates

INSERT INTO Sales.Products (ProductID, Product) VALUES (106,'Caps')

/* above query violates the constraint so it returns the below error
Msg 2601, Level 14, State 1, Line 147
Cannot insert duplicate key row in object 'Sales.Products' with unique index 'idx_unq_Products_Product'. The duplicate key value is (Caps).
The statement has been terminated.
*/

--Filtered Index
--An index that includes only rows meeting the specified conditions 
--Benifits
--Targeted Optimization
--Reduce storage: Less data in the index

--Syntax 
--Default NON UNIQUE when not given
--CREATE [UNIQUE] [CLUSTERED | NONCLUSTERED] [COLUMNSTORE] INDEX index_name
--ON table_name (col1,col2) WHERE [Condition]
--Rules: 
--Cannot create a filtered index on a clustered index
--Cannot create a filtered index on a columnstore index

 

CREATE NONCLUSTERED INDEX idx_Customers_CountryUSA
ON Sales.Customers (Country)
WHERE Country = 'USA'

--When to Use
/* HEAP: Fast Inserts (For staging tables)/temp tables because it doesn't have any 
        indexes or any ordering on data
Clustered Index[OLTP]: For primary keys if not then for data columns, preferred a column which has unique data
Columnstore Index [OLAP]: For analytica queries since read is faster and storage efficient, 
                if a table is having huge data better to have columnstore index to reduce its size
Non Clustered Index: For non-PK coluns (Foreign keys, joins and filters)
Filtered Index: To target subset of data and to reduce size of index [like above we did only for USA ]
Unique Index: Enforce Uniqueness and improve query speed
*/


--Index Management
--This is super important because indexes has to be monitored and maintained properly
/*
1. Monitor Index Usage
    --this is important because having unused index is unnecesary storage consuming and Write perfromance is slow
    so we have to identify the cause and eliminate if not needed.
2. Monitor Missing Indexes
    --identifying a missing index is very important to improve the performance of the query, 
       SQL server has inbuilt capability using query to provide recomendations about missing indexes.
3. Monitor Duplicate Indexes
    --monitoring duplicate in indexing which means multiple developers creating indexes on same columns
    so this has to be monitored.
4. Update Statistics
5. Monitor Fragmentations
    --unused spaces in data pages and data pages are out of order
*/

--List all indexes on a specific table
--to find this we have a inbuilt procedure

sp_helpindex 'Sales.DBCustomers'

--also we have Sys System Schema which contains metadata about database tables, views, indexes etc

--1.Monitoring Index Usage
SELECT 
	tbl.name AS TableName,
    idx.name AS IndexName,
    idx.type_desc AS IndexType,
    idx.is_primary_key AS IsPrimaryKey,
    idx.is_unique AS IsUnique,
    idx.is_disabled AS IsDisabled,
    s.user_seeks AS UserSeeks,
    s.user_scans AS UserScans,
    s.user_lookups AS UserLookups,
    s.user_updates AS UserUpdates,
    COALESCE(s.last_user_seek, s.last_user_scan) AS LastUpdate
FROM sys.indexes idx  --provides info about indexes
JOIN sys.tables tbl --provides info about tables
    ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s --provides info about index usage history
--[dm_db_index_usage_stats] this is part of a dynamic management view [DMV] 
--provides realtime insights into database performance and system health
    ON s.object_id = idx.object_id
    AND s.index_id = idx.index_id
ORDER BY tbl.name, idx.name;

--Trying to access index and increase the UseSeeks count, this will help how many times index has been accessed
SELECT * FROM Sales.Products
WHERE Product = 'Caps'

--2. Monitoring missing Indexes
--to understand/analyse your query missing indexes first run the query and then execute the command
		   SELECT 
			    COUNT(OrderID) AS TotalOrders,
			    SUM(Sales) AS TotalSales
		    FROM Sales.Orders o
		    JOIN Sales.Customers c
		    ON c.CustomerID = o.CustomerID
		    WHERE c.Country = 'USA';

--query for missing indexes analysis
SELECT * 
FROM sys.dm_db_missing_index_details;

--But always evaluate the above recommendations before creating the index

--3.Monitoring Duplicate Indexes
SELECT  
	tbl.name AS TableName,
	col.name AS IndexColumn,
	idx.name AS IndexName,
	idx.type_desc AS IndexType,
	COUNT(*) OVER (PARTITION BY  tbl.name , col.name ) ColumnCount
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC

--4. Update Statistics
SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    s.name AS StatisticName,
    sp.last_updated AS LastUpdate,
    DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdateDay,
    sp.rows AS 'Rows',
    sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables AS t
    ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY sp.modification_counter DESC;

-- Update statistics for a specific automatically created system statistic
UPDATE STATISTICS Sales.DBCustomers _WA_Sys_00000003_14270015;


-- Update all statistics for the Sales.DBCustomers table
UPDATE STATISTICS Sales.DBCustomers;
GO

-- Update statistics for all tables in the database
EXEC sp_updatestats;

--5. Monitor Fragmentations
-- Retrieve index fragmentation statistics for the current database
SELECT 
    tbl.name AS TableName,
    idx.name AS IndexName,
    s.avg_fragmentation_in_percent,
    s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS s
INNER JOIN sys.tables tbl 
    ON s.object_id = tbl.object_id
INNER JOIN sys.indexes AS idx 
    ON idx.object_id = s.object_id
    AND idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC;

-- Reorganize the index (lightweight defragmentation)
--Defragements leaf nodes to keep them sorted
ALTER INDEX idx_Customers_CountryUSA 
ON Sales.Customers REORGANIZE;


-- Rebuild the index (full rebuild, more resource-intensive)
--Recreates index from Scratch
ALTER INDEX idx_Customers_CountryUSA 
ON Sales.Customers REBUILD;
