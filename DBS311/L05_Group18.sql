-- We (Juhee Lee, Seonhye Hyeon) declare that the attached assignment is our own work in 
--accordance with the Seneca Academic Policy.  
--No part of this assignment has been copied manually or electronically from any other source
--(including web sites) or distributed to other students.
-- ***********************
-- Name: Juhee Lee
-- ID: 128261203
-- Name: Seonhye Hyeon
-- ID: 125635193
-- Date: November 8, 2021
-- Purpose: Lab 5 DBS311
-- ***********************


-- Question 1 
-- Write a store procedure that get an integer number and prints

-- Q1 SOLUTION -

SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE even_odd(number IN integer) 
AS
BEGIN
  IF MOD(number,2) = 0 THEN
    DBMS_OUTPUT.PUT_LINE ('The number is even.');
  ELSE
    DBMS_OUTPUT.PUT_LINE ('The number is odd.');
  END IF;
EXCEPTION
WHEN OTHERS 
  THEN
    DBMS_OUTPUT.PUT_LINE ('Error!');
END Even_Odd;
/

-- Question 2 
-- Create a stored procedure named find_employee.

-- Q2 SOLUTION –
/
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE find_employee(empId IN NUMBER) 
AS 
  fname Employees.first_name%TYPE;
  lname Employees.last_name%TYPE;
  eemail Employees.email%TYPE;
  pphone Employees.phone%TYPE;
  hdate Employees.hire_date%TYPE;
  jtitle Employees.job_title%TYPE;
BEGIN
  SELECT first_name, last_name, email, phone, hire_date, job_title
  INTO fname, lname, mail, phone, hdate, jtitle
  FROM employees
  WHERE employee_id = empId;
  DBMS_OUTPUT.PUT_LINE ('First name: ' || fname);
  DBMS_OUTPUT.PUT_LINE ('Last name: ' || lname);
  DBMS_OUTPUT.PUT_LINE ('Email: ' || mail);
  DBMS_OUTPUT.PUT_LINE ('Phone: ' || phone);
  DBMS_OUTPUT.PUT_LINE ('Hire date: ' || hdate);
  DBMS_OUTPUT.PUT_LINE ('Job title: ' || jtitle);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error');
END find_employee;
/


-- Question 3
-- To define the type of variables that store values of a table’ column

-- Q3 SOLUTION –


-- Question 4
-- The query displays an error message if any error occurs. 
-- Otherwise, it displays the number of updated rows.

-- Q4 SOLUTION –
/
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE update_price_under_avg 
AS 
avg_price products.list_price%type;
updatedRow number;
BEGIN 
SELECT AVG(list_price) INTO avg_price
FROM products;
IF(avg_price <=1000) THEN
UPDATE products 
SET products.list_price = (products.list_price * 1.02)
WHERE list_price < avg_price;
updatedRow := SQL%ROWCOUNT;
DBMS_OUTPUT.PUT_LINE ('The number of updated rows: ' ||updateRow);
ELSE
UPDATE products 
SET products.list_price = (products.list_price * 1.01)
WHERE list_price < avg_price;
updateRow :=SQL%ROWCOUNT;
DBMS_OUTPUT.PUT_LINE ('The number of updated rows: ' ||updateRow);
END IF;
EXCEPTION
 WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error');
END update_price_under_avg ;
/


-- Question 5
-- Write a procedure named product_price_report to show the number of products 
-- in each price category

-- Q5 SOLUTION –
/
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE product_price_report AS
    avg_price products.list_price%type;
    min_price products.list_price%type;
    max_price products.list_price%type;
    price products.list_price%type;
    cheap NUMBER;
    fair NUMBER;
    expensive NUMBER;
    cal1 float;
    cal2 float;
BEGIN
    SELECT MIN(list_price), MAX(list_price), AVG(list_price)
    INTO min_price, max_price, avg_price
    FROM products;
    -- o	(avg_price - min_price) / 2
    cal1 := (avg_price - min_price) / 2;
    -- o	(max_price - avg_price) / 2
    cal2 := (max_price - avg_price) / 2;
    
    SELECT COUNT(*) INTO cheap
    FROM products
    WHERE list_price < cal1;
    DBMS_OUTPUT.PUT_LINE('Cheap: ' || cheap);
    
    SELECT COUNT(*) INTO fair
    FROM products
    WHERE list_price > cal2;
    DBMS_OUTPUT.PUT_LINE('Fair: ' || fair);
    
    SELECT COUNT(*) INTO expensive
    FROM products
    WHERE list_price > cal1 AND list_price < cal2;
    DBMS_OUTPUT.PUT_LINE('Expensive: ' || expensive);
EXCEPTION
 WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error');
END product_price_report;
/ 







