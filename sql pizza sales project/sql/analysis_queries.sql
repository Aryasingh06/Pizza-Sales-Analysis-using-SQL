 USE pizzahut;
 
 -- Data verification
 SELECT * From orders;
 SELECT * FROM pizza_types;
 SELECT * FROM pizzas;
 SELECT * FROM order_details;
 
 -- QUERIES
 -- ORDER ANALYSIS
 
-- SELECT TOTAL NUMBER OF ORDERS PLACED?
SELECT COUNT(order_id) as total_order FROM ORDERS; 

-- IDENTIFY THE MOST COMMON PIZZA SIZE ORDERED
SELECT  pizzas.size,COUNT(order_details.order_details_id) AS order_count
FROM pizzas join
order_details on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size ORDER BY order_count DESC;

-- REVENUE ANALYSIS 
-- calculate the total revenue generated from pizza sales
select round(sum(order_details.quantity * pizzas.price),2) as total_sales
from 
order_details JOIN pizzas on  pizzas.pizza_id = order_details.pizza_id;

-- identity the highest-priced pizza
select pizza_types.name, pizzas.price
from pizza_types join pizzas on  pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;

-- Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category,round(sum(order_details.quantity * pizzas.price) / (SELECT 
ROUND(SUM(order_details.quantity*pizzas.price),2)AS total_sales FROM order_details JOIN
pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,2) as revenue
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id group by pizza_types.category 
order by revenue desc;

-- Analyze the cumulative revenue generated over time.
select order_date,sum(revenue) over(order by order_date) as cum_revenue from
(select orders.order_date,sum(order_details.quantity * pizzas.price) as revenue 
from order_details join pizzas on order_details.pizza_id = pizzas.pizza_id 
join orders on orders.order_id = order_details.order_id 
group by orders.order_date) as sales;

-- PRODUCT ANALYSIS
-- identity the highest-priced pizza
select pizza_types.name, pizzas.price
from pizza_types join pizzas on  pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;

-- List the top 5 most ordered pizza types along with their quantities
select pizza_types.name,SUM(order_details.quantity) AS total_quantity from pizza_types join pizzas 
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id 
GROUP BY pizza_types.name ORDER BY total_quantity DESC LIMIT 5;

-- CATEGORY ANALYSIs
-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pizza_types.category,SUM(order_details.quantity) as quantity 
FROM pizza_types JOIN pizzas 
ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
JOIN order_details 
ON order_details.pizza_id = pizzas.pizza_id 
GROUP BY pizza_types.category ORDER BY quantity DESC;

-- Number of pizza types available in each category.
select category, count(name) as total_pizza_types from pizza_types group by category
order by total_pizza_types DESC;

-- Determine the top 3 most ordered pizza types based on revenue
select pizza_types.name,sum(order_details.quantity * pizzas.price) as revenue 
from pizza_types join pizzas 
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;

-- TIME BASED ANALYSIS 
-- Group the orders by date and calculate the average number of pizzas ordered per day.
select  ROUND(Avg(quantity),0) as avg_pizza_ordered_per_day from 
(select orders.order_date, sum(order_details.quantity) 
as quantity from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) As order_quantity ;

-- Determine the distribution of orders by hour of the day
SELECT HOUR(order_time) as hour , COUNT(order_id) as order_count from orders
group by HOUR(order_time);

-- Business Analysis 
-- Which pizza size generated the highest revenue
SELECT p.size,ROUND(SUM(od.quantity * p.price),2) AS revenue
FROM pizzas p
JOIN order_details od
ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY revenue DESC;

-- Which day of the week generated the highest revenue?
SELECT DAYNAME(o.order_date) AS day_name,
ROUND(SUM(od.quantity * p.price),2) AS revenue
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
JOIN pizzas p
ON od.pizza_id = p.pizza_id
GROUP BY day_name
ORDER BY revenue DESC;

-- Which month generated the highest revenue?
SELECT MONTHNAME(o.order_date) AS month_name,
ROUND(SUM(od.quantity * p.price),2) AS revenue
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
JOIN pizzas p
ON od.pizza_id = p.pizza_id
GROUP BY month_name
ORDER BY revenue DESC;

-- Average revenue per order
SELECT ROUND(SUM(od.quantity * p.price) /
COUNT(DISTINCT o.order_id),2) AS average_order_value
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
JOIN pizzas p
ON od.pizza_id = p.pizza_id;

-- Bottom 5 revenue-generating pizzas
SELECT pt.name,
ROUND(SUM(od.quantity * p.price),2) AS revenue
FROM pizza_types pt
JOIN pizzas p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od
ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY revenue ASC
LIMIT 5;