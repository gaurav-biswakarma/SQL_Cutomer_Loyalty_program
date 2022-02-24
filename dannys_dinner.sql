CREATE database dannys_diner;
USE dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 
 CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
 CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
); 

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

/*
Each of the following case study questions can be answered using a single SQL statement:
*/

--  What is the total amount each customer spent at the restaurant?

select customer_id, sum(price) as amount
from sales
join menu
on sales.product_id = menu.product_id
group by sales.customer_id;

-- How many days has each customer visited the restaurant?

select customer_id, count(order_date) as Total_no_days
from sales
group by customer_id;

-- What was the first item from the menu purchased by each customer?

select customer_id, product_name
from sales
join menu on menu.product_id = sales.product_id
group by customer_id;

-- What is the most purchased item on the menu and how many times was it purchased by all customers?

select product_name, count(*) as No_of_times_purchased
from sales
join menu on menu.product_id = sales.product_id
group by product_name
order by No_of_times_purchased desc;

-- Which item was the most popular for each customer?

select customer_id, max(product_name)
from sales
join menu on menu.product_id = sales.product_id
group by customer_id;

-- Which item was purchased first by the customer after they became a member?

select sales.customer_id, order_date, product_name
from sales
join members on sales.customer_id = members.customer_id
join menu on menu.product_id = sales.product_id 
where order_date >= join_date
group by customer_id
order by customer_id;

-- Which item was purchased just before the customer became a member?

select sales.customer_id, order_date, product_name
from sales
join members on sales.customer_id = members.customer_id
join menu on menu.product_id = sales.product_id 
where order_date < join_date
group by customer_id
order by customer_id;

-- What is the total items and amount spent for each member before they became a member?

select sales.customer_id, count(distinct sales.product_id) as unique_menu_items, sum(menu.price) total_sales
from sales
join members on sales.customer_id = members.customer_id
join menu on menu.product_id = sales.product_id
where order_date < join_date
group by customer_id;

-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier 
-- how many points would each customer have?

select customer_id, sum(points) as total_points
from sales
join(select *,
	case 
	when product_id = 1 then price * 20
	else price * 10
	end as points
	from menu) as mm on mm.product_id = sales.product_id
group by customer_id;

-- In the first week after a customer joins the program (including their join date) 
-- they earn 2x points on all items, not just sushi - how many points do customer A and B 
-- have at the end of January?

select sales.customer_id, sum(points) as total_points
from sales
join(select sales.customer_id,
	case
	when menu.product_id != 1 and sales.order_date between members.join_date and date_add(members.join_date, interval 6 day) then price * 2
	else price
	end as points
    from sales
	join members on sales.customer_id = members.customer_id
	join menu on menu.product_id = sales.product_id) as mn on mn.customer_id = sales.customer_id
    where sales.order_date < date('2021-01-31')
group by customer_id;

























  