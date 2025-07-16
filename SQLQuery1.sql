
--Use database 
use  sql_sales_project1

--See the data of the table
select top 10 * from retail_sales1

--Know count of the tables row
select count(*) from retail_sales1

--Identifaing Nulls
select * from retail_sales1
where transactions_id is null

select * from retail_sales1
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or 
	gender is null
	or
	age is null
	or 
	category is null
	or 
	quantiy is null
	or 
	price_per_unit is null
	or 
	cogs is null
	or 
	total_sale is null


-- Deleting database duplicate
Delete  from retail_sales1
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or 
	gender is null
	or
	age is null
	or 
	category is null
	or 
	quantiy is null
	or 
	price_per_unit is null
	or 
	cogs is null
	or 
	total_sale is null

--How many customers now?
select count(*) from retail_sales1

--How many unique customer we have?
select count(distinct customer_id) as unique_cust from retail_sales1

--How many unique category in dataset?
select distinct category from retail_sales1

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
 select * 
 from retail_sales1
 where sale_date = '2022-11-05';

 -- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
 select * 
 from retail_sales1
where category = 'CLothing' 
	and 
	quantiy > 3
	and 
	sale_date >= '2022-11-01'
	and 
	sale_date < '2022-12-01';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select 
category, sum(total_sale) as Total_sales, COUNT(*) as Total_Orders 
from retail_sales1
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
Select 
avg(age) as Average_Age 
from retail_sales1
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales1
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
category, gender, count(transactions_id) as Total_Transaction
from retail_sales1
group by category, gender

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
    YEAR(sale_date) AS SalesYear,
    MONTH(sale_date) AS SalesMonth,
    COUNT(*) AS TotalSales,
    SUM(total_sale) AS TotalAmount
FROM retail_sales1
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY SalesYear, SalesMonth;

--By months
with MonthlySales as (
	SELECT
		YEAR(sale_date) AS SalesYear,
		MONTH(sale_date) AS SalesMonth,
		COUNT(*) AS TotalSales,
		SUM(total_sale) AS TotalAmount,
		row_number() over(partition by year(sale_date) order by sum(total_sale) desc) as rk
	FROM retail_sales1
	GROUP BY YEAR(sale_date), MONTH(sale_date)
)

select salesYear, SalesMonth, TotalSales, TotalAmount from MonthlySales
where rk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select top 5 
customer_id, sum(total_sale) AS Total_Purchase
from retail_sales1
group by customer_id
order by sum(total_sale) desc

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales1
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hour_shift as
(	
select *,
case
	when datepart(Hour,sale_time) <=12 then 'Morning'
	when datepart(hour,sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening' 
	end as time_shift
from retail_sales1
)

select 
time_shift, count(*) as No_ofOrders
from hour_shift
group by time_shift

--End of Project