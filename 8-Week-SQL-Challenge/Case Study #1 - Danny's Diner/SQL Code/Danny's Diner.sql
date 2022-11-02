-- 1. What is the total amount each customer spent at the restaurant?

SELECT customer_id , 
       SUM(price) as total

FROM dannys_diner.sales s 
JOIN dannys_diner.menu m 
ON s.product_id = m.product_id 
GROUP BY customer_id
ORDER BY total DESC;

-- 2. How many days has each customer visited the restaurant?

SELECT customer_id , 
       COUNT(DISTINCT order_date) AS num_days
       
FROM dannys_diner.sales as s  
GROUP BY customer_id ;

-- 3. What was the first item from the menu purchased by each customer?

WITH CTE
AS
(
SELECT customer_id,
  	   s.product_id,
       product_name,
       RANK() OVER(PARTITION BY customer_id 
                        ORDER BY order_date) as RN
                    
FROM dannys_diner.sales as s 
JOIN dannys_diner.menu  as m 
ON s.product_id = m.product_id 
)

SELECT  DISTINCT customer_id , product_name 
FROM CTE
WHERE RN = 1;


-- 4 What is the most purchased item on the menu and how many times
 --was it purchased by all customers?

SELECT TOP 1 product_name,
       COUNT(*) AS total_purchased
       
FROM dannys_diner.menu  m 
JOIN dannys_diner.sales s 
ON m.product_id = s.product_id
GROUP BY product_name 
ORDER BY total_purchased DESC;

--5 Which item was the most popular for each customer?

WITH CTE 
AS(
SELECT  customer_id,
	product_name,
        COUNT(*) as total
FROM dannys_diner.sales s 
JOIN dannys_diner.menu  m
ON s.product_id = m.product_id

GROUP BY customer_id, product_name
),
CTE2
AS(

SELECT customer_id,
       product_name,
       total,
       RANK() OVER(PARTITION BY customer_id ORDER BY total DESC) AS rk
     
FROM CTE 
)

SELECT customer_id,
       product_name,
       total
FROM CTE2
WHERE rk = 1;


--6 Which item was purchased first by the customer after they became a member?

WITH CTE 
AS(
SELECT s.customer_id,
       s.product_id,
       product_name,
       s.order_date,
       RANK() OVER(PARTITION BY s.customer_id 
                   ORDER BY s.order_date) as rk
       
FROM dannys_diner.sales s 
JOIN dannys_diner.menu  m
ON s.product_id = m.product_id 
JOIN dannys_diner.members mb 
ON mb.customer_id = s.customer_id 

WHERE s.order_date >= mb.join_date
)

SELECT customer_id,
       product_name,
       order_date
FROM CTE
WHERE rk =1;


--7 Which item was purchased just before the customer became a member?

WITH CTE AS 
(
   SELECT s.customer_id, m.join_date, s.order_date, s.product_id,
         RANK() OVER(PARTITION BY s.customer_id
         ORDER BY s.order_date DESC) AS rank

   FROM dannys_diner.sales AS s
   JOIN dannys_diner.members AS m
      ON s.customer_id = m.customer_id

   WHERE s.order_date < m.join_date
)

SELECT s.customer_id, s.order_date, m2.product_name 
FROM CTE AS s
JOIN dannys_diner.menu AS m2
   ON s.product_id = m2.product_id
WHERE rank = 1;

-- 8 What is the total items and amount spent for each member before they became 
--a member?

SELECT s.customer_id,
	   COUNT(DISTINCT s.product_id) as num_items,
       SUM(price)        as total_amount

FROM dannys_diner.sales s 
JOIN dannys_diner.menu  m
ON s.product_id = m.product_id 
JOIN dannys_diner.members mb
ON mb.customer_id = s.customer_id 

WHERE s.order_date < mb.join_date
GROUP BY s.customer_id;


-- 9 If each $1 spent equates to 10 points and sushi has a 2x points multiplier how many points would each customer have?

SELECT s.customer_id,
       SUM(CASE 
          WHEN product_name = 'sushi' THEN price*10*2
          ELSE price*10 END) AS points
       
FROM dannys_diner.sales s 
JOIN dannys_diner.menu m
ON s.product_id = m.product_id 

GROUP BY s.customer_id  
ORDER BY s.customer_id;

-- 10 In the first week after a customer joins the program (including their join date)
-- they earn 2x points on all items, not just sushi 
--how many points do customer A and B have at the end of January?

WITH CTE 
AS(
SELECT * ,
       DATEADD(DAY , 6 , join_date) as valid_interval,
       EOMONTH('2021-01-31')        as interval_end
FROM dannys_diner.members
)

SELECT 
	  s.customer_id,
      SUM(CASE
		WHEN s.order_date BETWEEN  c.join_date AND c.valid_interval
		THEN 2*10*m.price
		WHEN m.product_name = 'sushi' THEN 2*10*m.price
		ELSE 10*m.price
		END) AS points

FROM dannys_diner.sales s 
JOIN CTE c
ON s.customer_id = c.customer_id
JOIN dannys_diner.menu m 
ON m.product_id = s.product_id
WHERE s.order_date < c.interval_end
GROUP BY s.customer_id;
