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


-- 6.Which products have been returned more than 10 times?

Select products.product_name, sum(returns.quantity) as most_return
from products join returns on products.product_id = returns.product_id
group by products.product_name
having sum(returns.quantity) >10
order by most_return desc;

-- 7. Total Sales by Customer Age Group (18-30, 31-50, > 51)?

Select customers.age_group, sum(products.product_retail_price *transactions_1997.quantity) as total_sales
from products join transactions_1997 on products.product_id = transactions_1997.product_id 
join customers on customers.customer_id = transactions_1997.customer_id 
group by customers.age_group
order by total_sales desc;

-- 8. What is the total number of customers who made purchases in each region?

Select region.sales_region, COUNT(DISTINCT transactions_1997.customer_id) as total_customers
from region
join stores on region.region_id = stores.region_id
join transactions_1997 on stores.store_id = transactions_1997.store_id
group by region.sales_region
order by total_customers DESC;


-- 9. Identify the store with the highest quantity sold in each region?
Select region.region_id,region.sales_region, stores.store_type,sum((transactions_1997.quantity)) as Quantity_sold
from region join stores on stores.region_id = region.region_id
join transactions_1997 on transactions_1997.store_id = stores.store_id
group by region.region_id,region.sales_region, stores.store_type
order by Quantity_sold desc;
 
-- 10. Analyze sales of recyclable vs. non-recyclable products. Include the quantity sold and revenue generated for each category?
 
Select CASE WHEN 
products.recyclable = 1 Then 'Recyclable' Else 'Non-Recyclable'
End as product_category, sum(transactions_1997.quantity) as Total_sold, sum(transactions_1997.quantity*products.product_retail_price) as Revenue
from transactions_1997 join products on products.product_id = transactions_1997.product_id
group by product_category;
 


