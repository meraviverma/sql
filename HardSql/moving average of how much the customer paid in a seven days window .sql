🤔Problem statement

You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).

Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.

--------------------------------------------------------------------------------------------------
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| visited_on    | date    |
| amount        | int     |
+---------------+---------+
In SQL,(customer_id, visited_on) is the primary key for this table.
This table contains data about customer transactions in a restaurant.
visited_on is the date on which the customer with ID (customer_id) has visited the restaurant.
amount is the total paid by a customer.
 

You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).

Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.

Return the result table ordered by visited_on in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Customer table:
+-------------+--------------+--------------+-------------+
| customer_id | name         | visited_on   | amount      |
+-------------+--------------+--------------+-------------+
| 1           | Jhon         | 2019-01-01   | 100         |
| 2           | Daniel       | 2019-01-02   | 110         |
| 3           | Jade         | 2019-01-03   | 120         |
| 4           | Khaled       | 2019-01-04   | 130         |
| 5           | Winston      | 2019-01-05   | 110         | 
| 6           | Elvis        | 2019-01-06   | 140         | 
| 7           | Anna         | 2019-01-07   | 150         |
| 8           | Maria        | 2019-01-08   | 80          |
| 9           | Jaze         | 2019-01-09   | 110         | 
| 1           | Jhon         | 2019-01-10   | 130         | 
| 3           | Jade         | 2019-01-10   | 150         | 
+-------------+--------------+--------------+-------------+
Output: 
+--------------+--------------+----------------+
| visited_on   | amount       | average_amount |
+--------------+--------------+----------------+
| 2019-01-07   | 860          | 122.86         |
| 2019-01-08   | 840          | 120            |
| 2019-01-09   | 840          | 120            |
| 2019-01-10   | 1000         | 142.86         |
+--------------+--------------+----------------+
Explanation: 
1st moving average from 2019-01-01 to 2019-01-07 has an average_amount of (100 + 110 + 120 + 130 + 110 + 140 + 150)/7 = 122.86
2nd moving average from 2019-01-02 to 2019-01-08 has an average_amount of (110 + 120 + 130 + 110 + 140 + 150 + 80)/7 = 120
3rd moving average from 2019-01-03 to 2019-01-09 has an average_amount of (120 + 130 + 110 + 140 + 150 + 80 + 110)/7 = 120
4th moving average from 2019-01-04 to 2019-01-10 has an average_amount of (130 + 110 + 140 + 150 + 80 + 110 + 130 + 150)/7 = 142.86

------------------------------------------------------------------------------------------
CREATE TABLE customer 
(
    customer_id	INT,
    name	VARCHAR(512),
    visited_on	VARCHAR(512),
    amount	INT
);

INSERT INTO customer (customer_id, name, visited_on, amount) VALUES ('1', 'Jhon', '2019-01-01', '100');
INSERT INTO customer (customer_id, name, visited_on, amount) VALUES ('2', 'Daniel', '2019-01-02', '110');
INSERT INTO customer (customer_id, name, visited_on, amount) VALUES ('3', 'Jade', '2019-01-03', '120');
INSERT INTO customer (customer_id, name, visited_on, amount) VALUES ('4', 'Khaled', '2019-01-04', '130');
INSERT INTO customer (customer_id, name, visited_on, amount) VALUES ('5', 'Winston', '2019-01-05', '110');
INSERT INTO customer (customer_id, name, visited_on, amount) VALUES ('6', 'Elvis', '2019-01-06', '140');
INSERT INTO customer (customer_id, name, visited_on, amount) VALUES ('7', 'Anna', '2019-01-07', '150');
INSERT INTO customer (customer_id, name, visited_on, amount) VALUES ('8', 'Maria', '2019-01-08', '80');
INSERT INTO customer (customer_id, name, visited_on, amount) VALUES ('9', 'Jaze', '2019-01-09', '110');
INSERT INTO customer (customer_id, name, visited_on, amount) VALUES ('1', 'Jhon', '2019-01-10', '130');
INSERT INTO customer (customer_id, name, visited_on, amount) VALUES ('3', 'Jade', '2019-01-10', '150');


----------------------------------------------------------------------------------------------
with cte as(
  select visited_on, sum(amount) as amount
  from customer
  group by visited_on
),

-- Another CTE to calculate the rolling sum and average over a 7-day window
cte2 as (
select visited_on,
sum(amount) over( order by visited_on rows between 6 preceding and current row) as amount,
round(avg(amount) over(order by visited_on rows between 6 preceding and current row),2) as average_amount
from cte
)

-- Final select statement
select * from cte2
-- Filter by dates where visited_on is greater than or equal to 6 days after the minimum visited_on date
where visited_on >= (select dateadd(day,6,min(visited_on)) from customer);

visited_on	amount	average_amount
2019-01-07	860		122
2019-01-08	840		120
2019-01-09	840		120
2019-01-10	1000	142