# Contributing to SQL Server Complete Guide

Thank you for considering contributing to this project! 🎉

## How to Contribute

### Reporting Issues
- Use GitHub Issues to report bugs
- Provide clear description and steps to reproduce
- Include SQL Server version and environment details

### Suggesting Enhancements
- Open an issue with the "enhancement" label
- Describe the proposed feature clearly
- Explain the use case and benefits

### Contributing Code

1. **Fork the Repository**
   ```bash
   git fork https://github.com/yourusername/sql-server-complete-guide.git
   ```

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**
   - Add comprehensive comments to SQL code
   - Follow existing code style
   - Test all scripts before committing

4. **Commit Your Changes**
   ```bash
   git commit -m "Add: Description of your changes"
   ```

5. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request**
   - Provide clear description of changes
   - Reference any related issues

## Code Style Guidelines

### SQL Formatting
```sql
-- Use uppercase for SQL keywords
SELECT column1, column2
FROM table_name
WHERE condition = value;

-- Indent nested queries
SELECT *
FROM (
    SELECT column1
    FROM table_name
) AS subquery;

-- Add comments for complex logic
-- This query calculates the running total
SELECT 
    customer_id,
    SUM(sales) OVER(ORDER BY order_date) AS running_total
FROM orders;
```

### File Organization
- Place files in appropriate directories
- Use descriptive file names
- Follow naming conventions:
  - SQL files: PascalCase or snake_case
  - Documentation: kebab-case

### Documentation
- Add header comments to new SQL files
- Explain complex queries
- Include usage examples
- Update README if adding new topics

### Example Header Comment
```sql
/*
===============================================================================
Script Name:    YourScript.sql
Purpose:        Brief description of what this script does
Author:         Your Name
Date Created:   2026-02-01
Prerequisites:  Any required setup or dependencies
Usage:          How to run this script
Examples:       Sample queries demonstrating usage
===============================================================================
*/
```

## What to Contribute

### We Welcome
✅ New SQL examples and techniques  
✅ Performance optimization tips  
✅ Real-world use cases  
✅ Documentation improvements  
✅ Bug fixes  
✅ Additional learning resources  

### Please Avoid
❌ Proprietary or sensitive code  
❌ Untested scripts  
❌ Code without comments  
❌ Breaking changes without discussion  

## Testing Your Contributions

Before submitting:
1. **Test all SQL scripts** on SQL Server 2016+
2. **Verify syntax** is correct
3. **Check for errors** in execution
4. **Ensure code is well-commented**
5. **Update documentation** if needed

## Questions?

Feel free to:
- Open an issue for questions
- Start a discussion in GitHub Discussions
- Reach out to maintainers

## Code of Conduct

- Be respectful and constructive
- Welcome newcomers
- Focus on collaboration
- Provide helpful feedback

---

**Thank you for helping improve this resource! 🙏**
