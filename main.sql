/*

This repository contains a collection of SQL scripts focused on advanced analytical techniques and data engineering patterns. The primary goal is to demonstrate how to perform complex data transformations and time-series analysis directly within the database engine.

##Technical Highlights
This project demonstrates proficiency in the following advanced SQL areas:

* **Window Fundamentals & Aggregates**: Applied `OVER` clauses to perform calculations (like `SUM` and `AVG`) across partitions without collapsing rows, allowing for direct comparison between individual records and group totals.
* **Data Partitioning & Sequencing**: Utilized `PARTITION BY` to create logical reset points for calculations and `ORDER BY` to maintain chronological or numerical integrity within windows.
* **Dynamic Window Frames**: Implemented `ROWS BETWEEN` logic for both sliding windows (moving averages) and unbounded frames (running totals).
* **Positional Navigation**: Leveraged `LEAD` and `LAG` for time-series analysis, including time-gap calculations and handling `NULL` edge cases with default parameters.
* **Ranking Logic**: Evaluated and implemented `ROW_NUMBER`, `RANK`, and `DENSE_RANK` to solve "Top-N" business problems and handle ties in competitive datasets.

*/




-- 1. Sum of dept total salary using SUM() or AVG() over a partition to compare individual to the group.
SELECT 
    name, 
    dept_id, 
    salary,
    SUM(salary) OVER (PARTITION BY dept_id) as dept_total_salary
FROM employees;


-- 2. Using ROWS BETWEEN to create sliding averages ie average over 3 days
SELECT sale_id, emp_id, sale_amount,
AVG(sale_amount) OVER (
    PARTITION BY emp_id 
    ORDER BY sale_date 
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) as avg_sale_amount_3days

FROM sales;


-- 3. Look at future or past rows and handling those NULLs with default values
SELECT sale_id, emp_id, sale_amount, sale_date,
LEAD(sale_date, 2, sale_date) OVER (
    ORDER BY sale_date 
) as next_sale_date,

LEAD(sale_date, 2, sale_date) OVER (
    ORDER BY sale_date 
) - sale_date AS days_until_sale_date

FROM sales;



-- Second sale ever made by every employee
WITH RankedSales AS (

    SELECT
        emp_id, 
        sale_date, 
        sale_amount,
        ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY sale_date) as sale_rank
    FROM sales

)SELECT * FROM RankedSales WHERE sale_rank = 2;



-- 4. Ranking --> Row_number() to rank sequentially, dense_rank() to retain rank numbers, rank() to skip over rank numbers
-- In a real company database, you often need to find the top earners within each department rather than the whole company at once. To do this, we bring back the PARTITION BY clause we discussed earlier.
WITH SalaryLeaderboard AS (
    SELECT emp_id, salary, dept_id, 
    DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) as salary_rank
    FROM employees
)
SELECT * FROM SalaryLeaderboard WHERE salary_rank <= 3;




-- Meta: Recommendation System - You are given the list of Facebook friends and the list of Facebook pages that users follow. Your task is to create a new recommendation system for Facebook. For each Facebook user, find pages that this user doesn't follow but at least one of their friends does. Output the user ID and the ID of the page that should be recommended to this user.

select distinct f.user_id, f.friend_id, s.page_id

from users_friends as f JOIN users_pages as s ON f.friend_id = s.user_id

WHERE (f.user_id, s.page_id) NOT IN (

select user_id, page_id FROM users_pages 

);
