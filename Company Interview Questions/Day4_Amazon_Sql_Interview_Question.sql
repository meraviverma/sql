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
