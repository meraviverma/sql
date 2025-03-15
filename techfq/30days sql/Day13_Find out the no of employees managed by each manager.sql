-- Find out the no of employees managed by each manager.

drop table if exists employee_managers;
create table employee_managers
(
	id			int,
	name		varchar(20),
	manager 	int
);
insert into employee_managers values (1, 'Sundar', null);
insert into employee_managers values (2, 'Kent', 1);
insert into employee_managers values (3, 'Ruth', 1);
insert into employee_managers values (4, 'Alison', 1);
insert into employee_managers values (5, 'Clay', 2);
insert into employee_managers values (6, 'Ana', 2);
insert into employee_managers values (7, 'Philipp', 3);
insert into employee_managers values (8, 'Prabhakar', 4);
insert into employee_managers values (9, 'Hiroshi', 4);
insert into employee_managers values (10, 'Jeff', 4);
insert into employee_managers values (11, 'Thomas', 1);
insert into employee_managers values (12, 'John', 15);
insert into employee_managers values (13, 'Susan', 15);
insert into employee_managers values (14, 'Lorraine', 15);
insert into employee_managers values (15, 'Larry', 1);

select * from employee_managers;

"id"	"name"	"manager"
1	"Sundar"	
2	"Kent"		1
3	"Ruth"		1
4	"Alison"	1
5	"Clay"		2
6	"Ana"		2
7	"Philipp"	3
8	"Prabhakar"	4
9	"Hiroshi"	4
10	"Jeff"		4
11	"Thomas"	1
12	"John"		15
13	"Susan"		15
14	"Lorraine"	15
15	"Larry"		1


######################### SOLUTION ##############################
with cte as (
select count(*) as emp_count,manager from employee_managers group by manager
)
select e.name,cte.emp_count from employee_managers as e
join cte on cte.manager= e.id order by emp_count desc


##################### SOLUTION 2 ################3

select mng.name as manager, count(emp.name) as employee
from employee_managers emp
join employee_managers mng on emp.manager = mng.id
group by mng.name
order by employee desc;

"manager"	"employee"
"Sundar"	5
"Alison"	3
"Larry"		3
"Kent"		2
"Ruth"		1

