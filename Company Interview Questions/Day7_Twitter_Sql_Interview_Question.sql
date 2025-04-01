📌 Write a query to calculate the 3-day rolling average of tweets for each user in the tweets table and output the user ID, tweet date, and rolling averages rounded to 2 decimal places. 

CREATE TABLE Tweets (
 user_id INT,
 tweet_date DATE,
 tweet_count INT
);

INSERT INTO Tweets (user_id, tweet_date, tweet_count) VALUES
(101, '2022-01-01 00:00:00', 5), (102, '2022-01-01 00:00:00', 10),
(103, '2022-01-01 00:00:00', 15), (101, '2022-01-02 00:00:00', 7),
(102, '2022-01-02 00:00:00', 12), (103, '2022-01-02 00:00:00', 18),
(101, '2022-01-03 00:00:00', 6), (102, '2022-01-03 00:00:00', 13),
(103, '2022-01-03 00:00:00', 16), (101, '2022-01-04 00:00:00', 8),
(102, '2022-01-04 00:00:00', 9), (103, '2022-01-04 00:00:00', 20),
(101, '2022-01-05 00:00:00', 11), (102, '2022-01-05 00:00:00', 10),
(103, '2022-01-05 00:00:00', 12), (101, '2022-01-06 00:00:00', 7),
(102, '2022-01-06 00:00:00', 16), (103, '2022-01-06 00:00:00', 14),
(101, '2022-01-07 00:00:00', 9), (102, '2022-01-07 00:00:00', 12),
(103, '2022-01-07 00:00:00', 10), (111, '2022-01-31 00:00:00', 4),
(222, '2022-01-31 00:00:00', 8), (333, '2022-01-31 00:00:00', 12),
(444, '2022-02-01 00:00:00', 3), (555, '2022-02-01 00:00:00', 7),
(666, '2022-02-01 00:00:00', 11), (777, '2022-02-02 00:00:00', 6),
(888, '2022-02-02 00:00:00', 9), (999, '2022-02-02 00:00:00', 13),
(111, '2022-02-03 00:00:00', 5);

𝐀𝐩𝐩𝐫𝐨𝐚𝐜𝐡:

𝐒𝐞𝐥𝐞𝐜𝐭 𝐮𝐬𝐞𝐫_𝐢𝐝 𝐚𝐧𝐝 𝐟𝐨𝐫𝐦𝐚𝐭 𝐭𝐰𝐞𝐞𝐭_𝐝𝐚𝐭𝐞:
𝐀. Ensures user_id is retrieved and tweet_date is converted to a proper date format.
𝐁. Use 𝐂𝐀𝐒𝐓() on tweet_date to change datatype from datetime to date

𝐂𝐚𝐥𝐜𝐮𝐥𝐚𝐭𝐞 𝐭𝐡𝐞 𝟑-𝐝𝐚𝐲 𝐫𝐨𝐥𝐥𝐢𝐧𝐠 𝐚𝐯𝐞𝐫𝐚𝐠𝐞:
𝐀. Use 𝐀𝐕𝐆() to compute the moving average.
𝐁. Use 𝐏𝐀𝐑𝐓𝐈𝐓𝐈𝐎𝐍 𝐁𝐘 to calculate based on each user
𝐂. 𝐑𝐎𝐖𝐒 𝐁𝐄𝐓𝐖𝐄𝐄𝐍 𝟐 𝐏𝐑𝐄𝐂𝐄𝐃𝐈𝐍𝐆 𝐀𝐍𝐃 𝐂𝐔𝐑𝐑𝐄𝐍𝐓 𝐑𝐎𝐖 applying for three-day rolling average, i.e. Current row and two days before the current row
𝐃. Round average to two decimal places


select * from tweets;

select user_id,
cast(tweet_date as date) as tweet_date,
round((
avg(cast(tweet_count as float))
over(partition by user_id
order by tweet_date
rows between 2 preceding and current row))::Decimal,2
) as three_days_rolling_avg
from tweets;

user_id tweet_date	three_days_rolling_avg
101	"2022-01-01"	5.00
101	"2022-01-02"	6.00
101	"2022-01-03"	6.00
101	"2022-01-04"	7.00
101	"2022-01-05"	8.33
101	"2022-01-06"	8.67
101	"2022-01-07"	9.00
102	"2022-01-01"	10.00
102	"2022-01-02"	11.00
102	"2022-01-03"	11.67
102	"2022-01-04"	11.33
102	"2022-01-05"	10.67
102	"2022-01-06"	11.67
102	"2022-01-07"	12.67
103	"2022-01-01"	15.00
103	"2022-01-02"	16.50
103	"2022-01-03"	16.33
103	"2022-01-04"	18.00
103	"2022-01-05"	16.00
103	"2022-01-06"	15.33
103	"2022-01-07"	12.00
111	"2022-01-31"	4.00
111	"2022-02-03"	4.50
222	"2022-01-31"	8.00
333	"2022-01-31"	12.00
444	"2022-02-01"	3.00
555	"2022-02-01"	7.00
666	"2022-02-01"	11.00
777	"2022-02-02"	6.00
888	"2022-02-02"	9.00
999	"2022-02-02"	13.00