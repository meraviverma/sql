CREATE SCHEMA LeetCode;
USE LeetCode;



-----------------------------------------------------------------------------------------
################### Department_Top_Three_Salaries ###########################
-----------------------------------------------------------------------------------------

# Department Top Three Salaries

## Description
The Employee table holds all employees. Every employee has an Id, and there is also a column for the department Id.
```
+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
+----+-------+--------+--------------+
```
The Department table holds all departments of the company.
```
+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
```
Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows.
```
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Joe      | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
```

Load the database file [db.sql](db.sql) to localhost MySQL. Relevant tables will be created in the LeetCode database. 
```
mysql < db.sql -uroot -p
```

---
## Observation
Make the following observation to interviewers. Confirm your observation is correct. Ask for clarification if necessary.
* Are salary distinct for all employee? If not, must use __DISTINCT__ keyword.
* How to display if department has fewer than 3 distinct salaries? 
* Every employment belongs to a department? No employee has __NULL__ in *DepartmentId*.

---
## On Correctness
What does top-3 paid employees in each department have in common?
* They have the same DepartmentId.
* They have fewer than 3 persons who get paid higher salary (can use either < 3 or <= 2).
* Department No. 1 has 0 above him.
* Department No. 2 has 1 above him.
* Department No. 3 has 2 above him.
The conditions are set-up for correlated subquery. In subquery, we can use an equijoin (*DepartmentId*) and non-equijoin (*Salary*) to filter the outer query.




CREATE TABLE IF NOT EXISTS Employee (Id INT, NAME VARCHAR(255), Salary INT, DepartmentId INT);
CREATE TABLE IF NOT EXISTS Department (Id INT, NAME VARCHAR(255));

INSERT INTO Employee (Id, NAME, Salary, DepartmentId) VALUES ('1', 'Joe', '70000', '1');
INSERT INTO Employee (Id, NAME, Salary, DepartmentId) VALUES ('2', 'Henry', '80000', '2');
INSERT INTO Employee (Id, NAME, Salary, DepartmentId) VALUES ('3', 'Sam', '60000', '2');
INSERT INTO Employee (Id, NAME, Salary, DepartmentId) VALUES ('4', 'Max', '90000', '1');
INSERT INTO Employee (Id, NAME, Salary, DepartmentId) VALUES ('5', 'Janet', '69000', '1');
INSERT INTO Employee (Id, NAME, Salary, DepartmentId) VALUES ('6', 'Randy', '85000', '1');

INSERT INTO Department (Id, NAME) VALUES ('1', 'IT');
INSERT INTO Department (Id, NAME) VALUES ('2', 'Sales');

SELECT * FROM Employee;

Id	Name	Salary	DepartmentId
1	Joe		70000	1
2	Henry	80000	2
3	Sam		60000	2
4	Max		90000	1
5	Janet	69000	1
6	Randy	85000	1


SELECT * FROM Department;

Id	Name
1	IT
2	Sales

----------------------------------------------------------------
WITH department_ranking AS (
SELECT 
DENSE_RANK() OVER (PARTITION BY DepartmentId ORDER BY salary DESC) AS RNK,
salary,
DepartmentId,
NAME AS employeename
FROM 
Employee)

SELECT employeename,salary,DepartmentId FROM department_ranking WHERE RNK <= 3

employeename	salary	DepartmentId
Max				90000	1
Randy			85000	1
Joe				70000	1
Henry			80000	2
Sam				60000	2

-----------------------------------------------------------------------------

WITH department_ranking AS (
SELECT
  e.Name AS Employee
  ,e.Salary
  ,e.DepartmentId
  ,DENSE_RANK() OVER (PARTITION BY e.DepartmentId ORDER BY e.Salary DESC) AS rnk
FROM Employee AS e
)
-- pre-filter table to reduce join size
,top_three AS (
SELECT
  Employee
  ,Salary
  ,DepartmentId
FROM department_ranking 
WHERE rnk <= 3
)
SELECT
  d.Name AS Department
  ,e.Employee
  ,e.Salary
FROM top_three AS e
JOIN Department AS d
ON e.DepartmentId = d.Id
ORDER BY d.Name ASC, e.Salary DESC;


Department	Employee	Salary
IT			Max			90000
IT			Randy		85000
IT			Joe			70000
Sales		Henry		80000
Sales		Sam			60000

----------------------------------------------------------------------------------------
WITH department_ranking AS (
SELECT
  e.Name AS Employee
  ,e.Salary
  ,e.DepartmentId
  ,DENSE_RANK() OVER (PARTITION BY e.DepartmentId ORDER BY e.Salary DESC) AS rnk
FROM Employee AS e
)
SELECT
  d.Name AS Department
  ,r.Employee
  ,r.Salary
FROM department_ranking AS r
JOIN Department AS d
  ON r.DepartmentId = d.Id
  AND r.rnk <= 3
ORDER BY d.Name ASC, r.Salary DESC;

Department	Employee	Salary
IT			Max			90000
IT			Randy		85000
IT			Joe			70000
Sales		Henry		80000
Sales		Sam			60000


---------------------------------------------------------------------------------------------------------
Using Corelated Subquery
--------------------------------------------------------------------------------------------------------

SELECT
  d.Name AS 'Department'
  ,e.Name AS 'Employee'
  ,e.Salary
FROM Employee e
JOIN Department d
  ON e.DepartmentId = d.Id
WHERE
  (SELECT COUNT(DISTINCT e2.Salary)
  FROM
    Employee e2
  WHERE
    e2.Salary > e.Salary
      AND e.DepartmentId = e2.DepartmentId
      ) < 3;
	  
	  

Department	Employee	Salary
IT			Joe			70000
Sales		Henry		80000
Sales		Sam			60000
IT			Max			90000
IT			Randy		85000
