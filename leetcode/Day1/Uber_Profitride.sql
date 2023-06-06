https://www.linkedin.com/posts/ankitbansal6_sql-interview-uber-activity-7051406885186404353-Ibja/


Write a query to find total rides and profit rides by each driver. 

Profit ride is when the end location of the current ride is the same as the start location of the next ride.

It is not necessary that the end time of the current ride should be the same as the start time of the next ride to qualify as a profit ride.

Bonus point if you solve it without using lead and lag functions.

script :

create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));

insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');

id		start_time	end_time	start_loc	end_loc
dri_1	09:00:00	09:30:00	a			b
dri_1	09:30:00	10:30:00	b			c
dri_1	11:00:00	11:30:00	d			e
dri_1	12:00:00	12:30:00	f			g
dri_1	13:30:00	14:30:00	c			h
dri_2	12:15:00	12:30:00	f			g
dri_2	13:30:00	14:30:00	c			h

-----------------------------------------------------------------------------------
WITH cte AS(
SELECT *,ROW_NUMBER() OVER (PARTITION BY id ORDER BY start_time) AS num FROM drivers
)
SELECT
DISTINCT c1.id,
COUNT(c1.id) OVER (PARTITION BY c1.id) AS total_rides,
COUNT(c2.end_loc) OVER (PARTITION BY c1.id) AS profitable_rides
FROM cte AS c1
LEFT JOIN cte AS c2
ON c1.id = c2.id
AND c1.end_loc = c2.start_loc
AND c1.num = c2.num-1


id		total_rides	profitable_rides
dri_1	5			1
dri_2	2			0




1] Using LAG / LEAD

WITH prev_loc AS (
SELECT *,
 LAG(end_loc) OVER(Partition by id order by start_time asc) as prev_end_loc
 FROM 
 Drivers
 )
  
SELECT 
id, 
COUNT(id) as total_rides,
SUM(CASE WHEN prev_end_loc = start_loc THEN 1 ELSE 0 END) AS profit_rides
FROM 
prev_loc
  GROUP BY 1


2] Without Using LAG / LEAD

WITH profit_rides AS (
SELECT 
distinct drivers1.id
 as profit_rider,
drivers1.end_time 
FROM Drivers as drivers1
 INNER JOIN 
 Drivers as drivers2
 ON (drivers1.id
 = drivers2.id
 and drivers1.end_loc = drivers2.start_loc)
 )

 SELECT 
  id,
  COUNT(*) as total_rides,
  COUNT(profit.profit_rider) / 2 as profit_rides
  FROM drivers drive
  LEFT JOIN 
  Profit_rides profit
  ON (profit.profit_rider = drive.id
 and profit.end_time = drive.end_time)
  GROUP BY 1
  
  
----------------------------------------------------------------
WITH CTE AS (
SELECT id,COUNT(1) as total_rides from drivers
group by id),
CTE2 as (
SELECT COUNT(1) AS Profit_rides,id FROM (SELECT id,start_loc,end_loc,lag(end_loc) 
over (order by id) as LAST_LOC
from drivers)abc
where start_loc=LAST_LOC
group by id)
SELECT CTE.id
,CTE.total_rides,ISNULL(CTE2.Profit_rides,0) AS Profit_rides FROM CTE left join CTE2 ON 
CTE.id
=CTE2.id


---------------------------------------------------------
with cte as (select *, rank() over (partition by id order by end_time) as r from drivers), cte2 as (select a.id
, count(1) as profit_rides from cte a inner join cte b on a.id
 = b.id
 and a.end_loc = b.start_loc and a.r+1 = b.r group by a.id
), cte3 as (select id, count(*) as total_rides from drivers group by id) (select cte3.id
, total_rides, if(profit_rides is NULL, 0, profit_rides) as profit_rides from cte3 left join cte2 on cte3.id
 = cte2.id
);


------------------------------------
with profit_rides as (
select d1.id
 as id, count(*)/2 as profit_rides from 
dbo.drivers d1 join dbo.drivers d2
on d1.id
 = d2.id
 and d1.start_loc = d2.end_loc
group by d1.id
),

total_rides as(
select id, count(*) as total_rides
from dbo.drivers
group by id)

select total_rides.id
, total_rides, ISNULL(profit_rides,0) as profit_rides
from total_rides left join profit_rides
on profit_rides.id
 = total_rides.id



-----------------------------------------------------------------------------
with cte as (
select *,row_number() over (partition by id order by start_time) as num
from drivers
)  
select 
distinct c1.id
,
count(c1.id
) over (partition by c1.id
) as total_rides,
count(c2.end_loc) over (partition by c1.id
) as profitable_rides
from cte as c1
left join cte as c2
on c1.id
 = c2.id
 and c1.end_loc = c2.start_loc
and c1.num = c2.num-1

