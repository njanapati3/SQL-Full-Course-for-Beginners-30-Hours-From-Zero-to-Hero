--Important Notes

--For small-medium tables, the query optimizer may react similarly to different query styles.
--So the main difference can be observed when the is millions and billions


--golden rule
--Always check the execution plan to confirm performance improvements when optimizing your query.
--If there's no improvement, then just focus on readability.

/*
Tips for Performance

1. Select Only Columns only what n eeded instead of SELECT *
2. Avoid unnecessary DISTINCT & ORDER BY, use this clauses only when needed.
3. For exploration purposes or to get a glance on table data, limit rows!
4. Create non clustered index on frequently used columns in where clause
5. Avoid applying functions to columns in WHERE clause,
	because this will affect index usage since the index might be created on a column without function.
	EX: SELECT * FROM A WHERE LOWER(status) = 'delivered' --bad practice
		SELECT * FROM A WHERE status = 'Delivered' --good practice, make sure using correct values in filter instead of function.
6. Avoid leading[beginning of the value] wildcards as they prevent index usage.
	Ex: SELECT * FROM WHERE Name LIKE '%janapati%' --bad practice
		SELECT * FROM WHERE Name LIKE 'janapati%'
7. Use IN instead of multiple OR

Tips for Joining Data

1. Understand the speed of joins & use inner join when possible.
	As we know inner join > left/right > full join in terms performance
2. Use Explicit Join instead of Implicit join 
	Ex: [INNER JOIN instead of JOIN]
		FROM TableA, TableB -bad , use FROM TableA INNER JOIN TableB
3. Make sure to Index the columns used in the ON clause
4. Filter data before joining [impact will be very different with big tables]
	--Try to isolate the preparation step in CTE or Subquery, especially if the filter is on second table
	--Always avoid using correlated queries since they are inefficient because logic executes for each row
5. Aggregate before joining -this will actually reduces lot of data
6. Use Union instead of OR in joins - it impacts performances, impacts indexes and creates loop joins
7. Check for nested loops and Use SQL Hints -here your'e telling SQL to create efficient execution Plan

Tips for Unions

1. Use UNION ALL instead of UNION - duplicates are acceptable
2. Use UNION ALL + DISTINCT instead of using UNION | duplicates are not acceptable

Tips for aggregations

1. Use Columnstore index for aggregations on large tables.
2. Pre-aggreagate data and store it in new table for reporting

Tips for Subqueries

1. JOIN VS EXISTS VS IN
	--IN operator processess and evaluates all rows. It lacks an early exit mechanism.
	--JOIN is preferred as best if the performance is similar to EXISTS
	--EXISTS better than join because, it stops at first match and avoid data duplications
2. Avoid redundant logic in your query

Other Tips

1. Avoid data types VARCHAR & TEXT 
	--considered as one of the worst data types interms of performance
	--they consume a lot of resources when doing sort operations etc.
	--creating index is also expensive operation
	--problems with data fragmentations
	--text is worse than VARCHAR
2. Avoid(MAX) unnecessarily large lengths in data types
3. Use the NOT NULL constraint where applicable
4. Ensure all your tableshave a clustered primary key 
	--it helps building relationship between tables and also helps performance
5. Creae non-clustered index for foreign keys that are used frequently

Indexes

1. Avoid Over Indexing
2. Drop unused indexes
3. Update Statistics (weekly)
4. Reorganize and Rebuild Indexes (Weekly)
5. Patition large tables(facts) to improve performance. 
	--next apply columnstore index for the best results

*/