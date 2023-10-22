-- Given below candidates data:
-- | emp_id | experience | salary |
--| 1 | Junior | 10000 |
-- | 2 | Junior | 15000 |
-- | 3 | Junior | 40000 |
-- | 4 | Senior | 16000 |
-- | 5 | Senior | 20000 |
-- | 6 | Senior | 50000 |

-- ❓Hire the candidates who fall under budget of 70000 according to below criteria:
-- 📌 First hire Senior within budget
-- 📌 Then hire Junior withing remaining budget.

--they have to first fill up the senior position then fill up the junior position
-- we will start from senior having least salary as we want to hire maximum person.


Create table candidates(
id int primary key,
positions varchar(10) not null,
salary int not null);

insert into candidates values(1,'junior',5000);
insert into candidates values(2,'junior',7000);
insert into candidates values(3,'junior',7000);
insert into candidates values(4,'senior',10000);
insert into candidates values(5,'senior',30000);
insert into candidates values(6,'senior',20000);

test case 2:
insert into candidates values(20,'junior',10000);
insert into candidates values(30,'senior',15000);
insert into candidates values(40,'senior',30000);

test case 3:
insert into candidates values(1,'junior',15000);
insert into candidates values(2,'junior',15000);
insert into candidates values(3,'junior',20000);
insert into candidates values(4,'senior',60000);

test case 4:
insert into candidates values(10,'junior',10000);
insert into candidates values(40,'junior',10000);
insert into candidates values(20,'senior',15000);
insert into candidates values(30,'senior',30000);
insert into candidates values(50,'senior',15000);


select * from candidates

id	positions	salary
1	junior		5000
2	junior		7000
3	junior		7000
4	senior		10000
5	senior		30000
6	senior		20000

select *,sum(salary) over(partition by positions order by salary asc) as running_salary from candidates

id	positions	salary	running_salary
1	junior		5000	5000
2	junior		7000	19000 //For running salary when there is duplicate it will worng it will give 19000
3	junior		7000	19000
4	senior		10000	10000
6	senior		20000	30000
5	senior		30000	60000


with cte_running_sum as(
select *,sum(salary) over(partition by positions order by salary asc,id) as running_salary from candidates
)

--For running salary when there is duplicate it will worng it will give 19000
select * from cte_running_sum where positions ='senior' and running_salary < 50000

id	positions	salary	running_salary
4	senior	10000	10000
6	senior	20000	30000

------------------------------------------------------------------------------
with cte_running_sum as(
select *,sum(salary) over(partition by positions order by salary asc,id) as running_salary from candidates
),
seniors_cte as(
select * from cte_running_sum where positions ='senior' and running_salary < 50000)

select * from cte_running_sum where positions ='junior' and running_salary < 50000-(select max(running_salary) from seniors_cte )
UNION ALL
select * from seniors_cte

id	positions	salary	running_salary
1	junior		5000	5000
2	junior		7000	12000
3	junior		7000	19000
4	senior		10000	10000
6	senior		20000	30000

--------------------------------------------------------------------
with cte_running_sum as(
select *,sum(salary) over(partition by positions order by salary asc,id) as running_salary from candidates
),
seniors_cte as(
select count(*) as seniors,sum(salary) as s_sal from cte_running_sum where positions ='senior' and running_salary < 50000),
juniors_cte as(
select count(*) as juniors from cte_running_sum where positions ='junior' 
and running_salary < 50000-(select s_sal from seniors_cte )
)

select seniors,juniors from seniors_cte,juniors_cte

seniors	juniors
2		3

------------------SOLUTION 1 -----------------------------------------------

# to fix null thing use coalesce


with cte_running_sum as(
select *,sum(salary) over(partition by positions order by salary asc,id) as running_salary from candidates
),
seniors_cte as(
select count(*) as seniors,coalesce(sum(salary),0) as s_sal from cte_running_sum where positions ='senior' and running_salary < 50000),
juniors_cte as(
select count(*) as juniors from cte_running_sum where positions ='junior' 
and running_salary < 50000-(select s_sal from seniors_cte )
)

select seniors,juniors from seniors_cte,juniors_cte

---------------------- SOLUTION 2 --------------------------------------------
with cte_running_sum as(
select *,sum(salary) over(partition by positions order by salary asc,id) as running_salary from candidates
),
seniors_cte as(
select * from cte_running_sum where positions ='senior' and running_salary < 50000)

select * from cte_running_sum where positions ='junior' and running_salary < 50000-(select coalesce(max(running_salary),0) from seniors_cte )
UNION ALL
select * from seniors_cte
