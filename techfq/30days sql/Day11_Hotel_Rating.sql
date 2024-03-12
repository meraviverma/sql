"PROBLEM STATEMENT: In the given input table, there are hotel ratings which are either too high or too low compared to the standard ratings the hotel receives each year. Write a query to identify and exclude these outlier records as shown in expected output below. 
Your output should follow the same order of records as shown."						
						
						
					

drop table if exists hotel_ratings;
create table hotel_ratings
(
	hotel 		varchar(30),
	year		int,
	rating 		decimal
);
insert into hotel_ratings values('Radisson Blu', 2020, 4.8);
insert into hotel_ratings values('Radisson Blu', 2021, 3.5);
insert into hotel_ratings values('Radisson Blu', 2022, 3.2);
insert into hotel_ratings values('Radisson Blu', 2023, 3.8);
insert into hotel_ratings values('InterContinental', 2020, 4.2);
insert into hotel_ratings values('InterContinental', 2021, 4.5);
insert into hotel_ratings values('InterContinental', 2022, 1.5);
insert into hotel_ratings values('InterContinental', 2023, 3.8);

select * from hotel_ratings;

INPUT
-----------		
HOTEL	YEAR	RATING
Radisson Blu	2020	4.8
Radisson Blu	2021	3.5
Radisson Blu	2022	3.2
Radisson Blu	2023	3.4
InterContinental	2020	4.2
InterContinental	2021	4.5
InterContinental	2022	1.5
InterContinental	2023	3.8


OUTPUT		
HOTEL	YEAR	RATING
Radisson Blu	2021	3.5
Radisson Blu	2022	3.2
Radisson Blu	2023	3.4
InterContinental	2020	4.2
InterContinental	2021	4.5
InterContinental	2023	3.8

Explain:
----------
In this we have removed the rating for 4.8 as it is too high and 1.5 as it is too low.



with cte as (

select *, round(avg(rating) over (partition by hotel order by year 
								range between unbounded preceding and unbounded following ),2 )
as avg_rating from hotel_ratings),

cte_rank as (
select *,abs(rating-avg_rating) as diff,rank() over( partition by hotel order by abs(rating-avg_rating) desc ) 
from cte)

select hotel,year,rating from cte_rank where rank > 1 order by hotel desc,year; 

"hotel"				"year"	"rating"
"Radisson Blu"		2021	3.5
"Radisson Blu"		2022	3.2
"Radisson Blu"		2023	3.8
"InterContinental"	2020	4.2
"InterContinental"	2021	4.5
"InterContinental"	2023	3.8



