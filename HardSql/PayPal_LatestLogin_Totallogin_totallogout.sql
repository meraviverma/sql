https://youtu.be/u3W_Op3FTVA?si=Kk7b6Y_CZdby1Tml

data: 
employee_checkin_details:
  employeeid ,entry_details, timestamp_details 
  1000 , login , 2023-06-16 01:00:15.34
  1000 , login , 2023-06-16 02:00:15.34
  1000 , login , 2023-06-16 03:00:15.34
  1000 , logout , 2023-06-16 12:00:15.34
  1001 , login , 2023-06-16 01:00:15.34
  1001 , login , 2023-06-16 02:00:15.34
  1001 , login , 2023-06-16 03:00:15.34
  1001 , logout , 2023-06-16 12:00:15.34

employee_details:
employeeid , phone_number , isdefault
1001 ,9999 , false
1001 ,1111 , false
1001 ,2222 , true
1003 ,3333 , false

--Get following
--employeeid,totalentry,totallogin,totallogout,latestlogin,latestlogout,employee_default_phone_number


CREATE TABLE employee_checkin_details 
(
    employeeid INT,entry_details VARCHAR(512), timestamp_details 	datetime
);

INSERT INTO employee_checkin_details (employeeid ,entry_details, timestamp_details ) VALUES ('1000','login', '2023-06-16 01:00:15.34');
INSERT INTO employee_checkin_details (employeeid ,entry_details, timestamp_details ) VALUES ('1000','login', '2023-06-16 02:00:15.34');
INSERT INTO employee_checkin_details (employeeid ,entry_details, timestamp_details ) VALUES ('1000','login', '2023-06-16 03:00:15.34');
INSERT INTO employee_checkin_details (employeeid ,entry_details, timestamp_details ) VALUES ('1000','logout', '2023-06-16 12:00:15.34');
INSERT INTO employee_checkin_details (employeeid ,entry_details, timestamp_details ) VALUES ('1001','login', '2023-06-16 01:00:15.34');
INSERT INTO employee_checkin_details (employeeid ,entry_details, timestamp_details ) VALUES ('1001','login', '2023-06-16 02:00:15.34');
INSERT INTO employee_checkin_details (employeeid ,entry_details, timestamp_details ) VALUES ('1001','login', '2023-06-16 03:00:15.34');
INSERT INTO employee_checkin_details (employeeid ,entry_details, timestamp_details ) VALUES ('1001','logout', '2023-06-16 12:00:15.34');

select * from employee_checkin_details;

--------------------------------------------------------------------
CREATE TABLE employee_details 
(
    employeeid	INT,
    phone_number	INT,
    isdefault	VARCHAR(512)
);

INSERT INTO employee_details (employeeid, phone_number, isdefault) VALUES ('1001', '9999', 'false');
INSERT INTO employee_details (employeeid, phone_number, isdefault) VALUES ('1001', '1111', 'false');
INSERT INTO employee_details (employeeid, phone_number, isdefault) VALUES ('1001', '2222', 'true');
INSERT INTO employee_details (employeeid, phone_number, isdefault) VALUES ('1003', '3333', 'false');

select * from employee_details;




with login as(
select employeeid,count(*) as totallogin,max(timestamp_details) as latestlogin
from employee_checkin_details where entry_details='login'
group by employeeid
),
logout as(
select employeeid,count(*) as totallogout,max(timestamp_details) as latestlogout
from employee_checkin_details where entry_details='logout'
group by employeeid
)
select a.employeeid,a.totallogin,b.totallogout,b.latestlogout,a.totallogin + b.totallogout as  totalentry,
c.phone_number,c.isdefault from login a
inner join logout b on a.employeeid = b.employeeid
left join employee_details c on a.employeeid = c.employeeid  and c.isdefault='true'

employeeid	totallogin	totallogout	latestlogout				totalentry	phone_number	isdefault
1000		3			1			2023-06-16 12:00:15.340		4			NULL			NULL
1001		3			1			2023-06-16 12:00:15.340		4			2222			true


--------------- Solution 2 -------------------------
select a.employeeid,c.phone_number,
count(entry_details) as totalentry 
,sum(case when entry_details='login' then 1 else 0 end)  as totallogin
,sum(case when entry_details='logout' then 1 else 0 end)  as totallogout 
,max(case when entry_details='login' then timestamp_details else null end) as latestlogin
,max(case when entry_details='logout' then timestamp_details else null end) as latestlogout
from employee_checkin_details a
left join employee_details c on a.employeeid = c.employeeid  and c.isdefault='true'
group by a.employeeid,c.phone_number

