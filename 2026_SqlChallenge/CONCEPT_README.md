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


# 📘 Advanced SQL Window Functions FIRST_VALUE, LAST_VALUE,NTH_VALUE, NTILE, CUME_DIST,PERCENT_RANK and Frame Clause Tutorial

`FIRST_VALUE`, `LAST_VALUE`, `NTH_VALUE`, `NTILE`, `CUME_DIST`, and `PERCENT_RANK`,  
as well as an in-depth look at **Frame Clauses** and the alternate `WINDOW` syntax.  

---

## 1️⃣ The Dataset
All examples in this tutorial use a `product` table containing product categories, brands, product names, and prices.  

```sql
CREATE TABLE product (
    product_category varchar(255),
    brand varchar(255),
    product_name varchar(255),
    price int
);
```

*Sample categories include Phone, Laptop, Earphone, Headphone, and Smartwatch.*

---

## 2️⃣ FIRST_VALUE
**Concept:** Extracts a value or column from the very first record within a defined partition.  

**Example:** Fetch the most expensive product under each category.  

```sql
SELECT *,
    first_value(product_name) OVER(PARTITION BY product_category ORDER BY price DESC) AS most_exp_product
FROM product;
```
**SYNTAX**
```sql
FIRST_VALUE(expression) OVER (
    [PARTITION BY partition_expression, ...]
    ORDER BY sort_expression [ASC | DESC]
    [rows_range_clause]
)
```

**Explanation:**  
- `PARTITION BY product_category` → divides data into windows per category.  
- `ORDER BY price DESC` → sorts by descending price.  
- `first_value(product_name)` → grabs product name from the first row.  

---

## 3️⃣ LAST_VALUE & The Frame Clause
**Concept:** Fetches a value from the very last record of a partition.  

⚠️ **Issue:** Default frame clause (`RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`) restricts access up to the current row, causing incorrect results.  

**Solution:** Explicitly extend frame to include all rows with `UNBOUNDED FOLLOWING`.  

**SYNTAX**

```sql
LAST_VALUE(expression) OVER (
    [PARTITION BY partition_expression, ...]
    ORDER BY sort_expression [ASC | DESC]
    [rows_range_clause]
)
```
```sql
SELECT *,
    first_value(product_name) OVER(PARTITION BY product_category ORDER BY price DESC) AS most_exp_product,
    last_value(product_name) OVER(PARTITION BY product_category ORDER BY price DESC
        RANGE BETWEEN unbounded preceding AND unbounded following) AS least_exp_product
FROM product
WHERE product_category ='Phone';
```

### RANGE vs. ROWS
| Feature | `ROWS` | `RANGE` |
|---------|--------|---------|
| Basis   | Physical row positions | Logical values in `ORDER BY` |
| Handling | Stops at exact row | Extends to duplicates with same value |

---

## 4️⃣ Alternate Window Syntax
**Concept:** Use `WINDOW` keyword to avoid repeating identical `OVER` clauses.  

```sql
SELECT *,
    first_value(product_name) OVER w AS most_exp_product,
    last_value(product_name) OVER w AS least_exp_product
FROM product
WHERE product_category ='Phone'
WINDOW w AS (PARTITION BY product_category ORDER BY price DESC
    RANGE BETWEEN unbounded preceding AND unbounded following);
```

---

## 5️⃣ NTH_VALUE
**Concept:** Fetches a value from a specific position (Nth row) within a partition.  

**Example:** Display the 5th most expensive product under each category.  

**SYNTAX**

```sql
NTH_VALUE(expression, nth_row) OVER (
    [PARTITION BY partition_expression, ...]
    ORDER BY sort_expression [ASC | DESC]
    [rows_range_clause]
)
```
```sql
SELECT *,
    first_value(product_name) OVER w AS most_exp_product,
    last_value(product_name) OVER w AS least_exp_product,
    nth_value(product_name, 5) OVER w AS second_most_exp_product
FROM product
WINDOW w AS (PARTITION BY product_category ORDER BY price DESC
    RANGE BETWEEN unbounded preceding AND unbounded following);
```

⚠️ If partition has fewer rows than N, returns `NULL`.  
Frame clause must include `UNBOUNDED FOLLOWING`.  

---

## 6️⃣ NTILE
**Concept:** Divides sorted dataset into specified number of buckets.  

**Example:** Segregate phones into 3 categories.  

**SYNTAX**
```sql
NTILE(number_of_buckets) OVER (
    [PARTITION BY partition_expression, ...]
    ORDER BY sort_expression [ASC | DESC]
)
```

```sql
SELECT x.product_name,
    CASE 
        WHEN x.buckets = 1 THEN 'Expensive Phones'
        WHEN x.buckets = 2 THEN 'Mid Range Phones'
        WHEN x.buckets = 3 THEN 'Cheaper Phones' 
    END AS Phone_Category
FROM (
    SELECT *,
        ntile(3) OVER (ORDER BY price DESC) AS buckets
    FROM product
    WHERE product_category = 'Phone'
) x;
```

---

## 7️⃣ CUME_DIST (Cumulative Distribution)
**Concept:** Returns percentage of rows with values ≤ current row.  

**Formula:**  
\[
\text{CUME\_DIST} = \frac{\text{Row No (last duplicate)}}{\text{Total Rows}}
\]

**SYNTAX**
```sql
CUME_DIST() OVER (
    [PARTITION BY partition_expression, ...]
    ORDER BY sort_expression [ASC | DESC]
)
```

**Example:** Fetch products in top 30% most expensive.  

```sql
SELECT product_name, cume_dist_percetage
FROM (
    SELECT *,
        cume_dist() OVER (ORDER BY price DESC) AS cume_distribution,
        ROUND(cume_dist() OVER (ORDER BY price DESC)::numeric * 100, 2) || '%' AS cume_dist_percetage
    FROM product
) x
WHERE x.cume_distribution <= 0.3;
```

---

## 8️⃣ PERCENT_RANK
**Concept:** Relative rank of each row as a percentage.  

**Formula:**  
\[
\text{PERCENT\_RANK} = \frac{\text{Row No} - 1}{\text{Total Rows} - 1}
\]

**SYNTAX**

```sql
PERCENT_RANK() OVER (
    [PARTITION BY partition_expression, ...]
    ORDER BY sort_expression [ASC | DESC]
)
```

**Example:** Compare "Galaxy Z Fold 3" with all products.  

```sql
SELECT product_name, per
FROM (
    SELECT *,
        percent_rank() OVER(ORDER BY price) ,
        ROUND(percent_rank() OVER(ORDER BY price)::numeric * 100, 2) AS per
    FROM product
) x
WHERE x.product_name='Galaxy Z Fold 3';
```

---

✅ **Summary:**  
- `FIRST_VALUE` → first record in partition.  
- `LAST_VALUE` → last record (requires frame clause).  
- `NTH_VALUE` → Nth record.  
- `NTILE` → bucket distribution.  
- `CUME_DIST` → cumulative percentage.  
- `PERCENT_RANK` → relative rank percentage.  
- Frame clauses (`ROWS` vs `RANGE`) are critical for correct results.  
- Use `WINDOW` keyword for cleaner queries. 



