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
--------------------------------
"empd_id"	"swipe"		"flag"
11114		"08:30:00"	"I"
11114		"10:30:00"	"O"
11114		"11:30:00"	"I"
11114		"15:30:00"	"O"
11115		"09:30:00"	"I"
11115		"17:30:00"	"O"

###### SOlution Approach

SELECT *
 ,LEAD(flag, 1) OVER (PARTITION BY empd_id ORDER BY swipe) AS next_swipe_flag
 ,LEAD(swipe, 1) OVER (PARTITION BY empd_id ORDER BY swipe) AS next_swipe_time
 FROM clocked_hours;
 
"empd_id"	"swipe"		"flag"	"next_swipe_flag"	"next_swipe_time"
11114		"08:30:00"	"I"		"O"					"10:30:00"
11114		"10:30:00"	"O"		"I"					"11:30:00"
11114		"11:30:00"	"I"		"O"					"15:30:00"
11114		"15:30:00"	"O"		
11115		"09:30:00"	"I"		"O"					"17:30:00"
11115		"17:30:00"	"O"		
 

