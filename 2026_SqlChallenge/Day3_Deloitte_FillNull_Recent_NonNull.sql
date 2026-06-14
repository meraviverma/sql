-- ✅ You're given a table:
-- 📊 Stocks
-- | DateKey | StockName | Price |
-- And some of the prices are NULL.

-- 🎯 Your challenge:
-- For each stock,
-- Fill every NULL price using the most recent non-NULL value.



Create table  Stocks(Datekey date,StockName varchar (50),Price int)
insert into Stocks values
('2025-08-19','Infosys',1400),
('2025-08-20','Infosys',null),
('2025-08-21','Infosys',1450),
('2025-08-22','Infosys',null),
('2025-08-23','Infosys',null),
('2025-08-23','Infosys',null),
('2025-08-19','Reliance',2300),
('2025-08-20','Reliance',null)

"2025-08-19"	"Infosys"	1400
"2025-08-20"	"Infosys"	
"2025-08-21"	"Infosys"	1450
"2025-08-22"	"Infosys"	
"2025-08-23"	"Infosys"	
"2025-08-23"	"Infosys"	
"2025-08-19"	"Reliance"	2300
"2025-08-20"	"Reliance"	

-- Solution:

WITH  Not_Null AS (
  SELECT DateKey,StockName,Price,
    COUNT(Price) OVER (
      PARTITION BY StockName
      ORDER BY DateKey
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS grp
  FROM stocks
)
SELECT DateKey,StockName,Price,
  MAX(Price) OVER (
    PARTITION BY StockName, grp
  ) AS Derived_Price
FROM Not_Null
ORDER BY StockName, DateKey


-- **Explanation**

-- - **Goal:** Fill NULL `Price` values per `StockName` with the most recent non-NULL price (carry-forward last known value).

-- - **CTE `Not_Null`:**  
--   - Adds `grp` = `COUNT(Price) OVER (PARTITION BY StockName ORDER BY DateKey ROWS UNBOUNDED PRECEDING AND CURRENT ROW)`.  
--   - `COUNT(Price)` counts only non-NULL prices up to the current row, so `grp` increments each time a non-NULL `Price` appears. Rows after the same non-NULL share the same `grp`.

-- - **Final SELECT (`Derived_Price`):**  
--   - `MAX(Price) OVER (PARTITION BY StockName, grp)` computes the maximum price inside each (`StockName`, `grp`) window.  
--   - Because each group contains the most recent non-NULL price (and the rest are NULL), `MAX(Price)` returns that non-NULL price for every row in the group — effectively forward-filling the price.

-- - **Ordering / Output:**  
--   - The result lists `DateKey, StockName, Price, Derived_Price` ordered by `StockName, DateKey`. `Derived_Price` is the filled (carried-forward) price.

-- - **Edge cases:**  
--   - If a stock has leading NULLs before any non-NULL price, `grp` = 0 and `Derived_Price` remains NULL (no prior value to carry).

-- - **Quick trace (Infosys):**  
--   - `2025-08-19` Price=1400 → `grp`=1 → `Derived_Price`=1400  
--   - `2025-08-20` Price=NULL  → `grp`=1 → `Derived_Price`=1400  
--   - `2025-08-21` Price=1450 → `grp`=2 → `Derived_Price`=1450  
--   - `2025-08-22` Price=NULL  → `grp`=2 → `Derived_Price`=1450


SELECT DateKey,StockName,Price,
    COUNT(Price) OVER (
      PARTITION BY StockName
      ORDER BY DateKey
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS grp
  FROM stocks

"datekey"	"stockname"	    "price"	"grp"
"2025-08-19"	"Infosys"	1400	1
"2025-08-20"	"Infosys"		    1
"2025-08-21"	"Infosys"	1450	2
"2025-08-22"	"Infosys"		    2
"2025-08-23"	"Infosys"		    2
"2025-08-23"	"Infosys"		    2
"2025-08-19"	"Reliance"	2300	1
"2025-08-20"	"Reliance"		    1

SELECT DateKey,StockName,Price,
  MAX(Price) OVER (
    PARTITION BY StockName, grp
  ) AS Derived_Price    
FROM Not_Null
ORDER BY StockName, DateKey
"datekey"	"stockname"	    "price"	"derived_price"
"2025-08-19"	"Infosys"	1400	1400
"2025-08-20"	"Infosys"		    1400
"2025-08-21"	"Infosys"	1450	1450
"2025-08-22"	"Infosys"		    1450
"2025-08-23"	"Infosys"		    1450
"2025-08-23"	"Infosys"		    1450
"2025-08-19"	"Reliance"	2300	2300
"2025-08-20"	"Reliance"		    2300

