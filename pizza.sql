


-- Retrieve the total number of orders placed.

select count(order_id) as total_orders from orders;

-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;


-- Identify the highest-priced pizza.

select pt.name,p.price from pizza_types pt join 
pizzas p on p.pizza_type_id = pt.pizza_type_id
order by p.price desc limit 1;


-- List the top 5 most ordered pizza types along with their quantities.

select pt.name,sum(od.quantity) as quantity from  pizza_types pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od
on od.pizza_id =p.pizza_id
group  by pt.name order by  sum(od.quantity) desc  limit 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pt.category,sum(od.quantity) as total_quantity from pizza_types pt join pizzas p 
on pt.pizza_type_id = p.pizza_type_id
join order_details od 
on od.pizza_id = p.pizza_id
group by pt.category order by total_quantity desc;

-- Determine the distribution of orders by hour of the day.

select hour(order_time),count(order_id) from orders
group by hour(order_time) order by hour(order_time);


-- Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name) from pizza_types 
group by category;


-- Group the orders by date and calculate the average number of pizzas ordered per day.

select round(avg(quantity)) as avg_quantity from
(select o.order_date, sum(od.quantity) as quantity from orders o join order_details od
on o.order_id = od.order_id
group by o.order_date) as order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.

select pt.name,round(sum(p.price * od.quantity)) as total_revenue
from pizzas p join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
join order_details od on p.pizza_id = od.pizza_id
group by pt.name order by sum(p.price * od.quantity) desc limit 3;


-- Calculate the percentage contribution of each pizza type to total revenue.

select pt.category,round(sum(od.quantity * p.price)/(select round(sum(od.quantity * p.price)) as total_sales from
pizzas p join order_details od on p.pizza_id = od.pizza_id)*100,2) as revenue
from pizzas p join pizza_types pt on p.pizza_type_id = pt.pizza_type_id 
join order_details od on p.pizza_id = od.pizza_id
group by pt.category;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select pt.name,pt.category,round(sum(p.price * od.quantity)) as total_revenue
from pizzas p join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
join order_details od on p.pizza_id = od.pizza_id
group by pt.category,pt.name order by sum(p.price * od.quantity) desc limit 3;
