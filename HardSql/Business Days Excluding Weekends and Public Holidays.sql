Given below #Jira ticket data and holiday data:
| ticket_id | create_date | resolved_date |
| 1 | 2022-08-01 | 2022-08-03 |
| 2 | 2022-08-01 | 2022-08-12 |
| 3 | 2022-08-01 | 2022-08-16 |

| holiday_date |
| 2022-08-11 |
| 2022-08-15 |

❓Find out the total working days between ticket creation and resolution dates.

Notes: Exclude weekend i.e saturday and sunday

create table tickets
(
ticket_id varchar(10),
create_date date,
resolved_date date
);

insert into tickets values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');

select * from tickets;

create table holidays
(
holiday_date date
,reason varchar(100)
);

insert into holidays values
('2022-08-11','Rakhi'),('2022-08-15','Independence day');

select * from holidays;

holiday_date	reason
2022-08-11		Rakhi
2022-08-15		Independence day


select * from tickets;

ticket_id	create_date	resolved_date
1			2022-08-01	2022-08-03
2			2022-08-01	2022-08-12
3			2022-08-01	2022-08-16

select 
datediff(day,create_date,resolved_date) as actual_days ,
datepart(week,create_date) as create_date_week,--Calcuates week number from the starting of the year
datepart(week,resolved_date) as resolved_date_week,
datediff(week,create_date,resolved_date) as actual_days, --Difference in number of weekends
datediff(day,create_date,resolved_date) - 2*datediff(week,create_date,resolved_date) as excluded_weekend_days
from tickets;

--If week diiference is one it means there will be two weekends.
--If week difference is 2 then will subtract as 4 as there will be 4 weekends.

actual_days	create_date_week	resolved_date_week	actual_days	excluded_weekend_days
2			32					32					0			2
11			32					33					1			9
15			32					34					2			11


select *
from tickets
left join holidays on holiday_date between create_date and resolved_date

ticket_id	create_date	resolved_date	holiday_date	reason
1			2022-08-01	2022-08-03		NULL			NULL
2			2022-08-01	2022-08-12		2022-08-11		Rakhi
3			2022-08-01	2022-08-16		2022-08-11		Rakhi
3			2022-08-01	2022-08-16		2022-08-15		Independence day

select ticket_id,create_date,resolved_date,COUNT(holiday_date) as no_of_holiday
from tickets
left join holidays on holiday_date between create_date and resolved_date
group by ticket_id,create_date,resolved_date

ticket_id	create_date	resolved_date	no_of_holiday
1			2022-08-01	2022-08-03		0
2			2022-08-01	2022-08-12		1
3			2022-08-01	2022-08-16		2


----------------- FINAL SOLUTION ----------------
select 
create_date,resolved_date,datediff(day,create_date,resolved_date) as actual_days ,
datediff(day,create_date,resolved_date) - 2*datediff(week,create_date,resolved_date) - no_of_holiday as actual_ticket_close_day
from(
select ticket_id,create_date,resolved_date,COUNT(holiday_date) as no_of_holiday
from tickets
left join holidays on holiday_date between create_date and resolved_date
group by ticket_id,create_date,resolved_date)
a

---------------------------------------

create_date	resolved_date	actual_days	actual_ticket_close_day
2022-08-01	2022-08-03		2			2
2022-08-01	2022-08-12		11			8
2022-08-01	2022-08-16		15			9

Q) Suppose some holiday falls on weekend then how to resolve it.

select *,
DATEDIFF(day,create_date, resolved_date)  - 2*DATEDIFF(week,create_date, resolved_date) - holiday as bdays
from
(select t.*, count(holiday_date) as holiday
from tickets t
left join holidays h on h.holiday_date between t.create_date and t.resolved_date and
DATEPART(weekday, holiday_date) not in (1,7)
group by ticket_id, create_date, resolved_date) A

