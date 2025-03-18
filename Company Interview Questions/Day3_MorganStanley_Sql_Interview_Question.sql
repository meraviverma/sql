📌 A vaccine is administered in two doses. It is best if the doses are given between 42 and 72 days apart, inclusive. 

📌 Write a SQL query to return the percentage of beneficiaries who received both doses within the recommended time period, rounded to the nearest and Vaccination_Date


CREATE TABLE Doses (
 Dose_id INT PRIMARY KEY,
 Beneficiary_id INT,
 Dose_type VARCHAR(6),
 Vaccination_date DATE
);

INSERT INTO Doses (dose_id, beneficiary_id, dose_type, vaccination_date) VALUES
(2193, 750, 'first', '2021-05-15'),
(2194, 750, 'second', '2021-07-05'),
(2195, 751, 'first', '2021-06-01'),
(2196, 751, 'second', '2021-07-31'),
(2197, 752, 'first', '2021-06-10'),
(2198, 752, 'second', '2021-07-30'),
(2199, 753, 'first', '2021-06-15'),
(2200, 753, 'second', '2021-09-01'),
(2201, 754, 'first', '2021-04-18'),
(2202, 754, 'second', '2021-06-10'),
(2203, 755, 'first', '2021-05-25'),
(2204, 755, 'second', '2021-08-15');

select * from Doses;

"dose_id"	"beneficiary_id"	"dose_type"	"vaccination_date"
2194		750					"second"	"2021-07-05"
2193		750					"first"		"2021-05-15"
2195		751					"first"		"2021-06-01"
2196		751					"second"	"2021-07-31"
2197		752					"first"		"2021-06-10"
2198		752					"second"	"2021-07-30"
2199		753					"first"		"2021-06-15"
2200		753					"second"	"2021-09-01"
2201		754					"first"		"2021-04-18"
2202		754					"second"	"2021-06-10"
2203		755					"first"		"2021-05-25"
2204		755					"second"	"2021-08-15"


📌 𝐎𝐮𝐭𝐩𝐮𝐭:
percentage_within_recommended_period
67

𝐀𝐩𝐩𝐫𝐨𝐚𝐜𝐡:

𝐅𝐢𝐧𝐝 𝐭𝐡𝐞 𝐝𝐢𝐟𝐟𝐞𝐫𝐞𝐧𝐜𝐞 𝐨𝐟 𝐝𝐚𝐲𝐬 𝐛𝐞𝐭𝐰𝐞𝐞𝐧 𝐟𝐢𝐫𝐬𝐭 𝐝𝐨𝐬𝐞 𝐚𝐧𝐝 𝐬𝐞𝐜𝐨𝐧𝐝 𝐝𝐨𝐬𝐞:
𝐀. Retrieves each beneficiary’s first and second vaccination dates.
𝐁. Calculates the number of days between the two doses using LEAD() and DATEDIFF().

𝐃𝐀𝐓𝐄𝐃𝐈𝐅𝐅(𝐝𝐚𝐭𝐞𝐩𝐚𝐫𝐭, 𝐬𝐭𝐚𝐫𝐭_𝐝𝐚𝐭𝐞, 𝐞𝐧𝐝_𝐝𝐚𝐭𝐞) ==> Return date difference

𝐋𝐄𝐀𝐃(𝐯𝐚𝐜𝐜𝐢𝐧𝐚𝐭𝐢𝐨𝐧_𝐝𝐚𝐭𝐞) 𝐎𝐕𝐄𝐑(𝐏𝐀𝐑𝐓𝐈𝐓𝐈𝐎𝐍 𝐁𝐘 𝐛𝐞𝐧𝐞𝐟𝐢𝐜𝐢𝐚𝐫𝐲_𝐢𝐝 𝐎𝐑𝐃𝐄𝐑 𝐁𝐘 𝐛𝐞𝐧𝐞𝐟𝐢𝐜𝐢𝐚𝐫𝐲_𝐢𝐝) ==> Return second_dose_date (end_date) for each beneficiary_id

