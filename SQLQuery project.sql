--Q1 Get the number of orders placed by C_001, C_002, C_003.
--All the three customer_ids and the numbers of orders should be present in the result separately.

select customer_id , count(order_id) as order_count
from orders_data
where customer_id in('C_001','C_002','C_003')
group by customer_id

--Q2 Which customer_id has the highest spends?

SELECT top 1 customer_id,sum(amount_paid) 
from orders_data
group by customer_id

--Q3 Which product_id has been bought the most?

SELECT TOP 1 product_id,  COUNT(*) AS PURCHASES
FROM orders_data
GROUP BY product_id



--Q4 Which product_id has generated the highest revenue?

select top 1  product_id , sum(price) as revenue 
from products_data
group by product_id

--Q5 In our inventory, which product category has the lowest no of items? Which should we add more of?

select top 1 p.category,count(p.product_id) as total_items
from products_data as p
inner join orders_data as o
on p.product_id = o.product_id
group by p.category
order by total_items asc

--Q6 What is the cheapest price in each of the product category?

select top 1 category, min(price) as cheap_price
from products_data
group by category

--Q7 Month on Month count of orders & revenue

select month(order_datetimestamp) as month,
count(order_id) as total_orders,
sum(amount_paid) as total_orders
from orders_data
group by month(order_datetimestamp)
order by month

--Q8 Month on Month count of sign ups


select month(order_datetimestamp) as month,
count(created_at) as sign_ups
from user_data as u
inner join orders_data as o
on u.cusomter_id = o.customer_id
group by month(order_datetimestamp)
order by month

--Q9 Figure out who purchased the highest in each month

SELECT month(order_datetimestamp) as months,customer_id, sum(amount_paid) as spend
FROM orders_data
group by month(order_datetimestamp),customer_id
order by months desc


--Q11 Get the month with revenue more than 2100 and orders volume more than 30

select
      month(o.order_datetimestamp) as month,
      count(o.order_id) as order_count,
      sum(p.price) as revenue
from orders_data as o
inner join products_data as p
on o.product_id = p.product_id
group by month(o.order_datetimestamp)
having  sum(p.price)  > 2100
          and 
    count(order_id) > 30

--Q10 Get the list of customer_ids which has spends more than 100

select customer_id, sum(amount_paid) as spends 
from orders_data
group by customer_id
having sum(amount_paid) > 100

--Q12 Get the numbers of orders placed by each customer in month of Jan

select customer_id as cust_id,count(order_id) as order_count 
from orders_data
where month(order_datetimestamp) = 1 
group by customer_id,order_datetimestamp

--Q13 Get the name of the customer who has spent the most with us

select concat(first_name,' ',last_name) as cust_name, sum(amount_paid) as spend 
from user_data as u
inner join orders_data as o
on u.cusomter_id = o.customer_id
group by concat(first_name,' ',last_name)
order by spend desc


--Q14 Get all the users who has not purchased any orders

select u.* from 
user_data as u
left join orders_data as o
on u.cusomter_id = o.customer_id
where order_id is null


--Q15 For the customer has spent the most, figure out which product category have they spent the most

select customer_id, category, sum(amount_paid) as spend from products_data as p
inner join orders_data as o
on p.product_id = o.product_id
where customer_id in (select top 1 customer_id as cust_id--,sum(amount_paid)as spend
from orders_data
group by customer_id
order by sum(amount_paid) desc)