--------- ANother SOLUTION -------------------
with cte as (
select *
from tickets left join holidays on holiday_date between create_date and resolved_date and 
(datename(weekday,holiday_date) <> 'Saturday' and datename(weekday,holiday_date) <> 'Sunday')
)
select ticket_id,create_date,resolved_date,
datediff(day,create_date,resolved_date) - 2*(datediff(week,create_date,resolved_date)) - count(holiday_date) actual_biz_days
from cte
group by ticket_id,create_date,resolved_date;



ticket_id	create_date	resolved_date	actual_biz_days
1			2022-08-01	2022-08-03		2
2			2022-08-01	2022-08-12		8
3			2022-08-01	2022-08-16		9


IMPORTANT NOTE:
-------------------------------------------------------
1. When counting no. of days between 2 dates we should always add ONE(+1) otherwise we miss a day DATEDIFF(DAY, start_date, end_date) +1.
Also, there might be cases where we dont want to add(+1). So, based on our business needs

For example: in the above scenario ('2022-08-01','2022-08-03') --> it should be 3 days and not 2

2. There is a corner case with the above code - this solution would work only when tickets are created on weekdays and not weekends. 
Ideally, as per business case, we should not have a ticket created on weekend but (we all know the kind of data we get is never 100% clean :P)

 Example: Below 2 scenarios will give incorrect results

,(4,'2022-08-19','2022-08-27')
,(5,'2022-08-21','2022-08-27');


----------- solution ---------------------
with  _cte as
(
select ticket_id, create_date, resolved_date from tickets 
UNION ALL
SELECT t.ticket_id, DATEADD(DAY, 1,b.create_date) create_date, T.resolved_date FROM tickets T
inner join _cte b on b.ticket_id = t.ticket_id
where b.create_date < T.resolved_date
)

--select * from _cte
,
_CTE2 AS(
select C.*
, CASE WHEN DATEPART(WEEKDAY, create_date) IN (1,7) then 1 ELSE 0 END AS BusinessHoliday
,CASE WHEN H.holiday_date IS NOT NULL THEN 1 ELSE 0 END AS FirmHoliday
from _cte C LEFT JOIN holidays H
	ON C.create_date = H.holiday_date
)
SELECT ticket_id, MIN(CREATE_DATE) as CREATE_DATE, MAX(CREATE_DATE) as resolve_date, COUNT(1) AS TotalDays,  
sum(BusinessHoliday) BusinessHolidays, sum(FirmHoliday) FirmHolidays
, COUNT(1) - sum(BusinessHoliday) - sum(FirmHoliday) as TotalBusinessDays

FROM _CTE2
group by ticket_id
order by 1

ticket_id	CREATE_DATE	resolve_date	TotalDays	BusinessHolidays	FirmHolidays	TotalBusinessDays
1			2022-08-01	2022-08-03		3			0					0				3
2			2022-08-01	2022-08-12		12			2					1				9
3			2022-08-01	2022-08-16		16			4					2				10




Exaplain:
------------
with  _cte as
(
select ticket_id, create_date, resolved_date from tickets 
UNION ALL
SELECT t.ticket_id, DATEADD(DAY, 1,b.create_date) create_date, T.resolved_date FROM tickets T
inner join _cte b on b.ticket_id = t.ticket_id
where b.create_date < T.resolved_date
)

select * from _cte


