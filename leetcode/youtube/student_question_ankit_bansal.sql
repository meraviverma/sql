
Problem 1 Fairly easy
Problem 2 Interesting one
Problem 3 Tricky one
Problem 4 Typical lead/lag 


CREATE TABLE [students](
 [studentid] [int] NULL,
 [studentname] [nvarchar](255) NULL,
 [subject] [nvarchar](255) NULL,
 [marks] [int] NULL,
 [testid] [int] NULL,
 [testdate] [date] NULL
);

insert into students values (2,'Max Ruin','Subject1',63,1,'2022-01-02');
insert into students values (3,'Arnold','Subject1',95,1,'2022-01-02');
insert into students values (4,'Krish Star','Subject1',61,1,'2022-01-02');
insert into students values (5,'John Mike','Subject1',91,1,'2022-01-02');
insert into students values (4,'Krish Star','Subject2',71,1,'2022-01-02');
insert into students values (3,'Arnold','Subject2',32,1,'2022-01-02');
insert into students values (5,'John Mike','Subject2',61,2,'2022-11-02');
insert into students values (1,'John Deo','Subject2',60,1,'2022-01-02');
insert into students values (2,'Max Ruin','Subject2',84,1,'2022-01-02');
insert into students values (2,'Max Ruin','Subject3',29,3,'2022-01-03');
insert into students values (5,'John Mike','Subject3',98,2,'2022-11-02');

select * from students;

studentid	studentname	subject	marks	testid	testdate
2	Max Ruin	Subject1	63	1				2022-01-02
3	Arnold		Subject1	95	1				2022-01-02
4	Krish Star	Subject1	61	1				2022-01-02
5	John Mike	Subject1	91	1				2022-01-02
4	Krish Star	Subject2	71	1				2022-01-02
3	Arnold		Subject2	32	1				2022-01-02
5	John Mike	Subject2	61	2				2022-11-02
1	John Deo	Subject2	60	1				2022-01-02
2	Max Ruin	Subject2	84	1				2022-01-02
2	Max Ruin	Subject3	29	3				2022-01-03
5	John Mike	Subject3	98	2				2022-11-02
			
------------ Solution

select sum(marks)/count(subject) as avg_marks,subject from students group by subject

avg_marks	subject
77			Subject1
61			Subject2
63			Subject3


------------------------------------------------------  Question 1 --------------------------------
-- List of students who scored above the average marks in each subject
----------------------------------------------------------------------------------------------------


with avg_cte as ( 
select sum(marks)/count(subject) as avg_marks,subject from students group by subject)

select s1.*,s2.* from students s1
JOIN avg_cte s2
ON s1.subject=s2.subject
where
s1.marks>s2.avg_marks




studentid	studentname	subject		marks	testid	testdate	avg_marks	subject
3			Arnold		Subject1	95		1		2022-01-02	77			Subject1
5			John Mike	Subject1	91		1		2022-01-02	77			Subject1
4			Krish Star	Subject2	71		1		2022-01-02	61			Subject2
2			Max Ruin	Subject2	84		1		2022-01-02	61			Subject2
5			John Mike	Subject3	98		2		2022-11-02	63			Subject3

--------------------- Question2-----------------------------------------------------------------------
-- To get percenatage of students who scored more than 90 in any subject amongst the total student
-------------------------------------------------------------------------------------------------------
select
count(distinct case when marks > 90 then studentname else null end)*1.0/count(distinct(studentname))*100 as per
from students;

---------------- Question 3------------------------------------------------------------
-- Write SQL query to get the second highest and second lowest marks in each subject
--------------------------------------------------------------------------------------
select  max(marks),min(marks),subject from students Group by subject;

max_marks	min_marks	subject
95			61			Subject1
84			32			Subject2
98			29			Subject3


select subject,marks from (select *,DENSE_RANK() over ( partition by subject order by marks desc) as rn from students) as tbl where rn=2
UNION
select subject,marks from (select *,DENSE_RANK() over ( partition by subject order by marks asc) as rn from students) as tbl where rn=2

subject		marks
Subject1	63
Subject1	91
Subject2	60
Subject2	71
Subject3	29
Subject3	98


select subject,marks
,dense_rank() over(partition by subject order by marks asc) as rnk_asc
,dense_rank() over(partition by subject order by marks desc) as rnk_desc
from students


subject		marks	rnk_asc	rnk_desc
Subject1	95		4		1
Subject1	91		3		2
Subject1	61		1		4
Subject2	84		5		1
Subject1	63		2		3
Subject2	71		4		2
Subject2	61		3		3
Subject2	60		2		4
Subject2	32		1		5
Subject3	98		2		1
Subject3	29		1		2


