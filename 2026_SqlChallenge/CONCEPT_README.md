### NOT IN VS NOT EXISTS
- NOT IN can return unexpected results when NULLs exist
- NOT EXISTS handles NULLs safely
- One hidden NULL can change your entire output
- This is a common interview + production-level SQL mistake

## UNION VS UNION ALL
- UNION ALL is often the better choice.

𝐖𝐡𝐲?
- UNION removes duplicates
- Performs duplicate elimination internally
- Can be slower on large datasets

𝐖𝐡𝐞𝐫𝐞𝐚𝐬:
- UNION ALL keeps all rows
- Avoids unnecessary deduplication
- Usually faster for analytics workloads

## count(*) VS Count(ColumnName)

- count(*) -> Count All rows
- count(column) -> ignore NULL Values
