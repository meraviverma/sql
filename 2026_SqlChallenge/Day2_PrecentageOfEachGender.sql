-- You’re given a basic Employee table:
-- 📄 Input Table: Employee(   id ,name ,gender  )

--  🎯 Your Task:
-- Calculate the percentage of each gender in the company.

-- ✅ Output must:
-- Show gender-wise percentages
-- Be rounded to 2 decimal places

-- Include the % symbol in the result
-- 📊 Expected Output:
--  (  Gender, Percentage )

create table Employee(
id varchar(30),
name varchar(30),
gender varchar(30)
);

Insert into Employee Values(1,'Alice','Female');
Insert into Employee Values(2,'Bob','Male');
Insert into Employee Values(3,'Carol','Female');
Insert into Employee Values(4,'David','Male');
Insert into Employee Values(5,'Eve','Female');

-- Solution 1:
SELECT
    gender,
    CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employee), 2), '%') AS Percentage
FROM Employee
GROUP BY gender;

-- Explanation:
-- 1. We select the `gender` column to group our results by gender
-- 2. We calculate the percentage for each gender by counting the number of employees of that gender, multiplying by 100, and dividing by the total number of employees (which we get from a subquery).
-- 3. We round the result to 2 decimal places using the `ROUND` function and concatenate a '%' symbol to the end of the percentage string using the `CONCAT` function.
-- 4. Finally, we group the results by `gender` to get the percentage for each gender.

-- SOlution 2 (using CTE):
WITH TotalCount AS (
    SELECT COUNT(*) AS Total FROM Employee
)
SELECT
    e.gender,
    CONCAT(ROUND(COUNT(*) * 100.0 / tc.Total, 2), '%') AS Percentage
FROM Employee e
CROSS JOIN TotalCount tc
GROUP BY e.gender, tc.Total;

-- Explanation:
-- 1. We use a Common Table Expression (CTE) named `TotalCount` to calculate the total number of employees once, which can be more efficient than calculating it in a subquery for each row.
-- 2. We then perform a `CROSS JOIN` between the `Employee` table and the `TotalCount` CTE to make the total count available for our percentage calculation.
-- 3. The rest of the calculation is the same as in Solution 1, where we count the number of employees for each gender, calculate the percentage, round it, and concatenate the '%' symbol.

-- SOlution 3 (using UNION ALL):
SELECT 
    'Female' AS gender,
    ROUND((SUM(CASE when gender = 'Female' THEN 1 ELSE 0 END) * 100 / COUNT(*)), 2) AS percentage
FROM Employee

UNION ALL

SELECT 
    'Male' AS gender,
    ROUND((SUM(CASE when gender = 'Male' THEN 1 ELSE 0 END) * 100 / COUNT(*)), 2) AS percentage
FROM Employee;

-- Explanation:
-- 1. We use two separate SELECT statements to calculate the percentage for each gender.
-- 2. In each SELECT statement, we use a `CASE` statement to count the number of employees of the specified gender.
-- 3. We calculate the percentage by dividing the count of the specified gender by the total count of employees and multiplying by 100.
-- 4. We round the result to 2 decimal places using the `ROUND` function.
-- 5. Finally, we combine the results of both SELECT statements using `UNION ALL` to get the final output with percentages for both genders.


-- ## Explanation

-- This expression calculates the percentage of rows where `gender = 'Male'`.

-- ### Breakdown

-- - `CASE WHEN gender = 'Male' THEN 1 ELSE 0 END`
--   - Produces `1` for male rows
--   - Produces `0` for non-male rows

-- - `SUM(...)`
--   - Adds those 1s and 0s
--   - Result = count of male rows

-- - `COUNT(*)`
--   - Total number of rows in the result set

-- - `SUM(...) * 100 / COUNT(*)`
--   - Converts the male count into a percentage of the total
--   - Example: if 30 of 100 rows are male, this gives `30 * 100 / 100 = 30`

-- - `ROUND(..., 2)`
--   - Rounds the final percentage to 2 decimal places
--   - Example: `33.3333` becomes `33.33`

-- ### Final result

-- `percentage` is the male ratio expressed as a percent, rounded to two decimals.

-- "Male"	"40.00%"
-- "Female"	"60.00%"