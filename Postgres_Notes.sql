datediff(day,create_date,resolved_date) 
datepart(week,create_date)
DATEPART(weekday, holiday_date)

Postgres doesn’t support the DATEDIFF function. Alternatively, the “-” operator, DATE_PART(), EXTRACT(), and AGE() functions can be used in PostgreSQL to calculate the difference between various DateTime values. 

DATE_PART()
EXTRACT()
AGE()

--------------------------
SELECT ((EXTRACT('Day' FROM '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP) * 24 + 
EXTRACT('Hour' FROM '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP)) * 60
+ EXTRACT('Minute' FROM '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP))*
60 + EXTRACT('Second' FROM '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP)
sec_diff;

SELECT 
((DATE_PART('Day', '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP) * 24 +
DATE_PART('Hour', '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP)) * 60 +
DATE_PART('Minute', '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP)) * 60
+ DATE_PART('Second', '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP)
AS sec_diff;

select extract(epoch from(next_swipe_time - swipe)) as diff from cte
where flag='I' and next_swipe_flag='O'

SELECT
DATE_PART('YEAR', '2023-01-01' :: DATE) - 
DATE_PART('YEAR', '2019-06-01' :: DATE) AS year_diff;


Example: Calculating the Date Difference in Months


SELECT 
(DATE_PART('YEAR', '2023-01-01' :: DATE) - 
DATE_PART('YEAR', '2020-04-01' :: DATE)) * 12
+ (DATE_PART('Month', '2023-01-01' :: DATE) - 
DATE_PART('Month', '2020-04-01' :: DATE)) AS month_diff;



Date Difference in Days

DATE_PART('Day', end_date - start_date);

SELECT
DATE_PART('Day', '2023-02-01'::TIMESTAMP - '2023-01-10'::TIMESTAMP) AS day_diff;


Date Difference in Weeks

-----------------------------------
SELECT
TRUNC(DATE_PART('Day', '2023-02-01'::TIMESTAMP - '2023-01-10'::TIMESTAMP)/7) AS week_diff;


Date Difference in Hours

-------------------------------------
SELECT
DATE_PART('Day', '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP) * 24
+ (DATE_PART('Hour', '2023-01-03 04:10:00'::TIMESTAMP) - 
DATE_PART('Hour', '2023-01-02 03:15:00'::TIMESTAMP)) AS hour_diff;


Date Difference in Minutes


---------------------------------

(DATE_PART('Day', end_date - start_date)) * 24 + 
(DATE_PART('Hour', end_date start_date)) * 60 +
(DATE_PART('Minute', end_date - start_date));



Let’s put this concept into practice.

Example: Calculating Date Difference in Minutes

In this example, the DATE_PART() function is applied on two different TIMESTAMPS to find the data difference in minutes:

SELECT 
((DATE_PART('Day', '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP) * 24 +
DATE_PART('Hour', '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP)) * 60 +
DATE_PART('Minute', '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP));
img
The difference between the given TIMESTAMPS is “1495” minutes.

Date Difference in Seconds
------------------------------------

(DATE_PART('Day', end_date - start_date)) * 24 + 
(DATE_PART('Hour', end_date) - DATE_PART('Hour', start_date)) * 60 +
(DATE_PART('Minute', end_date - start_date)) *60 +
DATE_PART('Second', end_date - start_date);


SELECT 
((DATE_PART('Day', '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP) * 24 +
DATE_PART('Hour', '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP)) * 60 +
DATE_PART('Minute', '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP)) * 60
+ DATE_PART('Second', '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP)
AS sec_diff;


How to Find DateTime Difference in Postgres Via the EXTRACT() Function?
-------------------------------------------------------------------------------
SELECT ((EXTRACT('Day' FROM '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP) * 24 + 
EXTRACT('Hour' FROM '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP)) * 60
+ EXTRACT('Minute' FROM '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP))*
60 + EXTRACT('Second' FROM '2023-01-03 04:10:00'::TIMESTAMP - '2023-01-02 03:15:00'::TIMESTAMP)
sec_diff;






