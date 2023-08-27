Write a query to retrieve the final account balance for each account.
------------------------------------------------------------------------

CREATE TABLE transaction_table (
  transaction_id INT PRIMARY KEY,
  account_id INT,
  amount DECIMAL(10, 2),
  transaction_type VARCHAR(50))
  

INSERT INTO transaction_table (transaction_id, account_id, amount, transaction_type)
VALUES
  (123, 11, 10, 'Deposit'),
  (124, 11, 20, 'Deposit'),
  (126, 21, 20, 'Deposit'),
  (125, 11, 5, 'Withdrawal'),
  (128, 21, 10, 'Withdrawal'),
  (130, 31, 98, 'Deposit'),
  (132, 31, 36, 'Withdrawal'),
  (140, 21, 16, 'Deposit');
  

select * from transaction_table;

transaction_id	account_id	amount	transaction_type
123				11			10		Deposit
124				11			20		Deposit
126				21			20		Deposit
125				11			5		Withdrawal
128				21			10		Withdrawal
130				31			98		Deposit
132				31			36		Withdrawal
140				21			16		Deposit


select account_id,
 SUM(case when transaction_type='Deposit' then amount else -amount end) as total_bal
 from transaction_table
 group by account_id;
 
 
"account_id"	"total_bal"
11				25
21				26
31				62
