Find out top 20 % products which gives 80% of the sales. This is also known as pareto principle.
-----------------------------------------------------------------------------------------------------
80% of productivity comes form the 20% of causes.
80% of sales comes from the 20% of the products
--------------------------------------------------


select sum(sales) * 0.8 from orders;

(No column name)
1837760.68823996

# this is 80% of the sales

select product_id,sum(sales) as product_sales
from orders
group by product_id
order by product_sales desc;


with product_wise_sales as 
(
select product_id,sum(sales) as product_sales
from orders
group by product_id)

select product_id,product_sales,sum(product_sales) over (order by product_sales desc rows between unbounded preceding and 0 preceding) as running_sales,
0.8*sum(product_sales) over() as total_sales
from product_wise_sales;


with product_wise_sales as 
(
select product_id,sum(sales) as product_sales
from orders
group by product_id)
,
calc_sales as (
select product_id,product_sales,sum(product_sales) over (order by product_sales desc rows between unbounded preceding and 0 preceding) as running_sales,
0.8*sum(product_sales) over() as total_sales
from product_wise_sales)

select * from calc_sales where running_sales < total_sales

so this 413 products are giving 80% of sales.

