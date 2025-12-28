# Advanced SQL: Analytical & Window Functions

This repository contains a collection of SQL scripts focused on advanced analytical techniques and data engineering patterns. The primary goal is to demonstrate how to perform complex data transformations and time-series analysis directly within the database engine.

##Technical Highlights
This project demonstrates proficiency in the following advanced SQL areas:

* **Window Fundamentals & Aggregates**: Applied `OVER` clauses to perform calculations (like `SUM` and `AVG`) across partitions without collapsing rows, allowing for direct comparison between individual records and group totals.
* **Data Partitioning & Sequencing**: Utilized `PARTITION BY` to create logical reset points for calculations and `ORDER BY` to maintain chronological or numerical integrity within windows.
* **Dynamic Window Frames**: Implemented `ROWS BETWEEN` logic for both sliding windows (moving averages) and unbounded frames (running totals).
* **Positional Navigation**: Leveraged `LEAD` and `LAG` for time-series analysis, including time-gap calculations and handling `NULL` edge cases with default parameters.
* **Ranking Logic**: Evaluated and implemented `ROW_NUMBER`, `RANK`, and `DENSE_RANK` to solve "Top-N" business problems and handle ties in competitive datasets.

## Key Examples

### 1. Rolling Averages & Running Totals
Calculates a 7-day moving average of sales to smooth out daily fluctuations.
