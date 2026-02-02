# SQL Server Complete Learning Guide

A comprehensive collection of SQL Server scripts covering everything from beginner to advanced topics. This repository contains hands-on examples, best practices, and real-world use cases for mastering SQL Server.

[![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)](https://www.microsoft.com/sql-server)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 📚 Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Topics Covered](#topics-covered)
- [Getting Started](#getting-started)
- [Learning Path](#learning-path)
- [Key Concepts by File](#key-concepts-by-file)
- [Usage](#usage)
- [Contributing](#contributing)

## 🎯 Overview

This repository is a complete SQL Server learning resource designed for:
- **Beginners** learning SQL fundamentals
- **Intermediate developers** enhancing their skills  
- **Advanced users** optimizing database performance
- **Data Analysts** working with complex queries
- **Database Administrators** managing SQL Server databases

## 📁 Repository Structure

```
sql-server-complete-guide/
│
├── 01-fundamentals/
│   ├── Beginner_Level.sql              # Basic SQL operations
│   ├── Operators.sql                   # SQL operators and conditions
│   └── Functions.sql                   # Built-in SQL functions
│
├── 02-data-manipulation/
│   ├── Joins.sql                       # All types of joins
│   ├── Subquery.sql                    # Subquery techniques
│   ├── CTE.sql                         # Common Table Expressions
│   └── SetOperators.sql                # UNION, INTERSECT, EXCEPT
│
├── 03-advanced-queries/
│   ├── WindowAggregateFunctions.sql    # Window functions & analytics
│   ├── CaseStatements.sql              # Conditional logic
│   └── CTAS_TEMP_Tables.sql            # Temporary tables
│
├── 04-database-objects/
│   ├── Views.sql                       # Creating and managing views
│   ├── StoredProcedures.sql            # Stored procedure development
│   └── Triggers.sql                    # Trigger implementation
│
├── 05-performance-optimization/
│   ├── Indexes.sql                     # Index management
│   ├── ExecutionPlans.sql              # Query optimization
│   ├── Partitions.sql                  # Table partitioning
│   └── PerformanceOptimisation.sql     # Best practices
│
├── 06-projects/
│   └── Final_Project.sql               # Data warehouse project
│
└── docs/
    ├── sql-cheatsheet.md               # Quick reference
    ├── best-practices.md               # Coding standards
    └── learning-resources.md           # Additional resources
```

## 📖 Topics Covered

### 1. Fundamentals 🌱
- SELECT, INSERT, UPDATE, DELETE operations
- WHERE, ORDER BY, GROUP BY, HAVING
- Comparison and logical operators
- Pattern matching with LIKE
- Data types and constraints
- Table creation and modification

### 2. Data Manipulation 🔄
- **Joins**: INNER, LEFT, RIGHT, FULL, CROSS
- **Subqueries**: Correlated and non-correlated
- **CTEs**: Recursive and non-recursive
- **Set Operators**: UNION, UNION ALL, INTERSECT, EXCEPT

### 3. Advanced Queries 🚀
- **Window Functions**: ROW_NUMBER, RANK, DENSE_RANK, NTILE
- **Aggregate Functions**: SUM, AVG, COUNT, MIN, MAX
- **Analytical Functions**: LEAD, LAG, FIRST_VALUE, LAST_VALUE
- **CASE Statements**: Conditional logic
- **Temporary Tables**: #temp tables

### 4. Database Objects 🏗️
- **Views**: Creating reusable query abstractions
- **Stored Procedures**: Parameterized procedures with error handling
- **Triggers**: AFTER INSERT, UPDATE, DELETE triggers

### 5. Performance Optimization ⚡
- **Indexes**: Clustered, Non-clustered, Columnstore, Filtered
- **Execution Plans**: Reading and optimizing query plans
- **Partitioning**: Range and list partitioning
- **Query Optimization**: Best practices and SQL hints
- **Index Management**: Monitoring usage and fragmentation

### 6. Real-World Projects 💼
- **Data Warehouse**: Complete DW implementation
- Schema design (Bronze, Silver, Gold layers)
- Dimensional modeling

## 🚀 Getting Started

### Prerequisites

- **SQL Server** (2016 or later)
  - Express Edition (Free): [Download](https://www.microsoft.com/sql-server/sql-server-downloads)
  
- **SQL Server Management Studio (SSMS)**
  - [Download SSMS](https://aka.ms/ssmsfullsetup)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/sql-server-complete-guide.git
   cd sql-server-complete-guide
   ```

2. **Set up sample database**
   - Create a database named `SalesDB`
   - Execute scripts in order

3. **Start learning!**
   - Begin with `01-fundamentals` if you're new to SQL

## 📚 Learning Path

### Beginner Track (2-3 weeks)
```
Week 1: Fundamentals
└── Beginner_Level.sql
└── Operators.sql
└── Functions.sql

Week 2: Basic Data Manipulation
└── Joins.sql
└── Subquery.sql (basics)

Week 3: Practice & Review
└── Work on simple queries
```

### Intermediate Track (4-6 weeks)
```
Week 1-2: Advanced Queries
└── WindowAggregateFunctions.sql
└── CTE.sql
└── CaseStatements.sql

Week 3-4: Database Objects
└── Views.sql
└── StoredProcedures.sql
└── CTAS_TEMP_Tables.sql

Week 5-6: Performance Basics
└── Indexes.sql (basics)
└── ExecutionPlans.sql
```

### Advanced Track (6-8 weeks)
```
Week 1-2: Advanced Window Functions
└── Master analytical functions

Week 3-4: Performance Optimization
└── Indexes.sql (advanced)
└── Partitions.sql
└── PerformanceOptimisation.sql

Week 5-6: Advanced Objects
└── Triggers.sql
└── Advanced stored procedures

Week 7-8: Real Project
└── Final_Project.sql
```

## 🎓 Key Concepts by File

| File | Key Concepts | Difficulty |
|------|--------------|------------|
| **Beginner_Level.sql** | CRUD operations, filtering, sorting | ⭐ |
| **Operators.sql** | Comparison, logical, BETWEEN, IN, LIKE | ⭐ |
| **Functions.sql** | String, numeric, date/time functions | ⭐⭐ |
| **Joins.sql** | All join types, multi-table queries | ⭐⭐ |
| **Subquery.sql** | Scalar, row, table subqueries | ⭐⭐ |
| **CTE.sql** | Recursive and non-recursive CTEs | ⭐⭐⭐ |
| **WindowAggregateFunctions.sql** | ROW_NUMBER, RANK, LEAD, LAG | ⭐⭐⭐ |
| **Views.sql** | View creation and management | ⭐⭐ |
| **StoredProcedures.sql** | Parameterized SPs, error handling | ⭐⭐⭐ |
| **Indexes.sql** | Index types, management, monitoring | ⭐⭐⭐⭐ |
| **Partitions.sql** | Table partitioning strategies | ⭐⭐⭐⭐ |
| **PerformanceOptimisation.sql** | Query optimization techniques | ⭐⭐⭐⭐ |

## 💡 Usage Examples

### Running a Script

1. Open SSMS or Azure Data Studio
2. Connect to your SQL Server instance
3. Open the desired .sql file
4. Execute the script

### Example: Window Functions

```sql
-- From WindowAggregateFunctions.sql
-- Find top 3 highest sales per product
SELECT * FROM (
    SELECT
        OrderID, ProductID, Sales,
        ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS Rank
    FROM Sales.Orders
) a WHERE Rank <= 3;
```

### Example: Creating an Index

```sql
-- From Indexes.sql
CREATE NONCLUSTERED INDEX idx_Orders_CustomerProduct
ON Sales.Orders (CustomerID, ProductID)
INCLUDE (Sales, OrderDate);
```

## 📊 Best Practices Included

✅ Naming Conventions  
✅ Error Handling  
✅ Index Management  
✅ Query Optimization  
✅ Code Documentation  
✅ Security Best Practices  
✅ Performance Tuning  

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add SQL scripts with comments
4. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file

## 🙏 Acknowledgments

- Microsoft SQL Server Documentation
- SQL Server community

---

**Happy Learning! 📚✨**
