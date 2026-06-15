-- Script to create the Product table and load data into it.

DROP TABLE product;
CREATE TABLE product
( 
    product_category varchar(255),
    brand varchar(255),
    product_name varchar(255),
    price int
);

INSERT INTO product VALUES
('Phone', 'Apple', 'iPhone 12 Pro Max', 1300),
('Phone', 'Apple', 'iPhone 12 Pro', 1100),
('Phone', 'Apple', 'iPhone 12', 1000),
('Phone', 'Samsung', 'Galaxy Z Fold 3', 1800),
('Phone', 'Samsung', 'Galaxy Z Flip 3', 1000),
('Phone', 'Samsung', 'Galaxy Note 20', 1200),
('Phone', 'Samsung', 'Galaxy S21', 1000),
('Phone', 'OnePlus', 'OnePlus Nord', 300),
('Phone', 'OnePlus', 'OnePlus 9', 800),
('Phone', 'Google', 'Pixel 5', 600),
('Laptop', 'Apple', 'MacBook Pro 13', 2000),
('Laptop', 'Apple', 'MacBook Air', 1200),
('Laptop', 'Microsoft', 'Surface Laptop 4', 2100),
('Laptop', 'Dell', 'XPS 13', 2000),
('Laptop', 'Dell', 'XPS 15', 2300),
('Laptop', 'Dell', 'XPS 17', 2500),
('Earphone', 'Apple', 'AirPods Pro', 280),
('Earphone', 'Samsung', 'Galaxy Buds Pro', 220),
('Earphone', 'Samsung', 'Galaxy Buds Live', 170),
('Earphone', 'Sony', 'WF-1000XM4', 250),
('Headphone', 'Sony', 'WH-1000XM4', 400),
('Headphone', 'Apple', 'AirPods Max', 550),
('Headphone', 'Microsoft', 'Surface Headphones 2', 250),
('Smartwatch', 'Apple', 'Apple Watch Series 6', 1000),
('Smartwatch', 'Apple', 'Apple Watch SE', 400),
('Smartwatch', 'Samsung', 'Galaxy Watch 4', 600),
('Smartwatch', 'OnePlus', 'OnePlus Watch', 220);
COMMIT;



"product_category"	"brand"	"product_name"	"price"
"Phone"	"Apple"	"iPhone 12 Pro Max"	1300
"Phone"	"Apple"	"iPhone 12 Pro"	1100
"Phone"	"Apple"	"iPhone 12"	1000
"Phone"	"Samsung"	"Galaxy Z Fold 3"	1800
"Phone"	"Samsung"	"Galaxy Z Flip 3"	1000
"Phone"	"Samsung"	"Galaxy Note 20"	1200
"Phone"	"Samsung"	"Galaxy S21"	1000
"Phone"	"OnePlus"	"OnePlus Nord"	300
"Phone"	"OnePlus"	"OnePlus 9"	800
"Phone"	"Google"	"Pixel 5"	600
"Laptop"	"Apple"	"MacBook Pro 13"	2000
"Laptop"	"Apple"	"MacBook Air"	1200
"Laptop"	"Microsoft"	"Surface Laptop 4"	2100
"Laptop"	"Dell"	"XPS 13"	2000
"Laptop"	"Dell"	"XPS 15"	2300
"Laptop"	"Dell"	"XPS 17"	2500
"Earphone"	"Apple"	"AirPods Pro"	280
"Earphone"	"Samsung"	"Galaxy Buds Pro"	220
"Earphone"	"Samsung"	"Galaxy Buds Live"	170
"Earphone"	"Sony"	"WF-1000XM4"	250
"Headphone"	"Sony"	"WH-1000XM4"	400
"Headphone"	"Apple"	"AirPods Max"	550
"Headphone"	"Microsoft"	"Surface Headphones 2"	250
"Smartwatch"	"Apple"	"Apple Watch Series 6"	1000
"Smartwatch"	"Apple"	"Apple Watch SE"	400
"Smartwatch"	"Samsung"	"Galaxy Watch 4"	600
"Smartwatch"	"OnePlus"	"OnePlus Watch"	220


-- All the SQL Queries written during the video

select * from product;


-- FIRST_VALUE 
-- Write query to display the most expensive product under each category (corresponding to each record)
select *,
first_value(product_name) over(partition by product_category order by price desc) as most_exp_product
from product;


