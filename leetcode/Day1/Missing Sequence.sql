------------------------------------------------------------
####### FInd the Missing sequence from the element ########
-----------------------------------------------------------
create table table_sequence
(seq int);

insert into table_sequence values (1),(2),(4),(5),(8),(9),(13),(14),(15);

select * from table_sequence;

"seq"
1
2
4
5
8
9
13
14
15


select s.seq,lead(s.seq) over (order by s.seq)next_seq from table_sequence s;

"seq"	"next_seq"
1	2
2	4
4	5
5	8
8	9
9	13
13	14
14	15
15	NULL



select s.seq,lead(s.seq) over (order by s.seq)next_seq,
(lead(s.seq)over (order by s.seq)-s.seq) next_seq_gap
from table_sequence s;


"seq"	"next_seq"	"next_seq_gap"
1		2			1
2		4			2
4		5			1
5		8			3
8		9			1
9		13			4
13		14			1
14		15			1
15		null 		null	




with temp_next_seq as(
select s.seq,(lead(s.seq)over (order by s.seq)-s.seq) next_seq_gap from table_sequence s)
select * from temp_next_seq t
where next_seq_gap >1;

"seq"	"next_seq_gap"
2		2
5		3
9		4



FINAL SOLUTION
-----------------------
with temp_next_seq as(
select s.seq,(lead(s.seq)over (order by s.seq)-s.seq) next_seq_gap from table_sequence s)
select t.seq +1 missing_seq_start,
t.seq+t.next_seq_gap-1 missing_seq_end from temp_next_seq t
where next_seq_gap >1;


"missing_seq_start"	"missing_seq_end"
3					3
6					7
10					12

