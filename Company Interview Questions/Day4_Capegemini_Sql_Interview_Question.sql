Capgemini SQL Interview Question

📌 The relationship between the LIFT and LIFT PASSENGERS table is such that multiple passengers can attempt to enter the same lift. but the total weight of the passengers in a lift cannot exceed the lift's capacity.

📌 Your task is to write a SQL query that produces a comma-separated list of passengers who can be accommodated in each lift without exceeding the lift's capacity. The passengers in the list should be ordered by their weight in increasing order.

📌 You can assume that the weights of the passengers are unique within each lift.


CREATE TABLE LIFT (
 ID INT PRIMARY KEY,
 CAPACITY_KG INT
);

INSERT INTO LIFT (ID, CAPACITY_KG) VALUES
(1, 300),
(2, 350);



CREATE TABLE LIFT_PASSENGERS (
 PASSENGER_NAME VARCHAR(50),
 WEIGHT_KG INT,
 LIFT_ID INT,
 FOREIGN KEY (LIFT_ID) REFERENCES LIFT(ID)
);

INSERT INTO LIFT_PASSENGERS (PASSENGER_NAME, WEIGHT_KG, LIFT_ID) VALUES
('Rahul', 85, 1),
('Adarsh', 73, 1),
('Riti', 95, 1),
('Dheeraj', 80, 1),
('Vimal', 83, 2),
('Neha', 77, 2),
('Priti', 73, 2),
('Himanshi', 85, 2);

LIFT_PASSENGERS
-----------------
"passenger_name"	"weight_kg"	"lift_id"
"Rahul"				85				1
"Adarsh"			73				1
"Riti"				95				1
"Dheeraj"			80				1
"Vimal"				83				2
"Neha"				77				2
"Priti"				73				2
"Himanshi"			85				2


LIFT
-------
"id"	"capacity_kg"
1		300
2		350

𝐀𝐩𝐩𝐫𝐨𝐚𝐜𝐡:
-----------
𝐂𝐚𝐥𝐜𝐮𝐥𝐚𝐭𝐞 𝐂𝐮𝐦𝐮𝐥𝐚𝐭𝐢𝐯𝐞 𝐖𝐞𝐢𝐠𝐡𝐭:
Computes the cumulative weight for each lift in increasing order of weight.

𝐅𝐢𝐥𝐭𝐞𝐫 𝐏𝐚𝐬𝐬𝐞𝐧𝐠𝐞𝐫𝐬:
Keep only passengers whose cumulative weight does not exceed the lift's capacity, where cumulative_weight <= capacity_kg.

𝐂𝐨𝐧𝐜𝐚𝐭𝐞𝐧𝐚𝐭𝐞 𝐏𝐚𝐬𝐬𝐞𝐧𝐠𝐞𝐫 𝐍𝐚𝐦𝐞𝐬:
𝐀. Use 𝐬𝐭𝐫𝐢𝐧𝐠_𝐚𝐠𝐠() to concate passengers name
𝐁. Ensures passengers are listed in increasing order of weight.

𝐬𝐭𝐫𝐢𝐧𝐠_𝐚𝐠𝐠(): It is a SQL Server aggregate function that concatenates values from multiple rows into a single string, separated by a specified delimiter.

SOLUTION:
--------------
select l.id,
lp.passenger_name,l.capacity_kg,
sum(lp.weight_kg) over(partition by lp.lift_id order by lp.weight_kg) as running_total
from lift l join lift_passengers lp on l.id=lp.lift_id

"id"	"passenger_name"	"capacity_kg"	"running_total"
1		"Adarsh"			300				73
1		"Dheeraj"			300				153
1		"Rahul"				300				238
1		"Riti"				300				333
2		"Priti"				350				73
2		"Neha"				350				150
2		"Vimal"				350				233
2		"Himanshi"			350				318



with liftjoin as (
select l.id,
lp.passenger_name,l.capacity_kg,
sum(lp.weight_kg) over(partition by lp.lift_id order by lp.weight_kg) as running_total
from lift l join lift_passengers lp on l.id=lp.lift_id),

capacity_wise_passeger as(
select * from liftjoin where running_total < capacity_kg
)

select id as lift_id,
string_agg(passenger_name,',') as passengers
from capacity_wise_passeger
group by id;


"lift_id"	"passengers"
1			"Adarsh,Dheeraj,Rahul"
2			"Priti,Neha,Vimal,Himanshi"
