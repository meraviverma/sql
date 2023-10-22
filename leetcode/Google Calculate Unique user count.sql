Calculate unique user count for each DAY
----------------------------------------------
https://www.youtube.com/watch?v=HZtUxYdnbhw



create table user_activity(date date,user_id int,activity varchar(50));

insert into user_activity values('2022-02-20',1,'abc');
insert into user_activity values('2022-02-20',2,'xyz');
insert into user_activity values('2022-02-22',1,'xyz');
insert into user_activity values('2022-02-22',3,'klm');
insert into user_activity values('2022-02-24',1,'abc');
insert into user_activity values('2022-02-24',2,'abc');
insert into user_activity values('2022-02-24',3,'abc');

select * from user_activity

"date"			"user_id"	"activity"
"2022-02-20"	1			"abc"
"2022-02-20"	2			"xyz"
"2022-02-22"	1			"xyz"
"2022-02-22"	3			"klm"
"2022-02-24"	1			"abc"
"2022-02-24"	2			"abc"
"2022-02-24"	3			"abc"







-----------------------------------------------------------------------------------------

select u.date,count(distinct x.user_id) unique_user_count from
(select user_id,min(date) date from user_activity group by user_id) x
right join user_activity u on u.date=x.date
group by u.date

SELECT date, SUM(CASE WHEN rn = 1 THEN 1 else 0 END) unique_user_count
FROM(
SELECT *, ROW_NUMBER() OVER(partition by user_id order by date) rn
FROM user_activity)x
GROUP BY date


select min_date, count(user_id) from (select MIN(date) min_date, user_id from user_activity group by user_id) tb group by min_date


select 
        a.activity_date
       ,coalesce(b.new_user_count,0) as new_user_count
  from 
        (select distinct activity_date from user_activity)  a

  left  join 
        (select  activity_date
                ,count(distinct user_id) as new_user_count
	   from 
                 user_activity a
          where 
                 user_id not in ( select user_id from user_activity b where b.activity_date < a.activity_date)
          group  by 
                 activity_date
	) b
        on a.activity_date = b.activity_date
 order  by
        activity_date
		

select a.date,
sum(case when b.date is Null then 1 else 0 end) as unique_user_count 
from user_activity a left join user_activity b 
on a.date > b.date and a.user_id = b.user_id 
group by 1
order by 1;

SELECT 
  date, 
  COUNTIF(rank_ = 1) AS unique_user_count 
FROM (
      SELECT *,
        RANK() OVER(PARTITION BY user_id ORDER BY date) AS rank_
      FROM `big-query.user_activity` 
      ) 
GROUP BY date

with user_login as(
	select * 
	from user_activity
	group by user_id
)
select ua.date,
	case
		when ul.date is NULL then 0
		else ul.unique_user_id
		end as unique_user_count
from(select distinct(date)
	from user_activity) as ua
left join(select date, count(*) as unique_user_id from user_login group by date) as ul
on ua.date = ul.date;

with user_log as (
  select min(tra_dt) as tra_dt,
 user_id
from user_act
group by user_id
                 )
                 
select distinct(a.tra_dt),coalesce(b.user_id,0) from user_act a
left join (select tra_dt,count(user_id ) as user_id
           from user_log group by tra_dt) b
           on a.tra_dt=b.tra_dt



with user_details as
(
select user_id,min(activity_date) as activity_date
from 
user_activity
group by user_id
)


select 
u1.activity_date,
sum(case when u2.user_id is null then 0 else 1 end) as unique_user_count
from
user_activity u1
left join
user_details u2
on 
u1.activity_date = u2.activity_date
group by u1.activity_date


		   



