postgress
----------------
select hotel, round(avg(rating) over (partition by hotel order by year 
								range between unbounded preceding and current row ),2 )
								
range between unbounded preceding and current row
----------------------------------------------------
								
								