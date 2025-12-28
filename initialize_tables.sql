-- 1. Setup Tables
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT
);

CREATE TABLE employees (
    emp_id INTEGER PRIMARY KEY,
    name TEXT,
    dept_id INTEGER,
    salary INTEGER,
    manager_id INTEGER,
    hire_date DATE
);

CREATE TABLE sales (
    sale_id INTEGER PRIMARY KEY,
    emp_id INTEGER,
    sale_amount DECIMAL(10,2),
    sale_date DATE
);

-- 2. Populate Departments
INSERT INTO departments VALUES (1, 'Engineering'), (2, 'Sales'), (3, 'Marketing');

-- 3. Populate Employees (Including a hierarchy for later)
INSERT INTO employees VALUES 
(1, 'Alice Archer', 1, 150000, NULL, '2020-01-01'), -- The CEO
(2, 'Bob Builder', 1, 120000, 1, '2020-03-15'),
(3, 'Charlie Coder', 1, 120000, 1, '2020-03-15'),
(4, 'David Data', 1, 110000, 2, '2021-05-10'),
(5, 'Eve Engineer', 1, 110000, 2, '2021-06-20'),
(6, 'Frank Flyer', 2, 90000, 1, '2020-02-01'),
(7, 'Grace Giver', 2, 95000, 6, '2020-11-12'),
(8, 'Heidi Hunter', 2, 95000, 6, '2021-01-05'),
(9, 'Ivan Icon', 3, 105000, 1, '2020-04-10'),
(10, 'Julia Just', 3, 85000, 9, '2022-01-01');
-- (Imagine 90 more rows generated with varying salaries and dates)

-- 4. Populate Sales (For Window Function Drills)
INSERT INTO sales (sale_id, emp_id, sale_amount, sale_date) VALUES
(1, 6, 500, '2023-01-01'), (2, 6, 700, '2023-01-02'), (3, 7, 300, '2023-01-02'),
(4, 8, 1000, '2023-01-03'), (5, 6, 200, '2023-01-04'), (6, 7, 800, '2023-01-05'),
(7, 8, 400, '2023-01-05'), (8, 6, 900, '2023-01-06');