ticket_id	create_date	resolved_date
1	2022-08-01	2022-08-03
2	2022-08-01	2022-08-12
3	2022-08-01	2022-08-16
3	2022-08-02	2022-08-16
3	2022-08-03	2022-08-16
3	2022-08-04	2022-08-16
3	2022-08-05	2022-08-16
3	2022-08-06	2022-08-16
3	2022-08-07	2022-08-16
3	2022-08-08	2022-08-16
3	2022-08-09	2022-08-16
3	2022-08-10	2022-08-16
3	2022-08-11	2022-08-16
3	2022-08-12	2022-08-16
3	2022-08-13	2022-08-16
3	2022-08-14	2022-08-16
3	2022-08-15	2022-08-16
3	2022-08-16	2022-08-16
2	2022-08-02	2022-08-12
2	2022-08-03	2022-08-12
2	2022-08-04	2022-08-12
2	2022-08-05	2022-08-12
2	2022-08-06	2022-08-12
2	2022-08-07	2022-08-12
2	2022-08-08	2022-08-12
2	2022-08-09	2022-08-12
2	2022-08-10	2022-08-12
2	2022-08-11	2022-08-12
2	2022-08-12	2022-08-12
1	2022-08-02	2022-08-03
1	2022-08-03	2022-08-03



--------------------- Now one more question on this one---------------
suppose I have ticket table like this.

select * from tickets;

ticket_id	create_date	resolved_date
1			2022-08-01	2022-08-03
2			2022-08-01	2022-08-12
3			2022-08-01	2022-08-16

I want output something like this

ticket_id	create_date	resolved_date
1			2022-08-01	2022-08-03
1			2022-08-02	2022-08-03
1			2022-08-03	2022-08-03
2			2022-08-01	2022-08-12
2			2022-08-02	2022-08-12
2			2022-08-03	2022-08-12
2			2022-08-04	2022-08-12
2			2022-08-05	2022-08-12
.
.
.
.
.
3			2022-08-01	2022-08-16

select ticket_id,create_date,resolved_date from tickets
union all
select ticket_id,DATEADD(DAY,1,create_date),resolved_date from tickets order by ticket_id

ticket_id	create_date	resolved_date
1	2022-08-01	2022-08-03
1	2022-08-02	2022-08-03
2	2022-08-02	2022-08-12
2	2022-08-01	2022-08-12
3	2022-08-01	2022-08-16
3	2022-08-02	2022-08-16

-- This will add one TIME


with  _cte as
(
select ticket_id, create_date, resolved_date from tickets 
UNION ALL
SELECT t.ticket_id, DATEADD(DAY, 1,b.create_date) create_date, T.resolved_date FROM tickets T
inner join _cte b on b.ticket_id = t.ticket_id
where b.create_date < T.resolved_date
)

select * from _cte order by ticket_id


ticket_id	create_date	resolved_date
1	2022-08-01	2022-08-03
1	2022-08-02	2022-08-03
1	2022-08-03	2022-08-03
2	2022-08-02	2022-08-12
2	2022-08-03	2022-08-12
2	2022-08-04	2022-08-12
2	2022-08-05	2022-08-12
2	2022-08-06	2022-08-12
2	2022-08-07	2022-08-12
2	2022-08-08	2022-08-12
2	2022-08-09	2022-08-12
2	2022-08-10	2022-08-12
2	2022-08-11	2022-08-12
2	2022-08-12	2022-08-12
2	2022-08-01	2022-08-12
3	2022-08-01	2022-08-16
3	2022-08-02	2022-08-16
3	2022-08-03	2022-08-16
3	2022-08-04	2022-08-16
3	2022-08-05	2022-08-16
3	2022-08-06	2022-08-16
3	2022-08-07	2022-08-16
3	2022-08-08	2022-08-16
3	2022-08-09	2022-08-16
3	2022-08-10	2022-08-16
3	2022-08-11	2022-08-16
3	2022-08-12	2022-08-16
3	2022-08-13	2022-08-16
3	2022-08-14	2022-08-16
3	2022-08-15	2022-08-16
3	2022-08-16	2022-08-16

--------------------------------------- PYSPARK SOLUTION ---------------------------------------------
# Databricks notebook source
# Given below #Jira ticket data and holiday data:
# | ticket_id | create_date | resolved_date |
# | 1 | 2022-08-01 | 2022-08-03 |
# | 2 | 2022-08-01 | 2022-08-12 |
# | 3 | 2022-08-01 | 2022-08-16 |

