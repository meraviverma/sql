DROP TABLE IF EXISTS Friends;

CREATE TABLE Friends
(
	Friend1 	VARCHAR(10),
	Friend2 	VARCHAR(10)
);
INSERT INTO Friends VALUES ('Jason','Mary');
INSERT INTO Friends VALUES ('Mike','Mary');
INSERT INTO Friends VALUES ('Mike','Jason');
INSERT INTO Friends VALUES ('Susan','Jason');
INSERT INTO Friends VALUES ('John','Mary');
INSERT INTO Friends VALUES ('Susan','Mary');

select * from Friends;


select friend1,friend2 from friends
UNION ALL
SELECT friend2,friend1 from Friends
order by 1

"friend1"	"friend2"
"Jason"	"Mary"
"Jason"	"Susan"
"Jason"	"Mike"
"John"	"Mary"
"Mary"	"Susan"
"Mary"	"Jason"
"Mary"	"Mike"
"Mary"	"John"
"Mike"	"Jason"
"Mike"	"Mary"
"Susan"	"Jason"
"Susan"	"Mary"
