-- ***********************
-- Group# : 18
-- Name: Juhee Lee
-- ID: #128261203
-- Name: Seonhye Hyeon
-- ID: #125635193
-- Date: 2021 Sep 17
-- Purpose: Lab 1 DBS311
-- ***********************
-- Question 1 --
-- Write a query to display the tomorrow¡¯s date in the following format: January 10th of year 2019
-- the result will depend on the day when you RUN/EXECUTE this query.  Label the column ¡°Tomorrow¡±.

-- Q1 SOLUTION --
SELECT to_char(sysdate +1,'fmMonth ddth "of year" YYYY') AS "Tomorrow" FROM dual;

 
-- Question 2 --
-- For each product in category 2, 3, and 5, show product ID, product name, list price, and the new list price increased by 2%. 
-- Display a new list price as a whole number. In your result, add a calculated column to show the difference of old and new list prices.

-- Q2 Solution --
SELECT product_id, product_name, list_price, ROUND(list_price*1.02) AS "New List Price", ROUND((list_price*1.02) - list_price, 2) AS "Price difference"
FROM products 
WHERE category_id in(2,3,5)
ORDER BY product_id;   


-- Question 3 -- 
-- For employees whose manager ID is 2, write a query that displays the employee¡¯s Full Name and Job Title in the following format:
-- SUMMER, PAYNE is Public Accountant.

-- Q3 Solution --
SELECT (UPPER(first_name) ||', '|| UPPER(last_name) || ' is ' || job_title || '.') AS "Employee Info" 
FROM employees 
WHERE manager_id = 2;

 
-- Question 4 --
-- For each employee hired before October 2016, display the employee¡¯s last name, hire date 
-- and calculate the number of YEARS between TODAY and the date the employee was hired.

-- Q4 Solution --
SELECT last_name, hire_date, ROUND(MONTHS_BETWEEN(sysdate, hire_date)/12) AS "Years worked"
FROM employees 
WHERE hire_date <= TO_DATE ('20161001', 'YYYYMMDD')
ORDER BY "Years worked";


-- Question 5 --
-- Display each employee¡¯s last name, hire date, and the review date, which is the first Tuesday after a year of service,
-- but only for those hired after 2016.  
-- FORMAT: TUESDAY, August the Thirty-First of year 2016

-- Q5 Solution --

SELECT last_name, hire_date, TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 12), 3), 'fmDay, Month " the " Ddspth "of year" yyyy','NLS_DATE_LANGUAGE=AMERICAN') as "REVIEW DAY"
FROM employees
WHERE hire_date >= TO_DATE ('20161001', 'YYYYMMDD')
ORDER BY "REVIEW DAY";


-- Question 6 --
-- For all warehouses, display warehouse id, warehouse name, city, and state.
-- For warehouses with the null value for the state column, display ¡°unknown¡±.

-- Q6 Solution --
SELECT w.warehouse_id, w.warehouse_name, l.city, nvl(to_char(l.state), 'unknown') AS "STATE"  
FROM warehouses w LEFT JOIN locations l ON w.location_id = l.location_id 
ORDER BY w.warehouse_id;

