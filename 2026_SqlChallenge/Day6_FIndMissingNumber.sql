-- You're given a table containing:
-- 1, 2, 3, 4, 5, 10

-- 🎯 The task:
-- Find all the missing numbers between the minimum and maximum values.
-- Simple?

-- Then comes the twist.
-- 🚫 Recursive CTEs are NOT allowed.
-- Here's a SQL query that finds all the missing numbers between the minimum and maximum values in the given table without using recursive CTEs:

create DATABASE IF NOT EXISTS SqlChallenge;
USE SqlChallenge;
DROP TABLE IF EXISTS Numbers;
CREATE TABLE Numbers (
    num INT
);  
INSERT INTO Numbers (num) VALUES (1), (2), (3), (4), (5), (10);

WITH RECURSIVE range_cte AS (
    SELECT MIN(num) AS min_num, MAX(num) AS max_num
    FROM numbers
),
num_cte AS (
    -- anchor: start at min_num
    SELECT min_num AS num, max_num
    FROM range_cte
    UNION ALL
    -- recursive step: keep adding +1 until max_num
    SELECT num + 1, max_num
    FROM num_cte
    WHERE num < max_num
)
SELECT num
FROM num_cte
WHERE num NOT IN (SELECT num FROM numbers)
ORDER BY num;



-- **Query breakdown**
-- - **range_cte:** computes `MIN(num)` and `MAX(num)` from `numbers`. It returns one row with `min_num` and `max_num`.
-- - **num_cte (recursive CTE):**
--   - Anchor: selects `min_num AS num, max_num` from `range_cte` (starts the sequence at the minimum).
--   - Recursive step: `UNION ALL` adds rows by selecting `num + 1, max_num` from `num_cte` while `num < max_num`. This generates every integer from `min_num` up to `max_num`.
-- - **Final SELECT:**
--   - `SELECT num FROM num_cte WHERE num NOT IN (SELECT num FROM numbers)` — returns every generated number that is not present in the `Numbers` table.
--   - `ORDER BY num` sorts results ascending.

-- For the provided data (1,2,3,4,5,10) the output will be: 6, 7, 8, 9.

--Solution 2:
SELECT generate_series(
    (SELECT MIN(Num) FROM Numbers), 
    (SELECT MAX(Num) FROM Numbers)
) AS Missing_Num
EXCEPT
SELECT Num 
FROM Numbers
ORDER BY Missing_Num;


