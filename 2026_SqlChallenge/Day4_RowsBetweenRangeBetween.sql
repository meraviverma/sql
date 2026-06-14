scripts:
create table stock_trades(
trade_id int,
trade_date date,
price int,
volume int
);

insert into stock_trades values
(1,'2024-01-01',100,500),
(2,'2024-01-01',102,300),
(3,'2024-01-01',103,400),
(4,'2024-01-01',105,350),
(5,'2024-01-02',107,450),
(6,'2024-01-02',108,250),
(7,'2024-01-03',110,600),
(8,'2024-01-02',112,500);

create table orders(
order_id int,
order_date date,
customer_id int,
amount int
);

insert into orders values
(1,'2024-01-01',101,100),
(2,'2024-01-01',102,150),
(3,'2024-01-01',103,200),
(4,'2024-01-01',104,120),
(5,'2024-01-02',105,180),
(6,'2024-01-03',106,250),
(7,'2024-01-03',107,300),
(8,'2024-01-03',108,400);

select 
order_id, order_date,customer_id,
sum(amount) over(order by order_date rows between 2 preceding and current row)
as rows_3sum,
sum(amount) over (order by order_date range between interval '2 days' preceding and current row)
as range_3sum
from orders

-- **Explanation**
-- - **Goal:** Calculate two running sums of `amount` for each order:
--   1. `rows_3sum`: Sum of the current and previous 2 rows (fixed number of rows).
--   2. `range_3sum`: Sum of orders within the current date and the previous 2 days (dynamic range based on date).  
-- - **`ROWS BETWEEN 2 PRECEDING AND CURRENT ROW`:**
--   - Sums the `amount` of the current row and the 2 preceding rows, regardless of the date.
-- - **`RANGE BETWEEN INTERVAL '2 DAYS' PRECEDING AND CURRENT ROW`:**
--   - Sums the `amount` of all rows where `order_date` is between the current row's date and 2 days before, including the current row. This can include more or fewer than 3 rows depending on the distribution of `order_date`.   


select 
trade_id, trade_date,price,volume,
sum(volume) over(order by price rows between 2 preceding and current row)
as rows_3sum,
sum(volume) over (order by price range between 2 preceding and current row)
as range_3sum
from stock_trades;

-- **Explanation**
-- - **Goal:** Similar to the previous query, but now we are summing `volume` based on `price` instead of `order_date`.
-- - **`ROWS BETWEEN 2 PRECEDING AND CURRENT ROW`:**
--   - Sums the `volume` of the current row and the 2 preceding rows based on the order of `price`.
-- - **`RANGE BETWEEN 2 PRECEDING AND CURRENT ROW`:**
--   - Sums the `volume` of all rows where `price` is between the current row's price and 2 units less, including the current row. This can include more or fewer than 3 rows depending on the distribution of `price`.

-- 1	"2024-01-01"	100	500	500	    500
-- 2	"2024-01-01"	102	300	800	    800
-- 3	"2024-01-01"	103	400	1200	700
-- 4	"2024-01-01"	105	350	1050	750
-- 5	"2024-01-02"	107	450	1200	800
-- 6	"2024-01-02"	108	250	1050	700
-- 7	"2024-01-03"	110	600	1300	850
-- 8	"2024-01-02"	112	500	1350	1100

-- "trade_id"	"trade_date"	"price"	"volume"	"rows_3sum"	"range_3sum"
-- 1	"2024-01-01"	100	500	500	500
-- 2	"2024-01-01"	102	300	800	800
-- 3	"2024-01-01"	103	400	1200	700
-- 4	"2024-01-01"	105	350	1050	750
-- 5	"2024-01-02"	107	450	1200	800
-- 6	"2024-01-02"	108	250	1050	700
-- 7	"2024-01-03"	110	600	1300	850
-- 8	"2024-01-02"	112	500	1350	1100