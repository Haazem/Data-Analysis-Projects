#1. What is the total amount each customer spent at the restaurant?

SELECT customer_id , 
       SUM(price) as total

FROM dannys_diner.sales s 
JOIN dannys_diner.menu m 
ON s.product_id = m.product_id 

GROUP BY customer_id

ORDER BY total DESC;

