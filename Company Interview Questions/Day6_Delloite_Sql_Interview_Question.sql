
📌 Your objective is to compute the population density for each city, using the formula (population/area), and round the result to the nearest integer. 

📌 Ensure that ties in population density are accounted for by including all cities with the same density in the results. 

📌 Additionally, order the cities by population density, from highest to lowest, and identify the cities with the minimum and maximum population  densities.

CREATE TABLE cities_population (
 city VARCHAR(50),
 country VARCHAR(50),
 population INT,
 area INT
);

INSERT INTO cities_population (city, country, population, area) VALUES
('Metropolis', 'Countryland', 1000000, 500),
('Smallville', 'Countryland', 50000, 1000),
('Coastcity', 'Oceanland', 300000, 0),
('Starcity', 'Mountainous', 600000, 600),
('Gotham', 'Islander', 1500000, 300),
('Rivertown', 'Plainsland', 100000, 5000),
('Lakecity', 'Forestland', 100000, 5000),
('Hilltown', 'Hillside', 200000, 450),
('Forestville', 'Forestland', 500000, 700),
('Oceanview', 'Seaside', 800000, 0),
('Desertville', 'Desertland', 300000, 1200),
('Snowpeak', 'Mountainous', 250000, 800),
('Sunsetville', 'Islander', 120000, 250),
('Techburg', 'Countryland', 400000, 350),
('Midtown', 'Plainsland', 300000, 900),
('Riverdale', 'Riverland', 180000, 300),
('Skyline', 'Mountainous', 700000, 550),
('Coralbay', 'Seaside', 450000, 0),
('Pinegrove', 'Forestland', 120000, 700),
('Meadowville', 'Plainsland', 90000, 600);

𝐀𝐩𝐩𝐫𝐨𝐚𝐜𝐡:

𝐂𝐚𝐥𝐜𝐮𝐥𝐚𝐭𝐞 𝐏𝐨𝐩𝐮𝐥𝐚𝐭𝐢𝐨𝐧 𝐃𝐞𝐧𝐬𝐢𝐭𝐲:
𝐀. Compute population/area and round it to the nearest integer.
𝐁. Exclude cities where area = 0 to avoid division errors.

𝐀𝐬𝐬𝐢𝐠𝐧 𝐑𝐚𝐧𝐤𝐬 𝐔𝐬𝐢𝐧𝐠 𝐃𝐄𝐍𝐒𝐄_𝐑𝐀𝐍𝐊():
Rank cities based on highest and lowest population densities by using DENSE_RANK(), which provides a continuous ranking.

 𝐇𝐢𝐠𝐡𝐞𝐬𝐭_𝐝𝐞𝐧𝐬𝐢𝐭𝐲 𝐫𝐚𝐧𝐤𝐢𝐧𝐠:
 Gotham has population density of 5000 and ranked 1
 Metropolis has population density of 2000, ranked 2, and so on.

𝐒𝐢𝐦𝐢𝐥𝐚𝐫𝐥𝐲,

 𝐋𝐨𝐰𝐞𝐬𝐭_𝐝𝐞𝐧𝐬𝐢𝐭𝐲 𝐫𝐚𝐧𝐤𝐢𝐧𝐠:
 Rivertown has population density 20, and ranked 1
 Lackcity has population density 20, ranked 1
 Desertville has population density, ranked 2, and so on.

𝐅𝐢𝐥𝐭𝐞𝐫 𝐟𝐨𝐫 𝐂𝐢𝐭𝐢𝐞𝐬 𝐰𝐢𝐭𝐡 𝐇𝐢𝐠𝐡𝐞𝐬𝐭 & 𝐋𝐨𝐰𝐞𝐬𝐭 𝐃𝐞𝐧𝐬𝐢𝐭𝐲:
Select cities with the maximum and minimum density values by using the ranking (𝐢.𝐞. 𝐰𝐡𝐞𝐫𝐞 𝐃𝐄𝐍𝐒𝐄_𝐑𝐀𝐍𝐊 = 𝟏)

𝐒𝐨𝐫𝐭 𝐭𝐡𝐞 𝐑𝐞𝐬𝐮𝐥𝐭:
Display cities in descending order of population density.


-------------------------------------------------------------------------

"city"			"country"		"population"	"area"
"Metropolis"	"Countryland"	1000000			500
"Smallville"	"Countryland"	50000			1000
"Coastcity"		"Oceanland"		300000			0
"Starcity"		"Mountainous"	600000			600
"Gotham"		"Islander"		1500000			300
"Rivertown"		"Plainsland"	100000			5000
"Lakecity"		"Forestland"	100000			5000
"Hilltown"		"Hillside"		200000			450
"Forestville"	"Forestland"	500000			700
"Oceanview"		"Seaside"		800000			0
"Desertville"	"Desertland"	300000			1200
"Snowpeak"		"Mountainous"	250000			800
"Sunsetville"	"Islander"		120000			250
"Techburg"		"Countryland"	400000			350
"Midtown"		"Plainsland"	300000			900
"Riverdale"		"Riverland"		180000			300
"Skyline"		"Mountainous"	700000			550
"Coralbay"		"Seaside"		450000			0
"Pinegrove"		"Forestland"	120000			700
"Meadowville"	"Plainsland"	90000			600






