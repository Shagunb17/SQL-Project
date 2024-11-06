-- SALES ANALYSIS USING MYSQL (Year 1997)


-- 1.Top 3 products having max revenue ?

Select products.product_name , sum(products.product_retail_price*transactions_1997.quantity) as Revenue
from products
join transactions_1997 on products.product_id = transactions_1997.product_id
group by products.product_name
order by Revenue desc
limit 3;

-- 2. what are the top 3 profitable products ?

select products.product_name, sum((products.product_retail_price - products.product_cost)* transactions_1997.quantity) as Profitable_product
from products
join transactions_1997 on products.product_id = transactions_1997.product_id
group by products.product_name
order by profitable_product desc
limit 3;

-- 3. Top 5 customer who has spend maximum amount?

select concat(customers.first_name,' ',customers.last_name) Full_name, sum(products.product_retail_price*transactions_1997.quantity) as Max_amount_spend
from customers 
join transactions_1997 on transactions_1997.customer_id =  customers.customer_id
join products on products.product_id =  transactions_1997.product_id
group by Full_name
order by max_amount_spend desc
limit 5;

-- 4. Top 3 stores with maximum profit?

select stores.store_type,stores.store_name, sum((products.product_retail_price - products.product_cost)*transactions_1997.quantity) as Max_profit
from stores 
join transactions_1997 on stores.store_id = transactions_1997.store_id 
join products on products.product_id = transactions_1997.product_id
group by stores.store_type,stores.store_name
order by max_profit desc
limit 3;

-- 5. customers who never purchased anything?

select customers.customer_id, concat(first_name, " ", last_name) as full_name from customers
where customer_id NOT IN(select customer_id from transactions_1997);


select c.customer_id from customers c left join transactions_1997 t1 on c.customer_id = t1.customer_id
where t1.customer_id is null
group by c.customer_id;



-- 6. Most returned products (more than 10)?

Select products.product_name, sum(returns.quantity) as most_return
from products 
join returns on products.product_id = returns.product_id
group by products.product_name
having sum(returns.quantity) > 10
order by most_return desc;






-- 7. Customer who purchased 3 months ago but not purchasing now
select max(transaction_date) from transactions_1997; 


select t.customer_id ,c.first_name,t.transaction_date from transactions_1997 t join customers c on t.customer_id = c.customer_id  where 
t.customer_id not in
(select customer_id from transactions_1997 t
where datediff('1997-12-30',transaction_date)<=90
group by customer_id)
group by customer_id,transaction_date
order by transaction_date desc;
 
-- 7. sales by age group(18-30,31-50,>51) ?

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

-- 8.Top 5 Most popular products among age groups?

WITH age_grouped_customers AS (
    SELECT 
        customer_id,
        CASE
            WHEN 1997 - YEAR(birthdate) BETWEEN 10 AND 30 THEN 'Young'
            WHEN 1997 - YEAR(birthdate) BETWEEN 31 AND 50 THEN 'Adult'
            WHEN 1997 - YEAR(birthdate) > 50 THEN 'Old'
            ELSE 'Unknown'
        END AS age_group
    FROM customers
),
sales AS (
    SELECT 
        p.product_name,
        c.age_group,
        SUM(p.product_retail_price * t.quantity) AS total_sum,
        ROW_NUMBER() OVER (PARTITION BY c.age_group ORDER BY SUM(p.product_retail_price * t.quantity) DESC) AS row_num
    FROM products p
    JOIN transactions_1997 t ON p.product_id = t.product_id
    JOIN age_grouped_customers c ON c.customer_id = t.customer_id
    GROUP BY p.product_name, c.age_group
)

SELECT *
FROM sales
WHERE row_num <= 5
ORDER BY age_group, total_sum DESC;
 


-- 9. Sales by Region-district by store type and products?
select region.sales_region, stores.store_type,products.product_name, sum(products.product_retail_price * transactions_1997.quantity) Sales from region
join stores on stores.region_id = region.region_id
join transactions_1997 on stores.store_id = transactions_1997.store_id
join products on transactions_1997.product_id = products.product_id
group by region.sales_region,products.product_name, stores.store_type,products.product_name
order by Sales desc;




-- 10. Region wise store that  sold max quantity?
select region.region_id,region.sales_region,stores.store_type,(sum(transactions_1997.quantity)) qn from region
join stores on stores.region_id = region.region_id
join transactions_1997 on transactions_1997.store_id = stores.store_id
group by region.region_id, region.sales_region, stores.store_type
order by qn desc;
 
