Amazon SQL Interview Question

📌 You are working with a table called Orders that tracks customer orders with their order dates and amounts. 

📌 Write a query to find each customer’s latest order amount along with the amount of the second latest order. 

📌 Your output should be like customer_id, lastest_order_amount, second_lastest_order_amount


𝐀𝐩𝐩𝐫𝐨𝐚𝐜𝐡:

𝐑𝐚𝐧𝐤 𝐎𝐫𝐝𝐞𝐫𝐬 𝐟𝐨𝐫 𝐄𝐚𝐜𝐡 𝐂𝐮𝐬𝐭𝐨𝐦𝐞𝐫:
𝐀. Use 𝐃𝐄𝐍𝐒𝐄_𝐑𝐀𝐍𝐊() to assign ranks based on order_date DESC.
𝐁. Identify the latest and second-latest orders using CASE statements.
 When 𝐃𝐄𝐍𝐒𝐄_𝐑𝐀𝐍𝐊() = 1, return 1 else 0 ==> Latest_order
 When 𝐃𝐄𝐍𝐒𝐄_𝐑𝐀𝐍𝐊() = 2, return 2 else 0 ==> Second_latest_order

𝐄𝐱𝐭𝐫𝐚𝐜𝐭 𝐭𝐡𝐞 𝐋𝐚𝐭𝐞𝐬𝐭 𝐎𝐫𝐝𝐞𝐫 𝐀𝐦𝐨𝐮𝐧𝐭:
Filter rows where the latest_order = 1.

𝐄𝐱𝐭𝐫𝐚𝐜𝐭 𝐭𝐡𝐞 𝐒𝐞𝐜𝐨𝐧𝐝 𝐋𝐚𝐭𝐞𝐬𝐭 𝐎𝐫𝐝𝐞𝐫 𝐀𝐦𝐨𝐮𝐧𝐭:
Filter rows where Second_lates_order = 2.

𝐉𝐨𝐢𝐧 𝐭𝐡𝐞 𝐓𝐰𝐨 𝐑𝐞𝐬𝐮𝐥𝐭𝐬:
Combine the latest and second latest order amounts by customer_id to generate the final output.


CREATE TABLE orders (
 order_id INT,
 customer_id INT,
 order_date DATE,
 order_amount DECIMAL(10, 2)
);

INSERT INTO orders (order_id, customer_id, order_date, order_amount) VALUES
(1, 101, '2024-01-10', 150.00),
(2, 101, '2024-02-15', 200.00),
(3, 101, '2024-03-20', 180.00),
(4, 102, '2024-01-12', 200.00),
(5, 102, '2024-02-25', 250.00),
(6, 102, '2024-03-10', 320.00),
(7, 103, '2024-01-25', 400.00),
(8, 103, '2024-02-15', 420.00);


"order_id"	"customer_id"	"order_date"	"order_amount"
1			101				"2024-01-10"	150.00
2			101				"2024-02-15"	200.00
3			101				"2024-03-20"	180.00
4			102				"2024-01-12"	200.00
5			102				"2024-02-25"	250.00
6			102				"2024-03-10"	320.00
7			103				"2024-01-25"	400.00
8			103				"2024-02-15"	420.00


Solution:
--------------
with cte as(
select order_id,customer_id,order_date,order_amount,
	case when dense_rank() over(partition by customer_id order by order_date desc) =1 then 1 else 0 end as latest_order,
	case when dense_rank() over(partition by customer_id order by order_date desc) =2 then 2 else 0 end as second_latest_order
from orders),

latest_order as (select customer_id,
case when latest_order = 1 then order_amount end as lastest_order_amount
from cte where latest_order=1),

 second_latest_order as (select customer_id,
case when second_latest_order = 2 then order_amount end as second_latest_order_amount
from cte where second_latest_order=2)

select c1.customer_id,c1.lastest_order_amount,c2.second_latest_order_amount
from latest_order c1 join second_latest_order c2 ON c1.customer_id = c2.customer_id


"customer_id"	"lastest_order_amount"	"second_latest_order_amount"
101				180.00					200.00
102				320.00					250.00
103				420.00					400.00



-------------------------------------------------------------------------------
SOlution 2:
------------
WITH ct AS 
(
 SELECT *,
 ROW_NUMBER() OVER (PARTITION BY ord.customer_id ORDER BY ord.order_date DESC) AS Rn
 FROM orders ord
),
ct2 AS 
(
 SELECT *,MAX(CASE WHEN Rn=2 THEN order_amount ELSE NULL END) OVER (PARTITION BY customer_id) AS second_latest_order_amount
 FROM ct
)
SELECT customer_id,order_amount AS latest_order_amount,second_latest_order_amount
FROM ct2
WHERE 1=1
AND Rn=1


"customer_id"	"lastest_order_amount"	"second_latest_order_amount"
101				180.00					200.00
102				320.00					250.00
103				420.00					400.00


