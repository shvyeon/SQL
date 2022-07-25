-- We (Juhee Lee, Seonhye Hyeon) declare that the attached assignment is our own work in 
--accordance with the Seneca Academic Policy.  
--No part of this assignment has been copied manually or electronically from any other source
--(including web sites) or distributed to other students.
-- ***********************
-- Name: Juhee Lee
-- ID: 128261203
-- Name: Seonhye Hyeon
-- ID: 125635193
-- Date: September 27, 2021
-- Purpose: Lab 2 DBS311
-- ***********************

-- Question 1 --
-- For each job title display the number of employees. 

-- Q1 SOLUTION --
-- updated query version--
SELECT job_id, COUNT(*) "EmployeeNum"
FROM employees 
GROUP BY job_id; 

-- non - updated query version--
-- SELECT job_title, COUNT(job_title) as "Employee Num"
-- FROM employees 
-- GROUP BY job_title; 


-- Question 2 --
-- Display the Highest, Lowest and Average customer credit limits.
-- Name these results High, Low and Avg. Add a column that shows the difference between the highest and lowest credit limits.
-- Use the round function to display two digits after the decimal point.

-- Q2 SOLUTION --
SELECT MAX(credit_limit) AS "High", MIN(credit_limit) AS "Low", ROUND(AVG(credit_limit),2) AS "Average", (MAX(credit_limit)-MIN(credit_limit)) AS "High and Low Difference" 
FROM customers;


-- Question 3 --
-- Display the order id and the total order amount for orders with the total amount over $1000,000. 

-- Q3 SOLUTION --
SELECT o.order_id, SUM(oi.quantity * oi.unit_price) "TotalAmount" 
FROM orders o LEFT JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id
HAVING SUM(oi.quantity * oi.unit_price) > 1000000
ORDER BY o.order_id;


-- Question 4 --
-- Display the warehouse id, warehouse name, and the total number of products for each warehouse. 

-- Q4 SOLUTION --
SELECT w.warehouse_id, w.warehouse_name, SUM(i.quantity) "TotalProducts"
FROM warehouses w LEFT JOIN inventories i
ON w.warehouse_id = i.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name
ORDER BY warehouse_id;


-- Question 5 --
-- For each customer display the number of orders issued by the customer. If the customer does not have any orders, the result show display 0.

-- Q5 SOLUTION --
SELECT c.customer_id, c.name, NVL(SUM(oi.quantity),0) AS "Total Orders" 
FROM (customers c LEFT JOIN orders o 
ON c.customer_id = o.customer_id)
LEFT JOIN order_items oi 
ON o.order_id = oi.order_id 
GROUP BY c.customer_id, c.name
ORDER BY customer_id;


-- Question 6 --
-- Write a SQL query to show the total and the average sale amount for each category

-- Q6 SOLUTION --
SELECT p.category_id, SUM(oi.quantity * oi.unit_price) AS "Total Amount", ROUND(AVG( oi.quantity * oi.unit_price),3 )AS "Average amount" 
FROM order_items oi LEFT JOIN products p 
ON oi.product_id = p.product_id 
GROUP BY p.category_id ;



