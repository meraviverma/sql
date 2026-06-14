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

## LAG() Function 

The LAG() function allows access to a value stored in a different row above the current row. The row above may be adjacent or some number of rows above, as sorted by a specified column or set of columns.

Let’s look its syntax:

- LAG(expression [,offset[,default_value]]) OVER(ORDER BY columns)

LAG() takes three arguments: the name of the column or an expression from which the value is obtained, the number of rows to skip (offset) above, and the default value to be returned if the stored value obtained from the row above is empty. Only the first argument is required. The third argument (default value) is allowed only if you specify the second argument, the offset.

```
SELECT seller_name, sale_value,
  LAG(sale_value) OVER(ORDER BY sale_value) as previous_sale_value
FROM sale;
```
![alt text](Source/LAG.png)


## LEAD() FUnction

- LEAD(expression [,offset[,default_value]]) OVER(ORDER BY columns)

LEAD() function takes three arguments: the name of a column or an expression, the offset to be skipped below, and the default value to be returned if the stored value obtained from the row below is empty. Only the first argument is required. The third argument, the default value, can be specified only if you specify the second argument, the offset.

```
SELECT seller_name, sale_value,
  LEAD(sale_value) OVER(ORDER BY sale_value) as next_sale_value
FROM sale;
```

![alt text](Source/LEAD.png)

# 📓 SQL Window Functions: `ROWS BETWEEN` vs. `RANGE BETWEEN`

---

## 📌 Core Difference
> **Golden Rule:**  
> - `ROWS BETWEEN` → works on **physical row positions**.  
> - `RANGE BETWEEN` → works on **logical values** in the `ORDER BY` column.

---

## 🔢 Example with Integers (`price` in `stock_trades`)

### `ROWS BETWEEN`
```sql
SELECT 
    trade_id, trade_date, price, volume,
    SUM(volume) OVER (
        ORDER BY price 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rows_3_sum
FROM stock_trades;

```
- Looks at **exactly 2 rows before + current row**.  
- Ignores gaps in `price`.

### `RANGE BETWEEN`
```sql
SELECT 
    trade_id, trade_date, price, volume,
    SUM(volume) OVER (
        ORDER BY price 
        RANGE BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS range_3_sum
FROM stock_trades;
```
- If current `price = 103`, sums all rows with `price` in `[101, 103]`.  
- Includes **all rows** in that logical range.

---

## 📅 Example with Dates (`order_date` in `orders`)

### `ROWS BETWEEN`
```sql
SELECT 
    order_id, order_date, customer_id, amount,
    SUM(amount) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rows_3_sum
FROM orders;
```
- Sums **current + 2 preceding rows**, regardless of actual dates.

### `RANGE BETWEEN` (with `INTERVAL`)
```sql
SELECT 
    order_id, order_date, customer_id, amount,
    SUM(amount) OVER (
        ORDER BY order_date 
        RANGE BETWEEN INTERVAL '2 days' PRECEDING AND CURRENT ROW
    ) AS range_3_sum
FROM orders;
```
- If current row = `Jan 3`, sums all rows between `Jan 1` → `Jan 3`.  
- Includes **all orders** in that date window.

---

## ✅ Summary Checklist

| Feature            | `ROWS BETWEEN`                        | `RANGE BETWEEN`                                |
|--------------------|----------------------------------------|------------------------------------------------|
| **Logic Basis**    | Physical row positions                 | Logical values in `ORDER BY` column            |
| **Row Limit**      | Fixed offset (e.g., 2 rows)            | Dynamic, includes all rows in value range      |
| **Dates vs. Ints** | Works same for both                    | Requires `INTERVAL` for dates                  |
| **Best Use Case**  | Strict moving averages (last N rows)   | Value/time-bound windows (e.g., last 48 hours) |

---

💡 **Tip:**  
- Use `ROWS BETWEEN` when you want **exact row counts** (e.g., last 5 trades).  
- Use `RANGE BETWEEN` when you want **value-based ranges** (e.g., all trades in last 2 days or within ±10 price units).

![alt text](Source/ROWS_BETWEEN_RANGE_BETWEEN.png)

![alt text](Source/ROWS_BETWEEN_RANGE_BETWEEN_DateInterval.png)

![alt text](Source/ROWS_BETWEEN.png)