"product_category"	"brand"	"product_name"	"price"	"most_exp_product"
"Earphone"	"Apple"	"AirPods Pro"	280	"AirPods Pro"
"Earphone"	"Sony"	"WF-1000XM4"	250	"AirPods Pro"
"Earphone"	"Samsung"	"Galaxy Buds Pro"	220	"AirPods Pro"
"Earphone"	"Samsung"	"Galaxy Buds Live"	170	"AirPods Pro"
"Headphone"	"Apple"	"AirPods Max"	550	"AirPods Max"
"Headphone"	"Sony"	"WH-1000XM4"	400	"AirPods Max"
"Headphone"	"Microsoft"	"Surface Headphones 2"	250	"AirPods Max"
"Laptop"	"Dell"	"XPS 17"	2500	"XPS 17"
"Laptop"	"Dell"	"XPS 15"	2300	"XPS 17"
"Laptop"	"Microsoft"	"Surface Laptop 4"	2100	"XPS 17"
"Laptop"	"Apple"	"MacBook Pro 13"	2000	"XPS 17"
"Laptop"	"Dell"	"XPS 13"	2000	"XPS 17"
"Laptop"	"Apple"	"MacBook Air"	1200	"XPS 17"
"Phone"	"Samsung"	"Galaxy Z Fold 3"	1800	"Galaxy Z Fold 3"
"Phone"	"Apple"	"iPhone 12 Pro Max"	1300	"Galaxy Z Fold 3"
"Phone"	"Samsung"	"Galaxy Note 20"	1200	"Galaxy Z Fold 3"
"Phone"	"Apple"	"iPhone 12 Pro"	1100	"Galaxy Z Fold 3"
"Phone"	"Apple"	"iPhone 12"	1000	"Galaxy Z Fold 3"
"Phone"	"Samsung"	"Galaxy S21"	1000	"Galaxy Z Fold 3"
"Phone"	"Samsung"	"Galaxy Z Flip 3"	1000	"Galaxy Z Fold 3"
"Phone"	"OnePlus"	"OnePlus 9"	800	"Galaxy Z Fold 3"
"Phone"	"Google"	"Pixel 5"	600	"Galaxy Z Fold 3"
"Phone"	"OnePlus"	"OnePlus Nord"	300	"Galaxy Z Fold 3"
"Smartwatch"	"Apple"	"Apple Watch Series 6"	1000	"Apple Watch Series 6"
"Smartwatch"	"Samsung"	"Galaxy Watch 4"	600	"Apple Watch Series 6"
"Smartwatch"	"Apple"	"Apple Watch SE"	400	"Apple Watch Series 6"
"Smartwatch"	"OnePlus"	"OnePlus Watch"	220	"Apple Watch Series 6"


-- LAST_VALUE 
-- Write query to display the least expensive product under each category (corresponding to each record)
select *,
first_value(product_name) 
    over(partition by product_category order by price desc) 
    as most_exp_product,
last_value(product_name) 
    over(partition by product_category order by price desc
        range between unbounded preceding and unbounded following) 
    as least_exp_product    
from product
WHERE product_category ='Phone';


