MY SQL:
-----------------
WITH RECURSIVE numbers AS (
    SELECT 0 AS DATE
   UNION ALL
   SELECT DATE + 1
   FROM numbers
   WHERE DATE < 10)
SELECT * FROM numbers;

POSTGRES:
----------------------
WITH RECURSIVE Emp_CTE(ID) AS
(
SELECT 1
UNION ALL
SELECT ID + 1 FROM Emp_CTE WHERE ID < 14
)
SELECT * FROM Emp_CTE



------------- PART1: 

CREATE TABLE tblEmployee(EmpID INT PRIMARY KEY     NOT NULL);

INSERT INTO tblEmployee(EmpID) VALUES (14);

Select * from tblEmployee;
1
4
5
7
10
12
14

WITH RECURSIVE Emp_CTE(ID) AS
(
SELECT 1 --------> This is called Anchor Query
UNION ALL
SELECT ID + 1 FROM Emp_CTE WHERE ID < 14 ----------------> Recursive Query
)
--SELECT * FROM Emp_CTE

SELECT EC.ID AS Missing_Sequence FROM Emp_CTE EC 
LEFT JOIN tblEmployee E
ON EC.ID = E.EmpID 
WHERE E.EmpID IS NULL


PART2:
-----------------------------------

CREATE TABLE tblEmployee1 (EmpID INT);
INSERT into tblEmployee1 values (51000),(51001),(51004),(51009),(51013),(51017),(51020),(51025),(51026);

select * from tblEmployee1;

51000
51001
51004
51009
51013
51017
51020
51025
51026

WITH RECURSIVE Emp_CTE(ID) AS
(
SELECT 51000
UNION ALL
SELECT ID + 1 FROM Emp_CTE WHERE ID < 51026
)
--SELECT * FROM Emp_CTE

SELECT EC.ID AS Missing_Sequence FROM Emp_CTE EC 
LEFT JOIN tblEmployee1 E
ON EC.ID = E.EmpID 
WHERE E.EmpID IS NULL


Missing_Sequence
---------------------------
51002
51003
51005
51006
51007
51008
51010
51011
51012
51014
51015
51016
51018
51019
51021
51022
51023
51024

---------------------------------------
PART2:
---------------------------------------
Using SQL Server:

CREATE TABLE tblEmployee1 (EmpID INT)

INSERT tblEmployee1 values (51000),(51001),(51004),(51009),(51013),(51017),(51020),(51025),(51026)

SELECT * FROM tblEmployee1

DECLARE @StartID INT, @EndID INT;
SELECT @StartID = MIN(EmpID) FROM tblEmployee1
SELECT @EndID = MAX(EmpID) FROM tblEmployee1

;WITH Emp_CTE(ID) AS 
 (
 SELECT @StartID 
 UNION ALL
 SELECT ID + 1 FROM Emp_CTE WHERE ID < @EndID
 )
SELECT EC.ID AS Missing_Sequence FROM Emp_CTE EC 
LEFT JOIN tblEmployee1 E
ON EC.ID = E.EmpID 
WHERE E.EmpID IS NULL

