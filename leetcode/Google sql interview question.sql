Google sql interview question:
--------------------------------------
Find companies who have atleast 2 users who speak english and german both the languages

create table company_users 
(
company_id int,
user_id int,
language varchar(20)
);

insert into company_users values (1,1,'English')
,(1,1,'German')
,(1,2,'English')
,(1,3,'German')
,(1,3,'English')
,(1,4,'English')
,(2,5,'English')
,(2,5,'German')
,(2,5,'Spanish')
,(2,6,'German')
,(2,6,'Spanish')
,(2,7,'English');

"company_id"	"user_id"	"language"
1				1			"English"
1				1			"German"
1				2			"English"
1				3			"German"
1				3			"English"
1				4			"English"
2				5			"English"
2				5			"German"
2				5			"Spanish"
2				6			"German"
2				6			"Spanish"
2				7			"English"


Solution1:
---------------
with language_cte as (
select 
case when language='English' then 1
 when language='German' then 1 else 0 end as flag_language
,language,user_id,company_id
from company_users)

select count(company_id),company_id
from(
select sum(flag_language),user_id,company_id from language_cte group by company_id,user_id
having sum(flag_language) >=2) a
group by company_id
having count(company_id) >=2

"count"	"company_id"
2		1

Solution 2:
------------------
select company_id,count(1) from(
select company_id,user_id,count(1)
from company_users
where language in ('English','German')
group by
company_id,user_id
having count(1)=2)a
group by company_id
having count(1) >=2

"company_id"	"count"
1				2