"product_category"	"brand"	"product_name"	"price"	"most_exp_product"	"least_exp_product"
"Earphone"	"Apple"	"AirPods Pro"	280	"AirPods Pro"	"Galaxy Buds Live"
"Earphone"	"Sony"	"WF-1000XM4"	250	"AirPods Pro"	"Galaxy Buds Live"
"Earphone"	"Samsung"	"Galaxy Buds Pro"	220	"AirPods Pro"	"Galaxy Buds Live"
"Earphone"	"Samsung"	"Galaxy Buds Live"	170	"AirPods Pro"	"Galaxy Buds Live"
"Headphone"	"Apple"	"AirPods Max"	550	"AirPods Max"	"Surface Headphones 2"
"Headphone"	"Sony"	"WH-1000XM4"	400	"AirPods Max"	"Surface Headphones 2"
"Headphone"	"Microsoft"	"Surface Headphones 2"	250	"AirPods Max"	"Surface Headphones 2"
"Laptop"	"Dell"	"XPS 17"	2500	"XPS 17"	"MacBook Air"
"Laptop"	"Dell"	"XPS 15"	2300	"XPS 17"	"MacBook Air"
"Laptop"	"Microsoft"	"Surface Laptop 4"	2100	"XPS 17"	"MacBook Air"
"Laptop"	"Apple"	"MacBook Pro 13"	2000	"XPS 17"	"MacBook Air"
"Laptop"	"Dell"	"XPS 13"	2000	"XPS 17"	"MacBook Air"
"Laptop"	"Apple"	"MacBook Air"	1200	"XPS 17"	"MacBook Air"
"Phone"	"Samsung"	"Galaxy Z Fold 3"	1800	"Galaxy Z Fold 3"	"OnePlus Nord"
"Phone"	"Apple"	"iPhone 12 Pro Max"	1300	"Galaxy Z Fold 3"	"OnePlus Nord"
"Phone"	"Samsung"	"Galaxy Note 20"	1200	"Galaxy Z Fold 3"	"OnePlus Nord"
"Phone"	"Apple"	"iPhone 12 Pro"	1100	"Galaxy Z Fold 3"	"OnePlus Nord"
"Phone"	"Apple"	"iPhone 12"	1000	"Galaxy Z Fold 3"	"OnePlus Nord"
"Phone"	"Samsung"	"Galaxy S21"	1000	"Galaxy Z Fold 3"	"OnePlus Nord"
"Phone"	"Samsung"	"Galaxy Z Flip 3"	1000	"Galaxy Z Fold 3"	"OnePlus Nord"
"Phone"	"OnePlus"	"OnePlus 9"	800	"Galaxy Z Fold 3"	"OnePlus Nord"
"Phone"	"Google"	"Pixel 5"	600	"Galaxy Z Fold 3"	"OnePlus Nord"
"Phone"	"OnePlus"	"OnePlus Nord"	300	"Galaxy Z Fold 3"	"OnePlus Nord"
"Smartwatch"	"Apple"	"Apple Watch Series 6"	1000	"Apple Watch Series 6"	"OnePlus Watch"
"Smartwatch"	"Samsung"	"Galaxy Watch 4"	600	"Apple Watch Series 6"	"OnePlus Watch"
"Smartwatch"	"Apple"	"Apple Watch SE"	400	"Apple Watch Series 6"	"OnePlus Watch"
"Smartwatch"	"OnePlus"	"OnePlus Watch"	220	"Apple Watch Series 6"	"OnePlus Watch"


-- Alternate way to write SQL query using Window functions
select *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product    
from product
WHERE product_category ='Phone'
window w as (partition by product_category order by price desc
            range between unbounded preceding and unbounded following);
            

            
-- NTH_VALUE 
-- Write query to display the Second most expensive product under each category.
select *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product,
nth_value(product_name, 2) over w as second_most_exp_product
from product
window w as (partition by product_category order by price desc
            range between unbounded preceding and unbounded following);

"product_category"	"brand"	"product_name"	"price"	"most_exp_product"	"least_exp_product"	"second_most_exp_product"
"Earphone"	"Apple"	"AirPods Pro"	280	"AirPods Pro"	"Galaxy Buds Live"	"WF-1000XM4"
"Earphone"	"Sony"	"WF-1000XM4"	250	"AirPods Pro"	"Galaxy Buds Live"	"WF-1000XM4"
"Earphone"	"Samsung"	"Galaxy Buds Pro"	220	"AirPods Pro"	"Galaxy Buds Live"	"WF-1000XM4"
"Earphone"	"Samsung"	"Galaxy Buds Live"	170	"AirPods Pro"	"Galaxy Buds Live"	"WF-1000XM4"
"Headphone"	"Apple"	"AirPods Max"	550	"AirPods Max"	"Surface Headphones 2"	"WH-1000XM4"
"Headphone"	"Sony"	"WH-1000XM4"	400	"AirPods Max"	"Surface Headphones 2"	"WH-1000XM4"
"Headphone"	"Microsoft"	"Surface Headphones 2"	250	"AirPods Max"	"Surface Headphones 2"	"WH-1000XM4"
"Laptop"	"Dell"	"XPS 17"	2500	"XPS 17"	"MacBook Air"	"XPS 15"
"Laptop"	"Dell"	"XPS 15"	2300	"XPS 17"	"MacBook Air"	"XPS 15"
"Laptop"	"Microsoft"	"Surface Laptop 4"	2100	"XPS 17"	"MacBook Air"	"XPS 15"
"Laptop"	"Apple"	"MacBook Pro 13"	2000	"XPS 17"	"MacBook Air"	"XPS 15"
"Laptop"	"Dell"	"XPS 13"	2000	"XPS 17"	"MacBook Air"	"XPS 15"
"Laptop"	"Apple"	"MacBook Air"	1200	"XPS 17"	"MacBook Air"	"XPS 15"
"Phone"	"Samsung"	"Galaxy Z Fold 3"	1800	"Galaxy Z Fold 3"	"OnePlus Nord"	"iPhone 12 Pro Max"
"Phone"	"Apple"	"iPhone 12 Pro Max"	1300	"Galaxy Z Fold 3"	"OnePlus Nord"	"iPhone 12 Pro Max"
"Phone"	"Samsung"	"Galaxy Note 20"	1200	"Galaxy Z Fold 3"	"OnePlus Nord"	"iPhone 12 Pro Max"
"Phone"	"Apple"	"iPhone 12 Pro"	1100	"Galaxy Z Fold 3"	"OnePlus Nord"	"iPhone 12 Pro Max"
"Phone"	"Apple"	"iPhone 12"	1000	"Galaxy Z Fold 3"	"OnePlus Nord"	"iPhone 12 Pro Max"
"Phone"	"Samsung"	"Galaxy S21"	1000	"Galaxy Z Fold 3"	"OnePlus Nord"	"iPhone 12 Pro Max"
"Phone"	"Samsung"	"Galaxy Z Flip 3"	1000	"Galaxy Z Fold 3"	"OnePlus Nord"	"iPhone 12 Pro Max"
"Phone"	"OnePlus"	"OnePlus 9"	800	"Galaxy Z Fold 3"	"OnePlus Nord"	"iPhone 12 Pro Max"
"Phone"	"Google"	"Pixel 5"	600	"Galaxy Z Fold 3"	"OnePlus Nord"	"iPhone 12 Pro Max"
"Phone"	"OnePlus"	"OnePlus Nord"	300	"Galaxy Z Fold 3"	"OnePlus Nord"	"iPhone 12 Pro Max"
"Smartwatch"	"Apple"	"Apple Watch Series 6"	1000	"Apple Watch Series 6"	"OnePlus Watch"	"Galaxy Watch 4"
"Smartwatch"	"Samsung"	"Galaxy Watch 4"	600	"Apple Watch Series 6"	"OnePlus Watch"	"Galaxy Watch 4"
"Smartwatch"	"Apple"	"Apple Watch SE"	400	"Apple Watch Series 6"	"OnePlus Watch"	"Galaxy Watch 4"
"Smartwatch"	"OnePlus"	"OnePlus Watch"	220	"Apple Watch Series 6"	"OnePlus Watch"	"Galaxy Watch 4"

