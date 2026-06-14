-- Imagine you have a table of travel routes:
-- ✈️ Delhi → Mumbai
-- ✈️ Mumbai → Delhi

-- To us, that's the same route.
-- But to SQL?
-- They're two completely different records.

-- 🎯 The challenge:
-- Given a table with:
-- (Start_Location
-- End_Location
-- Distance)

-- 🎯Write a query to return only the unique combinations of Source and Destination cities.
-- In other words:
-- Delhi → Mumbai ✅
-- Mumbai → Delhi ❌ (don't show it again)

Table Create and Insert statements:
Create Table Travel_Table(
Start_Location Varchar(30),
End_Location Varchar(30),
Distance int)

Insert into Travel_Table Values('Delhi','Pune',1400);
Insert into Travel_Table Values('Pune','Delhi',1400);
Insert into Travel_Table Values('Bangalore','Chennai',350);
Insert into Travel_Table Values('Mumbai','Ahmedabad',500);
Insert into Travel_Table Values('Chennai','Bangalore',350);
Insert into Travel_Table Values('Patna','Ranchi',300);

"Delhi"	"Pune"	1400
"Pune"	"Delhi"	1400
"Bangalore"	"Chennai"	350
"Mumbai"	"Ahmedabad"	500
"Chennai"	"Bangalore"	350
"Patna"	"Ranchi"	300

-- Solution:
SELECT DISTINCT
    CASE 
        WHEN Start_Location < End_Location THEN Start_Location -- If Start_Location is alphabetically less than End_Location, use Start_Location as Source
        ELSE End_Location 
    END AS Source,
    CASE 
        WHEN Start_Location < End_Location THEN End_Location  -- If Start_Location is alphabetically less than End_Location, use End_Location as Destination
        ELSE Start_Location 
    END AS Destination,
    Distance
FROM Travel_Table
ORDER BY Source, Destination;


-- Optimized tool selection## SQL Explanation

-- This query returns each unique route between two cities exactly once, regardless of direction.

-- ### What it does

-- - `SELECT DISTINCT`:
--   - Removes duplicate rows after the transformations.
--   - Ensures `Delhi → Pune` and `Pune → Delhi` are treated as one row.

-- - `CASE WHEN Start_Location < End_Location THEN Start_Location ELSE End_Location END AS Source`:
--   - Compares `Start_Location` and `End_Location` alphabetically.
--   - Chooses the alphabetically smaller city as `Source`.

-- - `CASE WHEN Start_Location < End_Location THEN End_Location ELSE Start_Location END AS Destination`:
--   - Chooses the alphabetically larger city as `Destination`.

-- Together, these `CASE` expressions normalize each route so that the route is always shown in one direction only:
-- - `Delhi → Pune` and `Pune → Delhi` both become `Delhi → Pune`
-- - `Bangalore → Chennai` and `Chennai → Bangalore` both become `Bangalore → Chennai`

-- ### Why `DISTINCT` is needed

-- Because the normalized route may appear more than once in the table (one row per direction), `DISTINCT` removes the duplicates after normalization.

-- ### What is returned

-- - `Source`: the alphabetically first city in the pair
-- - `Destination`: the alphabetically second city
-- - `Distance`: the original distance value from `Travel_Table`

-- ### Final ordering

-- - `ORDER BY Source, Destination`
--   - Sorts the output alphabetically by `Source`, then by `Destination`.

-- ### Example

-- Input rows:
-- - `Delhi, Pune, 1400`
-- - `Pune, Delhi, 1400`

-- Output:
-- - `Delhi, Pune, 1400`

-- This makes the route unique regardless of travel direction.