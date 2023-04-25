https://datalemur.com/questions/international-call-percentage

A phone call is considered an international call when the person calling is in a different country than the person receiving the call.

What percentage of phone calls are international? Round the result to 1 decimal.

Assumption:

The caller_id in phone_info table refers to both the caller and receiver.

phone_calls Table:

Column Name		Type
caller_id		integer
receiver_id		integer
call_time		timestamp


phone_calls Example Input:

caller_id	receiver_id		call_time
1			2				2022-07-04 10:13:49
1			5				2022-08-21 23:54:56
5			1				2022-05-13 17:24:06
5			6				2022-03-18 12:11:49

phone_info Table:

Column Name		Type
caller_id		integer
country_id		integer
network			integer
phone_number	string


phone_info Example Input:

caller_id	country_id	network		phone_number
1			US			Verizon		+1-212-897-1964
2			US			Verizon		+1-703-346-9529
3			US			Verizon		+1-650-828-4774
4			US			Verizon		+1-415-224-6663
5			IN			Vodafone	+91 7503-907302
6			IN			Vodafone	+91 2287-664895

Example Output:

international_calls_pct
50.0

Explanation
There is a total of 4 calls with 2 of them being international calls (from caller_id 1 => receiver_id 5, and caller_id 5 => receiver_id 1). Thus, 2/4 = 50.0%

The dataset you are querying against may have different input & output - this is just an example!


-----------------------------------------------------------------------------------------------
CREATE SCHEMA datalemur
USE datalemur

CREATE TABLE phone_calls(caller_id INT,receiver_id INT,call_time VARCHAR(512));

INSERT INTO phone_calls (caller_id, receiver_id, call_time) VALUES ('24', '36', '07/31/2022 07:16:09');
INSERT INTO phone_calls (caller_id, receiver_id, call_time) VALUES ('5', '33', '05/14/2022 19:33:04');
INSERT INTO phone_calls (caller_id, receiver_id, call_time) VALUES ('11', '31', '07/11/2022 04:18:03');
INSERT INTO phone_calls (caller_id, receiver_id, call_time) VALUES ('13', '6', '07/16/2022 01:45:59');
INSERT INTO phone_calls (caller_id, receiver_id, call_time) VALUES ('5', '34', '08/07/2022 18:50:13');
INSERT INTO phone_calls (caller_id, receiver_id, call_time) VALUES ('45', '35', '06/14/2022 00:42:39');
INSERT INTO phone_calls (caller_id, receiver_id, call_time) VALUES ('12', '50', '08/04/2022 02:01:16');
INSERT INTO phone_calls (caller_id, receiver_id, call_time) VALUES ('14', '31', '10/29/2022 00:44:04');
INSERT INTO phone_calls (caller_id, receiver_id, call_time) VALUES ('7', '4', '09/03/2022 00:04:30');

SELECT * FROM phone_calls;

CREATE TABLE phone_info 
(
    caller_id	INT,
    country_id	VARCHAR(512),
    network	VARCHAR(512),
    phone_number	VARCHAR(512),
    receiver_id 	VARCHAR(512)
);

INSERT INTO phone_info (caller_id, country_id, network, phone_number, receiver_id) VALUES ('7', 'US', 'Verizon', '+1-415-224-6663', 'NULL ');
INSERT INTO phone_info (caller_id, country_id, network, phone_number, receiver_id ) VALUES ('11', 'IN', 'Vodafone', '+91 7503-907302', 'NULL ');
INSERT INTO phone_info (caller_id, country_id, network, phone_number, receiver_id ) VALUES ('12', 'IN', 'Vodafone', '+91 2287-664895', 'NULL ');
INSERT INTO phone_info (caller_id, country_id, network, phone_number, receiver_id ) VALUES ('13', 'UK', 'Vodafone', '+44 7700 900442', 'NULL ');
INSERT INTO phone_info (caller_id, country_id, network, phone_number, receiver_id ) VALUES ('24', 'DE', 'Deutsche Telekom', '+49 30 901820', 'NULL ');
INSERT INTO phone_info (caller_id, country_id, network, phone_number, receiver_id ) VALUES ('14', 'UK', 'Vodafone', '+44 117 496 0108', 'NULL ');
INSERT INTO phone_info (caller_id, country_id, network, phone_number, receiver_id ) VALUES ('31', 'UK', 'Vodafone', '+44 118 496 0210', 'NULL ');
INSERT INTO phone_info (caller_id, country_id, network, phone_number, receiver_id ) VALUES ('33', 'UK', 'Vodafone', '+44 115 496 0825', 'NULL ');
INSERT INTO phone_info (caller_id, country_id, network, phone_number, receiver_id ) VALUES ('34', 'UK', 'Vodafone', '+44 118 496 0951', 'NULL ');

SELECT * FROM phone_info;

SOLUTION:
------------------
Join the tables to obtain the caller's and receiver's country information.
Count the international calls and the total number of calls.
Calculate the percentage of international calls.
Step 1
To determine whether a call is international or not, we need country_id for both caller and receiver. This can be achieved by joining phone_info twice, first for the caller, and second for the receiver.


STEP1:

select caller.country_id AS caller_country,
receiver.country_id AS receiver_country
from phone_calls AS calls
LEFT JOIN phone_info AS caller
ON calls.caller_id=caller.caller_id
LEFT JOIN phone_info AS receiver
ON calls.receiver_id=receiver.caller_id;


STEP2:

After obtaining the necessary info, we can start with the calculation. To do so, we need 2 metrics:

number of total calls
number of international calls
Getting the number of total calls is easy with COUNT(*).

As for the number of international calls, we can use the CASE statement to check if the caller's country is different from the receiver's country. If it is, assign the value of 1 for international calls, otherwise NULL for non-international calls. This is known as a conditional count function.

Then, we wrap the CASE statement with either SUM() or COUNT() to add up the numbers with a value of 1 to obtain the count of international calls.



select 
SUM(CASE WHEN caller.country_id <> receiver.country_id
THEN 1 else NULL END) AS international_calls,
count(*) AS total_calls
from phone_calls AS calls
LEFT JOIN phone_info AS caller
ON calls.caller_id=caller.caller_id
LEFT JOIN phone_info AS receiver
ON calls.receiver_id=receiver.caller_id;


STEP3: FINAL SOLUTION

select 
ROUND( 100.0 * SUM(CASE WHEN caller.country_id <> receiver.country_id THEN 1
ELSE NULL END)/ COUNT(*),1) AS international_call_pct
from phone_calls AS calls
LEFT JOIN phone_info AS caller
ON calls.caller_id=caller.caller_id
LEFT JOIN phone_info AS receiver
ON calls.receiver_id=receiver.caller_id;


STEP4: FINAL SOLUTION

select 
ROUND( 100.0 * COUNT(*) FILTER(
WHERE caller.country_id <> receiver.country_id)/count(*),1) AS internaltion_calls_pct
from phone_calls AS calls
LEFT JOIN phone_info AS caller
ON calls.caller_id=caller.caller_id
LEFT JOIN phone_info AS receiver
ON calls.receiver_id=receiver.caller_id;
