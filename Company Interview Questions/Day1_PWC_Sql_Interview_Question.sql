📌 Write an SQL query to get the expected output as below. It should display Id column and derived ‘Comment’ column 

📌 Which will have as either “Only in Source”, “Mismatch” and ”Only in Target” as shown below

📌 Matching One you need to ignore. “Only in Source”, “Mismatch” and ”Only in Target” you have to see.

"Only in Source" → Exists in Src but not in Tgt.
"Only in Target" → Exists in Tgt but not in Src.
"Mismatch" → Exists in both but with different names.
 
CREATE TABLE STATEMENT
##########################################33
CREATE TABLE Src(
id int, 
name varchar(5)
);

INSERT INTO Src VALUES(1,'A'),(2,'B'),(3,'C'),(4,'D');

CREATE TABLE Tgt(
id int, 
name varchar(5)
);

INSERT INTO Tgt VALUES(1,'A'),(2,'B'),(4,'X'),(5,'F')

"id"	"name"
1		"A"
2		"B"
3		"C"
4		"D"

"id"	"name"
1		"A"
2		"B"
4		"X"
5		"F"

OUTPUT:
--------------
Id 	| 	Comment
3  ---	Only in source
4  ---	Mismatch
5  ---	Only in target

Solution:
------------
STEP1:
--------
select s.id as src_id,s.name as src_name,t.id as tgt_id,
	t.name as tgt_name
from src s FULL JOIN Tgt t on s.id=t.id


"src_id"	"src_name"	"tgt_id"	"tgt_name"
1			"A"			1			"A"
2			"B"			2			"B"
3			"C"			[null]		[null]
4			"D"			4			"X"
[null]		[null]		5			"F"



with src_tgt AS(
select s.id as src_id,s.name as src_name,t.id as tgt_id,
	t.name as tgt_name
from src s FULL JOIN Tgt t on s.id=t.id
),

details as (
select src_id,src_name,tgt_id,tgt_name
	from src_tgt where COALESCE(src_name,'') != COALESCE(tgt_name,'')
)

select * from details

"src_id"	"src_name"	"tgt_id"	"tgt_name"
3			"C"			[null]		[null]
4			"D"				4		"X"
[null]		[null]			5		"F"


Final Solution
----------------------
--select * from src;

--select * from tgt;

with src_tgt AS(
select s.id as src_id,s.name as src_name,t.id as tgt_id,
	t.name as tgt_name
from src s FULL JOIN Tgt t on s.id=t.id
),

details as (
select src_id,src_name,tgt_id,tgt_name
	from src_tgt where COALESCE(src_name,'') != COALESCE(tgt_name,'')
)

--select * from details

select 
coalesce(tgt_id,src_id) as ID,
case when tgt_id isNULL then 'Only In Source'
when src_id isnull then 'Only In Target'
when src_id=tgt_id and src_name !=tgt_name then 'Mismatch'
end as comment
from details;

"id"	"comment"
3		"Only In Source"
4		"Mismatch"
5		"Only In Target"

Note:
-------
𝐈𝐒𝐍𝐔𝐋𝐋(): The 𝐈𝐒𝐍𝐔𝐋𝐋() function is used to replace NULL values with a specified default value.

𝐂𝐎𝐀𝐋𝐄𝐒𝐂𝐄(): It returns the first non-NULL value from a list of expressions and works in SQL Server, MySQL, PostgreSQL, Oracle, and more.


################################################################################

select s.id, 'Only In Source' as comment from src s
left join tgt t on s.id=t.id
where t.id is null
UNION
select s.id,'Mismatch' as comment from src s
join tgt t on s.id=t.id
where s.name <> t.name
UNION
select t.id , 'Only In Target' as comment from src s
right join tgt t on s.id=t.id
where s.id is null;