𝐂𝐡𝐞𝐜𝐤_𝐟𝐨𝐫_𝐠𝐢𝐯𝐞𝐧_𝐝𝐚𝐲𝐬_𝐛𝐫𝐚𝐜𝐤𝐞𝐭𝐬 𝐂𝐓𝐄:
𝐀. Checks if the days difference between doses is within the recommended range.
𝐁. Labels beneficiaries who meet the requirement with 'Y' and others with 'N'.

𝐅𝐢𝐧𝐝 𝐭𝐡𝐞 𝐩𝐞𝐫𝐜𝐞𝐧𝐭𝐚𝐠𝐞 𝐨𝐟 𝐛𝐞𝐧𝐞𝐟𝐢𝐜𝐢𝐚𝐫𝐢𝐞𝐬:
𝐀. Calculates the percentage of beneficiaries who received both doses within the recommended period.
𝐁. Sums the 'Y' values, divides by total count, multiplies by 100, and rounds the result to the nearest integer.


Solution:
----------------

Approach:
---------
select dose_id,beneficiary_id,vaccination_date as first_dose,
lead(vaccination_date) over(partition by beneficiary_id order by beneficiary_id)
as second_dose,
lead(vaccination_date) over(partition by beneficiary_id order by beneficiary_id) - vaccination_date as datediff
from doses

"dose_id"	"beneficiary_id"	"first_dose"	"second_dose"	"datediff"
2193	750	"2021-05-15"	"2021-07-05"	51
2194	750	"2021-07-05"		
2195	751	"2021-06-01"	"2021-07-31"	60
2196	751	"2021-07-31"		
2197	752	"2021-06-10"	"2021-07-30"	50
2198	752	"2021-07-30"		
2199	753	"2021-06-15"	"2021-09-01"	78
2200	753	"2021-09-01"		
2201	754	"2021-04-18"	"2021-06-10"	53
2202	754	"2021-06-10"		
2203	755	"2021-05-25"	"2021-08-15"	82
2204	755	"2021-08-15"		


with Next_Vaccination as(
select dose_id,beneficiary_id,vaccination_date as first_dose,
lead(vaccination_date) over(partition by beneficiary_id order by beneficiary_id)
as second_dose,
lead(vaccination_date) over(partition by beneficiary_id order by beneficiary_id) - vaccination_date as datediff
from doses),

check_for_given_days_bracket AS(
select dose_id,beneficiary_id,first_dose,second_dose,
	case when datediff >= 42 and datediff <= 72 then 'Y' else 'N' end as dose_within_recommended_days
	from Next_Vaccination where datediff is not null
)

select * from check_for_given_days_bracket

"dose_id"	"beneficiary_id"	"first_dose"	"second_dose"	"dose_within_recommended_days"
2193		750					"2021-05-15"	"2021-07-05"	"Y"
2195		751					"2021-06-01"	"2021-07-31"	"Y"
2197		752					"2021-06-10"	"2021-07-30"	"Y"
2199		753					"2021-06-15"	"2021-09-01"	"N"
2201		754					"2021-04-18"	"2021-06-10"	"Y"
2203		755					"2021-05-25"	"2021-08-15"	"N"




Solution:
----------------
select * from Doses;

with Next_Vaccination as(
select dose_id,beneficiary_id,vaccination_date as first_dose,
lead(vaccination_date) over(partition by beneficiary_id order by beneficiary_id)
as second_dose,
lead(vaccination_date) over(partition by beneficiary_id order by beneficiary_id) - vaccination_date as datediff
from doses),

check_for_given_days_bracket AS(
select dose_id,beneficiary_id,first_dose,second_dose,
	case when datediff >= 42 and datediff <= 72 then 'Y' else 'N' end as dose_within_recommended_days
	from Next_Vaccination where datediff is not null
)

SELECT
ROUND(SUM(CASE WHEN dose_within_recommended_days = 'Y' THEN 1  END) / 
    COUNT(*)::numeric*100, 
    0
) AS percentage
FROM check_for_given_days_bracket;
;


"percentage"
67
