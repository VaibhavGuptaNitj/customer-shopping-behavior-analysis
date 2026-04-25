-- Q1. What is the total revenue genrated by male vs. female customers?

select gender, sum(purchase_amount) as Revenue from customer 
group by gender

-- Q2. Which customer used a discount but still spent more than the average purchase amount? 

select customer_id,purchase_amount from customer where ((purchase_amount >= (select avg(purchase_amount) from customer))  and discount_applied ='Yes')

-- Q3. Which are the top 5 products with the highest average review rating?

select item_purchased, round(avg(review_rating),2) as 'Average Product Rating' from customer 
group by item_purchased
order by avg(review_rating) desc limit 5


-- Q4.  Compare the average Purchase Amounts between Standard and Express Shipping. 

select shipping_type, round(avg(purchase_amount),2) from customer 
where shipping_type = 'Express' or shipping_type ='Standard'
group by shipping_type


-- Q5. Do subscribed customers spend more? Compare average spend and total revenue 

select subscription_status,count(customer_id) as total_customers, avg(purchase_amount) as avg_spend, sum(purchase_amount) as total_revenue from customer 
group by subscription_status
order by total_revenue, avg_spend

-- Q6. Which 5 products have the highest percentage of purchases with discounts applied?
-- -- number of previous purchases, and show the count of each segment.

select item_purchased, sum(case when discount_applied ='Yes' then 1 else 0 end)*100/ count(*) as discount_rate from customer 
group by item_purchased
order by discount_rate desc
limit 5

-- Q7. Segment customers into New, Returning, and Loyal based on their total?
-- -- number of previous purchases, and show the count of each segment.
with cte as (
select customer_id, previous_purchases,
case 
when previous_purchases = 1 then 'New'
when previous_purchases >= 2 and previous_purchases <=10 then 'Returning'
else 'Loyal'
end as customer_segment
from customer)

select customer_segment, count(*) from cte
group by customer_segment


-- Q8. What are the top 3 most purchased products within each category? 

select * from (select category,item_purchased, count(customer_id) as num, dense_rank() over(partition by category order by count(customer_id) desc) as rnk from customer 
group by category, item_purchased) t 
where t.rnk <=3


-- Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?

select subscription_status,count(customer_id) as repeat_buyers from customer
where previous_purchases>5
group by  subscription_status


-- Q10. What is the revenue contribution of each age group?

select age_group,sum(purchase_amount) as total_revenue from customer
group by age_group
order by total_revenue desc

