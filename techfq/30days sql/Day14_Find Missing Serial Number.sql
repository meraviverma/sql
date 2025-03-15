drop table if exists invoice;
create table invoice
(
	serial_no		int,
	invoice_date	date
);
insert into invoice values (330115, to_date('01-Mar-2024','DD-MON-YYYY'));
insert into invoice values (330120, to_date('01-Mar-2024','DD-MON-YYYY'));
insert into invoice values (330121, to_date('01-Mar-2024','DD-MON-YYYY'));
insert into invoice values (330122, to_date('02-Mar-2024','DD-MON-YYYY'));
insert into invoice values (330125, to_date('02-Mar-2024','DD-MON-YYYY'));

select * from invoice;

"serial_no"	"invoice_date"
330115		"2024-03-01"
330120		"2024-03-01"
330121		"2024-03-01"
330122		"2024-03-02"
330125		"2024-03-02"


with cte as (select generate_series(min(serial_no),max(serial_no)) as seq
from invoice
			 )
select seq as missing_serial_no from cte left outer join invoice on cte.seq=invoice.serial_no 
where invoice.serial_no is NULL


"missing_serial_no"
330116
330117
330118
330119
330123
330124


-------------------------------------
Genertae serial number:
with recursive cte as (
select min(serial_no) as n from invoice
	union 
	select (n+1) as n
	from cte
	where n < (select max(serial_no) from invoice)
)
select * from cte


