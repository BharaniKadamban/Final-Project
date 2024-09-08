--Basic Select Query:

select c.*,o.order_id from customers c inner join orders o
on c.customer_id = o.customer_id
order by c.customer_id;

--Aggregate Functions:

with cte as 
(select o.store_id as store_id,i.quantity,i.list_price,(i.quantity*i.list_price) as total_Sales 
from orders o inner join order_items i
on o.order_id = i.order_id)
select store_id as store_id, round(sum(total_Sales),2)  from cte group by store_id;

--Subqueries:

select product_id from products where product_id not in  (select distinct product_id from order_items) order by product_id;

--Joins:

select s2.first_name,s2.last_name,s2.email,s2.manager_id,s1.first_name,s1.last_name from staffs s1 join staffs s2
on s1.staff_id = s2.manager_id order by s1.staff_id;

--Windows

with cte as (select o.store_id as store_id,i.quantity,i.list_price,(i.quantity*i.list_price) as total_Sales from orders o inner join order_items i
on o.order_id = i.order_id),
v1 as (select store_id as store_id, round(sum(total_Sales),2) as total_Sales from cte group by store_id)
select store_id,total_Sales,dense_rank() over(order by total_Sales desc) as rk from v1;

--Date Function

select *,datediff(shipped_date,order_date) as diff from orders;

--Case Statement

select *,
case 
when order_status = 1 then 'Success'
when order_status = 2 then 'Failed'
when order_status = 3 then 'Processing' 
else 'Return' end as Status from orders;
			  

--Complex Joins

select i.order_id,p.product_id,p.product_name from orders o 
join order_items i 
join products p
where o.order_id = i.order_id 
and  i.product_id = p.product_id
order by p.product_id,o.order_id;


--CTE

with cte as (select product_id,sum(quantity*(list_price-discount)) as total_price from order_items
group by product_id)
select p.* from cte c join products p 
on c.product_id = p.product_id;