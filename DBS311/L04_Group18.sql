-- We (Juhee Lee, Seonhye Hyeon) declare that the attached assignment is our own work in 
--accordance with the Seneca Academic Policy.  
--No part of this assignment has been copied manually or electronically from any other source
--(including web sites) or distributed to other students.
-- ***********************
-- Name: Juhee Lee
-- ID: 128261203
-- Name: Seonhye Hyeon
-- ID: 125635193
-- Date: October 12, 2021
-- Purpose: Lab 4 DBS311
-- ***********************

-- Question 1 --
-- 1.	The HR department needs a list of Department IDs for departments that 
-- do not contain the job ID of ST_CLERK> Use a set operator to create this report.

-- Q1 SOLUTION --
-- 20 rows  -> 13 rows
SELECT department_id, job_id
FROM employees
MINUS
SELECT department_id, job_id
FROM employees
WHERE job_id IN 'ST CLERK'
ORDER BY department_id;

-- Question 2 --
-- Display cities that no warehouse is located in them. 
-- (Use set operators to answer this question)

-- Q2 SOLUTION --
SELECT city
FROM locations
MINUS
SELECT l.city
FROM locations l, warehouses w
WHERE l.location_id = w.location_id;


-- Question 3 --
-- Display the category ID, category name, and the number of products in category 
-- 1, 2, and 5. In your result, display first the number of products in category 5, 
-- then category 1 and then 2.

-- Q3 SOLUTION --

SELECT pc.category_id, pc.category_name, count(p.product_id)
FROM product_categories pc JOIN products p
ON pc.category_id = p.category_id
WHERE pc.category_id = 5
GROUP BY pc.category_id, pc.category_name
UNION ALL
SELECT pc.category_id, pc.category_name, count(p.product_id)
FROM product_categories pc JOIN products p
ON pc.category_id = p.category_id
WHERE pc.category_id = 1
GROUP BY pc.category_id, pc.category_name
UNION ALL
SELECT pc.category_id, pc.category_name, count(p.product_id)
FROM product_categories pc JOIN products p
ON pc.category_id = p.category_id
WHERE pc.category_id = 2
GROUP BY pc.category_id, pc.category_name;


-- Question 4 --
-- Display product ID for ordered products whose quantity in the inventory is 
-- greater than 5. (You are not allowed to use JOIN for this question.)

-- Q4 SOLUTION --
SELECT product_id, quantity
FROM ORDER_ITEMS
MINUS
SELECT product_id, quantity
FROM inventories
WHERE quantity <=5
ORDER BY product_id;


-- Question 5 --
-- We need a single report to display all warehouses and the state that 
-- they are located in and all states regardless of whether they have warehouses 
-- in them or not.

-- Q5 SOLUTION --






