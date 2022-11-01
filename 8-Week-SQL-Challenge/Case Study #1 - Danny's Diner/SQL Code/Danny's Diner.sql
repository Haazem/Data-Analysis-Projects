--1. What is the total amount each customer spent at the restaurant?

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
GROUP BY customer_id 

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


-4 What is the most purchased item on the menu and how many times
 was it purchased by all customers?

SELECT product_name,
       COUNT(*) AS total_purchased
       
FROM dannys_diner.menu  m 
JOIN dannys_diner.sales s 
ON m.product_id = s.product_id

GROUP BY product_name 
ORDER BY total_purchased DESC
LIMIT 1;


























