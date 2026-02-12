# SQL & Pandas Practice

Personal collection of SQL and pandas exercises. Focused on mastering analytical queries, window functions, and real-world data problems from StrataScratch.

## What's Here

### SQL Foundations
- **`initialize_tables.sql`** - Database schema (departments, employees, sales tables)
- **`main.sql`** - Window functions playground: partitioning, rolling averages, LEAD/LAG, ranking
- **`main2.sql`** - Real-world scenarios: deduplication, category mapping, conditional aggregation

### StrataScratch Problems
- **`stratascratch-sql-easy.sql`** - 1 easy problem (basic joins and aggregation)
- **`stratascratch-sql-medium.sql`** - 8 medium problems covering:
  - User behavior analysis (returning customers, session duration)
  - Date arithmetic and interval logic
  - Recommendation systems with subqueries
  - Self-joins for pattern matching
  - Top-N queries with RANK/DENSE_RANK

### Pandas
- **`pandas/pandas_notes.ipynb`** - Quick reference for lambdas, groupby, apply, vectorization
- **`pandas/pandas_practice.ipynb`** - Practice space
- **`pandas/stratascratch_pandas.ipynb`** - Translating SQL problems to pandas

## Key Concepts Practiced

### Window Functions
Applied `OVER` clauses to compare individual records against group totals without collapsing rows. Used `PARTITION BY` for logical groupings and `ORDER BY` for maintaining sequence. Implemented `ROWS BETWEEN` for sliding windows (moving averages) and running totals.

### Navigation & Ranking
Used `LEAD` and `LAG` for time-series gap analysis. Applied `ROW_NUMBER`, `RANK`, and `DENSE_RANK` to solve Top-N problems and handle ties.

### Real-World Patterns
- Finding duplicate records and keeping only the most recent
- Mapping raw codes to business categories with CASE statements
- Handling NULLs with COALESCE and default values
- Calculating percentages with conditional aggregation
- Self-joins for matching records with multiple criteria

## Sample Problems Solved

**Amazon Returning Users** - Identify users who made a second purchase 1-7 days after their first (no same-day purchases)

**Facebook Session Duration** - Calculate average session time using latest page_load and earliest page_exit per day

**Airbnb Host Ranking** - Rank hosts by total available beds across all their properties using DENSE_RANK

**Meta Recommendation System** - Suggest pages to users based on what their friends follow but they don't

**Employee Matching** - Find pairs of employees with same location and gender, different age and seniority

**Click Analysis** - Calculate percentage of search results clicked vs not clicked in top 3 positions

**Data Deduplication** - Remove duplicate SKUs, keeping only the most recent upload using ROW_NUMBER

## Progress

- Easy: 1/? completed
- Medium: 8/? completed
- Advanced concepts: Window functions, CTEs, ranking ✓
- Pandas: Notes complete, exercises in progress