-- NTILE
-- Write a query to segregate all the expensive phones, mid range phones and the cheaper phones.
select x.product_name, 
case when x.buckets = 1 then 'Expensive Phones'
     when x.buckets = 2 then 'Mid Range Phones'
     when x.buckets = 3 then 'Cheaper Phones' END as Phone_Category
from (
    select *,
    ntile(3) over (order by price desc) as buckets
    from product
    where product_category = 'Phone') x;


"product_name"	"phone_category"
"Galaxy Z Fold 3"	"Expensive Phones"
"iPhone 12 Pro Max"	"Expensive Phones"
"Galaxy Note 20"	"Expensive Phones"
"iPhone 12 Pro"	"Expensive Phones"
"Galaxy Z Flip 3"	"Mid Range Phones"
"iPhone 12"	"Mid Range Phones"
"Galaxy S21"	"Mid Range Phones"
"OnePlus 9"	"Cheaper Phones"
"Pixel 5"	"Cheaper Phones"
"OnePlus Nord"	"Cheaper Phones"


-- CUME_DIST (cumulative distribution) ; 
/*  Formula = Current Row no (or Row No with value same as current row) / Total no of rows */

-- Query to fetch all products which are constituting the first 30% 
-- of the data in products table based on price.
select product_name, cume_dist_percetage
from (
    select *,
    cume_dist() over (order by price desc) as cume_distribution,
    round(cume_dist() over (order by price desc)::numeric * 100,2)||'%' as cume_dist_percetage
    from product) x
where x.cume_distribution <= 0.3;


"product_name"	"cume_dist_percetage"
"XPS 17"	"3.70%"
"XPS 15"	"7.41%"
"Surface Laptop 4"	"11.11%"
"MacBook Pro 13"	"18.52%"
"XPS 13"	"18.52%"
"Galaxy Z Fold 3"	"22.22%"
"iPhone 12 Pro Max"	"25.93%"


-- PERCENT_RANK (relative rank of the current row / Percentage Ranking)
/* Formula = Current Row No - 1 / Total no of rows - 1 */

-- Query to identify how much percentage more expensive is "Galaxy Z Fold 3" when compared to all products.
select product_name, per
from (
    select *,
    percent_rank() over(order by price) ,
    round(percent_rank() over(order by price)::numeric * 100, 2) as per
    from product) x
where x.product_name='Galaxy Z Fold 3';

"product_name"	"per"
"Galaxy Z Fold 3"	80.77