use maven;  -- SALES ANALYSIS OF USA STORE USING MYSQL

-- 1.Top 3 products having max revenue ?

Select products.product_name , sum(products.product_retail_price*transactions_1997.quantity) as revenue
from products
join transactions_1997 on products.product_id = transactions_1997.product_id
group by products.product_name
order by revenue desc
limit 3;

-- 2. what are the top 3 profitable products ?

select products.product_name, sum((products.product_retail_price - products.product_cost)* transactions_1997.quantity) as Profitable_product
from products
join transactions_1997 on products.product_id = transactions_1997.product_id
group by products.product_name
order by profitable_product desc
limit 3;

-- 3. Top 3 customer who has spend maximum amount?

select customers.first_name,customers.last_name, sum(products.product_retail_price*transactions_1997.quantity) as Max
from customers join transactions_1997 on transactions_1997.customer_id =  customers.customer_id
join products on products.product_id =  transactions_1997.product_id
group by customers.first_name,customers.last_name
order by max desc
limit 3;

-- 4. Top 3 stores with maximum profit?

select stores.store_type,stores.store_name, sum((products.product_retail_price - products.product_cost)*transactions_1997.quantity) as Max_profit
from stores join transactions_1997 on stores.store_id = transactions_1997.store_id 
join products on products.product_id = transactions_1997.product_id
group by stores.store_type,stores.store_name
order by max_profit desc
limit 3;

-- 5. customers who never purchased anything?

select concat (customers.first_name, " ",customers.last_name)as Customer_name ,transactions_1997.customer_id
from customers 
Left join transactions_1997 on customers.customer_id = transactions_1997.customer_id where transactions_1997.customer_id is null;

select customers.customer_id, concat(first_name, " ", last_name) as full_name from customers
where customer_id NOT IN(select customer_id from transactions_1997);


-- 6. Most returned products (more than 10)?

Select products.product_name, sum(returns.quantity) as most_return
from products join returns on products.product_id = returns.product_id
group by products.product_name
having sum(returns.quantity) >10
order by most_return desc;

-- 7. sales age group(18-30,31-50,>51) ?

select 
case
when 1997-year(birthdate) between 10 and 30 then "Young"
when 1997-year(birthdate) between 31 and 50 then "Adult"
when 1997-year(birthdate) > 50 then "Old" 
else 'unknown'
end 
As Age_group1,(sum(products.product_retail_price * transactions_1997.quantity)) as Sales
from customers
join transactions_1997 on transactions_1997.customer_id = customers.customer_id
join products on products.product_id = transactions_1997.product_id
group by Age_group1
order by sales desc;

-- 8. Most popular products among age groups top 5?

with sales as (Select products.product_name, customers.age_group, 
sum(products.product_retail_price*transactions_1997.quantity) as total_sum,
row_number() over(partition by customers.age_group order by sum(products.product_retail_price*transactions_1997.quantity) desc) as row_num
from products join transactions_1997 on products.product_id = transactions_1997.product_id
join customers on customers.customer_id = transactions_1997.customer_id
group by products.product_name,customers.age_group order by total_sum desc)
select* from sales where row_num <=5 order by total_sum desc;

 
-- 9. Top 5 highest salary person product perference?

select products.product_name, concat(first_name,last_name) as full_name, customers.member_card, max(customers.avg_salary) as Max_salary
from customers
join transactions_1997 on transactions_1997.customer_id = customers.customer_id 
join products on products.product_id = transactions_1997.product_id
group by  products.product_name,Full_name, customers.member_card
order by max_salary desc
limit 5;

-- 10. Region wise store that has most quanity sold?
Select region.region_id,region.sales_region, stores.store_country,sum((transactions_1997.quantity)) as Quantity_sold
from region join stores on stores.region_id = region.region_id
join transactions_1997 on transactions_1997.store_id = stores.store_id
group by region.region_id,region.sales_region, stores.store_country
order by Quantity_sold desc;
 
-- 11. Male and female with highest and lowest salary and there card preference?
 
with salary_card_prefer as (
select concat(first_name,' ',last_name) as full_name, avg_salary,
row_number() over (partition by gender order by Avg_Salary desc) as prefer,
gender, member_card from customers) 
select * from salary_card_prefer
where prefer <= 5;
 
 
