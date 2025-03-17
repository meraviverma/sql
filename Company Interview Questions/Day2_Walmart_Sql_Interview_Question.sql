📌 Write a SQL query to output the names of those students whose best friends got higher salary package than student.


Students_Tbl
####################

Create Table Students_Tbl (Id int,
Student_Name Varchar(30));

Insert into Students_Tbl values
(1,'Mark'),
(2,'David'),
(3,'John'),
(4,'Albert');

"id"	"student_name"
1		"Mark"
2		"David"
3		"John"
4		"Albert"

Friends_Tbl
######################


Create Table Friends_Tbl (Id int,
Friend_Id int);

Insert into Friends_Tbl values
(1,2),
(2,3),
(3,4),
(4,1);

"id"	"friend_id"
1		2
2		3
3		4
4		1


Package_Tbl
#######################

Create Table Package_Tbl (Id int,
Salary Bigint );

Insert into Package_Tbl values
(1,18),
(2,12),
(3,13),
(4,15);

"id"	"salary"
1		18
2		12
3		13
4		15


Solution:
--------------------
with student_details AS(
select s.id,s.student_name,p.salary as student_salary,
f.friend_id as friends_id
from Students_Tbl s join Friends_Tbl f
ON s.ID=f.Id join Package_Tbl p
on s.Id=p.id),

student_friend_details AS(
select s.ID,s.student_name,s.student_salary,
	s.friends_id,
	f.student_name as friend_name,
	f.student_salary as friends_salary
	from student_details s join student_details f
	ON f.id=s.friends_id
)
select student_name from student_friend_details
where friends_salary > student_salary


"student_name"
"Albert"
"David"
"John"


### Another SOlution ##########
--------------------------------------
select s.student_name
from
students_tbl s join friends_tbl f on s.id=f.id
join Package_Tbl p on p.id=s.id
join Package_Tbl p1 on p1.id=F.friend_id
where p1.salary > p.salary;


"student_name"
"David"
"John"
"Albert"