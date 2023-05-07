Join Example:
------------------
we shall look at 2 different datasets. Each dataset contains 2 tables which has duplicate data, null values etc. You are required to identify the no of records returned using INNER Join, LEFT Join, RIGHT Join, FULL JOIN, Natural Join and Cross Join. And you need to answer them without querying the tables. 

CREATE TABLE table_1
(id INT);

CREATE TABLE table_2
(id INT);

INSERT INTO table_1 VALUES (1),(1),(1),(2),(3),(3),(3);

INSERT INTO table_2 VALUES (1),(1),(2),(2),(4),(NULL);

SELECT * FROM table_1;

id
1
1
1
2
3
3
3

SELECT * FROM table_2;

id
1
1
2
2
4
NULL

INNER JOIN:
----------------
1	1
1	1
1	1
1	1
1	1
1	1
2	2
2	2

SELECT * FROM table_1 JOIN table_2 ON table_1.id=table_2.id

LEFT JOIN
---------------
SELECT * FROM table_1 LEFT JOIN table_2 ON table_1.id=table_2.id

id	id
1	1
1	1
1	1
1	1
1	1
1	1
2	2
2	2
3	NULL
3	NULL
3	NULL


RIGHT JOIN
-------------------
SELECT * FROM table_1 RIGHT JOIN table_2 ON table_1.id=table_2.id

id	id
1	1
1	1
1	1
1	1
1	1
1	1
2	2
2	2
NULL	4
NULL	NULL

FULL Join
-----------------------

SELECT * FROM table_1 RIGHT JOIN table_2 ON table_1.id=table_2.id

id	id-2
1	1
1	1
1	1
1	1
1	1
1	1
2	2
2	2
3	NULL
3	NULL
3	NULL
NULL	4
NULL	NULL

	
NATURAL Join
-----------------------
select * from table_1 t1 natural join table_2 t2;

"id"
1
1
1
1
1
1
2
2

CROSS Join
------------------

select * from table_1 t1 cross join table_2 t2;

id	id-2
1	1
1	1
1	2
1	2
1	4
1	NULL
1	1
1	1
1	2
1	2
1	4
1	NULL
1	1
1	1
1	2
1	2
1	4
1	NULL
2	1
2	1
2	2
2	2
2	4
2	NULL
3	1
3	1
3	2
3	2
3	4
3	NULL
3	1
3	1
3	2
3	2
3	4
3	NULL
3	1
3	1
3	2
3	2
3	4
3	NULL


-------------- ANother Use case ------------------

create table table_3
(id int);
create table table_4
(id int);

insert into table_3 values (1),(1),(1),(1),(1),(null),(null);
insert into table_4 values (1),(1),(1),(2),(null);

table 3
------------
id
1
1
1
1
1
NULL
NULL


table 4
-----------
id
1
1
1
2
NULL


INNER JOIN 
-------------------

select * from table_3 t1 INNER JOIN table_4 t2 ON t1.id=t2.id;

"id"	"id-2"
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1


LEFT Join
---------------
select * from table_3 t1 LEFT JOIN table_4 t2 ON t1.id=t2.id;

id	id-2
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
NULL	NULL
NULL	NULL


RIGHT Join
----------------------
select * from table_3 t1 RIGHT JOIN table_4 t2 ON t1.id=t2.id;


id	id-2
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
NULL	2
NULL	NULL


FULL JOIN
------------------
select * from table_3 t1 FULL JOIN table_4 t2 ON t1.id=t2.id;

id	id-2
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
1	1
NULL	NULL
NULL	NULL
NULL	2
NULL	NULL


NATURAL JOIN
----------------------

select * from table_3 t1 NATURAL JOIN table_4 t4;

"id"
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

CROSS JOIN
----------------------
select * from table_3 t1 CROSS JOIN table_4 t4;

id	id-2
1	1
1	1
1	1
1	2
1	NULL
1	1
1	1
1	1
1	2
1	NULL
1	1
1	1
1	1
1	2
1	NULL
1	1
1	1
1	1
1	2
1	NULL
1	1
1	1
1	1
1	2
1	NULL
NULL	1
NULL	1
NULL	1
NULL	2
NULL	NULL
NULL	1
NULL	1
NULL	1
NULL	2
NULL	NULL


