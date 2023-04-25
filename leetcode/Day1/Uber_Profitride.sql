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


