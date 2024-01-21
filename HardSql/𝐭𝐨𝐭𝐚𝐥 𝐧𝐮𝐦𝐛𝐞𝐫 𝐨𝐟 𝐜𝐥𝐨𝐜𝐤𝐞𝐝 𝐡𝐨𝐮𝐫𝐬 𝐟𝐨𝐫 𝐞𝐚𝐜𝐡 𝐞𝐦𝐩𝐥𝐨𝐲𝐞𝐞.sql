create table clocked_hours(
empd_id int,
swipe time,
flag char
);
insert into clocked_hours values
(11114,'08:30','I'),
(11114,'10:30','O'),
(11114,'11:30','I'),
(11114,'15:30','O'),
(11115,'09:30','I'),
(11115,'17:30','O');

select * from clocked_hours


"empd_id"	"swipe"		"flag"
11114		"08:30:00"	"I"
11114		"10:30:00"	"O"
11114		"11:30:00"	"I"
11114		"15:30:00"	"O"
11115		"09:30:00"	"I"
11115		"17:30:00"	"O"