# | holiday_date |
# | 2022-08-11 |
# | 2022-08-15 |

# ❓Find out the total working days between ticket creation and resolution dates.

# Notes: Exclude weekend i.e saturday and sunday

# COMMAND ----------

from datetime import datetime

# COMMAND ----------

from pyspark.sql.types import StructType,StructField,IntegerType,StringType,DateType

# COMMAND ----------

my_schema=StructType(
    [
        StructField("ticket_id",IntegerType(),True),
        StructField("create_date",DateType(),True),
        StructField("resolved_date",DateType(),True)
    ]
)

# COMMAND ----------

mydata=[(1,datetime.strptime('2022-08-01','%Y-%m-%d'),datetime.strptime('2022-08-03','%Y-%m-%d')),
        (2,datetime.strptime('2022-08-01','%Y-%m-%d'),datetime.strptime('2022-08-12','%Y-%m-%d')),
        (3,datetime.strptime('2022-08-01','%Y-%m-%d'),datetime.strptime('2022-08-16','%Y-%m-%d'))]

# COMMAND ----------

tickets=spark.createDataFrame(data=mydata,schema=my_schema)

# COMMAND ----------

display(tickets)

# COMMAND ----------

holiday_schema=StructType([
    StructField("holiday_date",DateType(),True),
    StructField("reason",StringType(),True)
])

# COMMAND ----------

holiday_data=[(datetime.strptime('2022-08-11','%Y-%m-%d'),"Rakhi"),(datetime.strptime('2022-08-15','%Y-%m-%d'),"Independence Day")]

# COMMAND ----------

holidays=spark.createDataFrame(data=holiday_data,schema=holiday_schema)

# COMMAND ----------

display(holidays)

# COMMAND ----------

display(tickets)

# COMMAND ----------

from pyspark.sql.functions import datediff,date_part,lit,floor,col,count

# COMMAND ----------

#Between one week difference there will be two weekends so we are doing minus with 2*difference in days
tickets.select(tickets.create_date,
               tickets.resolved_date,
               datediff(tickets.resolved_date,tickets.create_date).alias("actual_days"),
               date_part(lit('week'),tickets.create_date).alias("create_date_week"),
               date_part(lit('week'),tickets.resolved_date).alias("resolved_date_week"),
               floor((datediff(tickets.resolved_date,tickets.create_date)/7)).alias("week_difference"),
               (datediff(tickets.resolved_date,tickets.create_date) - 2*(floor((datediff(tickets.resolved_date,tickets.create_date)/7)))).alias("excluded_weekend_days")).show()

# COMMAND ----------

from pyspark.sql.window import Window

# COMMAND ----------

joined_data=tickets.join(holidays,(tickets.create_date < holidays.holiday_date) & (holidays.holiday_date < tickets.resolved_date),"LEFT")
#joined_data.withColumn("count_holiday_day",count("holiday_date").over(Window.partitionBy(*["ticket_id","create_date","resolved_date"]))).select(col("count_holiday_day")).show()
#joined_data.select(count("holiday_date").over(Window.partitionBy(*["ticket_id","create_date","resolved_date"])).alias("count_holiday_day")).show()
joined_data=joined_data.groupBy("ticket_id","create_date","resolved_date").agg(count('holiday_date').alias("count_holiday_day"))

# COMMAND ----------

display(joined_data)

# COMMAND ----------

joined_data.select(joined_data.ticket_id,
                   joined_data.create_date,
               joined_data.resolved_date,
               datediff(joined_data.resolved_date,joined_data.create_date).alias("actual_days"),
               ((datediff(tickets.resolved_date,tickets.create_date) - 2*(floor((datediff(tickets.resolved_date,tickets.create_date)/7)))) - col("count_holiday_day")).alias("actual_ticket_close_day")).show()

# COMMAND ----------




