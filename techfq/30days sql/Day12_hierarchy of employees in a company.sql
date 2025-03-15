DROP TABLE IF EXISTS company;
CREATE TABLE company
(
	employee	varchar(10) primary key,
	manager		varchar(10)
);

INSERT INTO company values ('Elon', null);
INSERT INTO company values ('Ira', 'Elon');
INSERT INTO company values ('Bret', 'Elon');
INSERT INTO company values ('Earl', 'Elon');
INSERT INTO company values ('James', 'Ira');
INSERT INTO company values ('Drew', 'Ira');
INSERT INTO company values ('Mark', 'Bret');
INSERT INTO company values ('Phil', 'Mark');
INSERT INTO company values ('Jon', 'Mark');
INSERT INTO company values ('Omid', 'Earl');

SELECT * FROM company;

"employee"	"manager"
"Elon"	
"Ira"		"Elon"
"Bret"		"Elon"
"Earl"		"Elon"
"James"		"Ira"
"Drew"		"Ira"
"Mark"		"Bret"
"Phil"		"Mark"
"Jon"		"Mark"
"Omid"		"Earl"


PROBLEM STATEMENT: 
Given graph shows the hierarchy of employees in a company. 
Write an SQL query to split the hierarchy and show the employees corresponding to their team.

 


EXPECTED OUTPUT:
-----------------------
TEAMS	MEMBERS
Team 1	Elon, Bret, Mark, Phil, Jon
Team 2	Elon, Earl, Omid
Team 3	Elon, Ira, James, Drew



select mng.employee from company root
join company mng on root.employee=mng.manager
where root.manager is null;

"employee"
"Ira"
"Bret"
"Earl"

select mng.employee,concat('Team',row_number() over(order by mng.employee)) 
from company root
join company mng on root.employee=mng.manager
where root.manager is null;

"employee"	"concat"
"Bret"		"Team1"
"Earl"		"Team2"
"Ira"		"Team3"

-- Till this we have used self join.


################ SOLUTION 1 ################################

with recursive cte as(
select b.employee, b.employee as x,a.employee as y from(
select employee from company where manager is null ) a 
join company b on a.employee=b.manager
union all
select
cte.employee, c.employee, y
from cte join company c on cte.x=c.manager
)

select concat("Team",row_number() over()) as TEAMS, 
concat(group_concat(distinct y),",",group_concat(x)) as MEMBERS from cte
group by employee



####################### SOLUTION 2 ########################################
--SELECT * FROM company ;  
with recursive cte as
		(select c.employee, c.manager, t.teams
		 from company c
		 cross join cte_teams t 
		 where c.manager is null
		 union 
		 select c.employee, c.manager
		 /*, case when t.teams is not null then t.teams 
		 		else case when c.manager = cte.employee then cte.teams end 
		   end as teams*/
		 , coalesce(t.teams, cte.teams) as teams 
		 from company c
		 join cte on cte.employee = c.manager
		 left join cte_teams t on t.employee = c.employee
		),
	cte_teams as
		(SELECT mng.employee, concat('Team ', row_number() over(order by mng.employee)) as teams
		FROM company root
		join company mng on root.employee = mng.manager
		where root.manager is null)
select teams, string_agg(employee, ', ') as members
from cte 
group by teams
order by teams



"teams"		"members"
"Team 1"	"Elon, Bret, Mark, Phil, Jon"
"Team 2"	"Elon, Earl, Omid"
"Team 3"	"Elon, Ira, James, Drew"