select subject
--, sum(case when rnk_desc=2 then marks else null end) as second_highest_marks
--, sum(case when rnk_asc=2 then marks else null end) as second_lowest_marks
,case when rnk_desc=2 then marks else null end as second_highest_marks
,case when rnk_asc=2 then marks else null end as second_lowest_marks
from
(
select subject,marks
,dense_rank() over(partition by subject order by marks asc) as rnk_asc
,dense_rank() over(partition by subject order by marks desc) as rnk_desc
from students) A
group by subject

subject	second_highest_marks	second_lowest_marks
Subject1	NULL				NULL
Subject1	91					NULL
Subject1	NULL				63
Subject1	NULL				NULL
Subject2	NULL				NULL
Subject2	71					NULL
Subject2	NULL				NULL
Subject2	NULL				60
Subject2	NULL				NULL
Subject3	NULL				98
Subject3	29					NULL



Another Solution:
----------------------
select subject
, sum(case when rnk_desc=2 then marks else null end) as second_highest_marks
, sum(case when rnk_asc=2 then marks else null end) as second_lowest_marks
from
(
select subject,marks
,dense_rank() over(partition by subject order by marks asc) as rnk_asc
,dense_rank() over(partition by subject order by marks desc) as rnk_desc
from students) A
group by subject

subject	second_highest_marks	second_lowest_marks
Subject1	91					63
Subject2	71					60
Subject3	29					98



------------------------------------------- Question 4----------------------------------------------

--For each student and test, identify if their marks increased or decreased from the pervious test
----------------------------------------------------------------------------------------------------
select *
,lag(marks,1) over(partition by studentid order by testdate,subject) as prev_marks
from students

studentid	studentname	subject		marks	testid	testdate	prev_marks
1			John Deo	Subject2	60		1		2022-01-02	NULL
2			Max Ruin	Subject1	63		1		2022-01-02	NULL
2			Max Ruin	Subject2	84		1		2022-01-02	63
2			Max Ruin	Subject3	29		3		2022-01-03	84
3			Arnold		Subject1	95		1		2022-01-02	NULL
3			Arnold		Subject2	32		1		2022-01-02	95
4			Krish Star	Subject1	61		1		2022-01-02	NULL
4			Krish Star	Subject2	71		1		2022-01-02	61
5			John Mike	Subject1	91		1		2022-01-02	NULL
5			John Mike	Subject2	61		2		2022-11-02	91
5			John Mike	Subject3	98		2		2022-11-02	61


select *
,lag(marks,1) over(partition by studentid order by testdate,subject) as prev_marks
,lead(marks,1) over(partition by studentid order by testdate,subject) as next_marks
from students

studentid	studentname	subject		marks	testid	testdate	prev_marks	next_marks
1			John Deo	Subject2	60		1		2022-01-02	NULL	NULL
2			Max Ruin	Subject1	63		1		2022-01-02	NULL	84
2			Max Ruin	Subject2	84		1		2022-01-02	63		29
2			Max Ruin	Subject3	29		3		2022-01-03	84		NULL
3			Arnold		Subject1	95		1		2022-01-02	NULL	32
3			Arnold		Subject2	32		1		2022-01-02	95		NULL
4			Krish Star	Subject1	61		1		2022-01-02	NULL	71
4			Krish Star	Subject2	71		1		2022-01-02	61		NULL
5			John Mike	Subject1	91		1		2022-01-02	NULL	61
5			John Mike	Subject2	61		2		2022-11-02	91		98
5			John Mike	Subject3	98		2		2022-11-02	61		NULL

==============================
SOLUTION:
==============================

select *
, case when marks > prev_marks then 'inc'
when marks < prev_marks then 'dec'
else null end as statys
from (
select *
,lag(marks,1) over(partition by studentid order by testdate,subject) as prev_marks
from students
) A

studentid	studentname	subject		marks	testid	testdate	prev_marks	statys
1			John Deo	Subject2	60		1		2022-01-02	NULL		NULL
2			Max Ruin	Subject1	63		1		2022-01-02	NULL		NULL
2			Max Ruin	Subject2	84		1		2022-01-02	63			inc
2			Max Ruin	Subject3	29		3		2022-01-03	84			dec
3			Arnold		Subject1	95		1		2022-01-02	NULL		NULL
3			Arnold		Subject2	32		1		2022-01-02	95			dec
4			Krish Star	Subject1	61		1		2022-01-02	NULL		NULL
4			Krish Star	Subject2	71		1		2022-01-02	61			inc
5			John Mike	Subject1	91		1		2022-01-02	NULL		NULL
5			John Mike	Subject2	61		2		2022-11-02	91			dec
5			John Mike	Subject3	98		2		2022-11-02	61			inc
		
