-- We (Juhee Lee, Seonhye Hyeon) declare that the attached assignment is our own work in 
--accordance with the Seneca Academic Policy.  
--No part of this assignment has been copied manually or electronically from any other source
--(including web sites) or distributed to other students.
-- ***********************
-- Name: Juhee Lee
-- ID: 128261203
-- Name: Seonhye Hyeon
-- ID: 125635193
-- Date: November 15, 2021
-- Purpose: Lab 6 DBS311
-- ***********************
SET SERVEROUTPUT ON;

-- Question 1 
-- Write a store procedure that gets an integer number n and calculates and displays its factorial.

-- Q1 SOLUTION –
CREATE OR replace PROCEDURE factorial(n IN INTEGER) 
AS
  value1 INTEGER := 1; 
  count1 INTEGER := 0; 
  
BEGIN 
LOOP 
  value1 := (value1 * ( n - count1 ) ); 
  count1 := count1 + 1; 
  EXIT WHEN count1 = n; 
END LOOP;

IF n = 0 OR n = 1 THEN
  DBMS_OUTPUT.PUT_LINE(n || '! = 1'); 
ELSE
  DBMS_OUTPUT.PUT_LINE(n || '! = ' || value1); 
END IF;

EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows returned!');
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No data found!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error!');
END; 
/
BEGIN
FACTORIAL(7);
END;

-- Question 2
-- The company wants to calculate the employees’ annual salary

-- Q2 SOLUTION –
CREATE OR REPLACE PROCEDURE calculate_salary(empId IN INTEGER) 
AS 
  salary NUMBER := 10000; 
  numYear INTEGER;
  fName employees.first_name%TYPE; 
  lName employees.last_name%TYPE; 
  i INTEGER := 0; 
  
BEGIN 
  SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)/12), employees.first_name , employees.last_name  
  INTO numYear, fName, lName
  FROM  employees 
  WHERE employee_id = empId; 

LOOP 
  salary := salary * 1.05; 
  i := i + 1;  --i++;
  EXIT WHEN i = numYear; 
END LOOP; 
  DBMS_OUTPUT.PUT_LINE ('First Name: ' ||fName); 
  DBMS_OUTPUT.PUT_LINE ('Last Name: ' ||lName); 
  DBMS_OUTPUT.PUT_LINE ('Salary: ' || ROUND(salary,2)); 
EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows returned!');
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No data found!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error!');
END; 
/
--SELECT EMPLOYEE_ID FROM EMPLOYEES;
BEGIN
calculate_salary(10);
END;
/

-- Question 3
--  Write a stored procedure named warehouses_report to print the warehouse ID, warehouse name, 
-- and the city where the warehouse is located in the following format for all warehouses

-- Q3 SOLUTION –
CREATE OR REPLACE PROCEDURE warehouse_report
AS
  wID warehouses.warehouse_id%TYPE;
  wName warehouses.warehouse_name%TYPE;
  wCity locations.city%TYPE;
  wState locations.state%TYPE;

BEGIN
FOR i IN 1..9 LOOP 
  SELECT w.warehouse_id, w.warehouse_name, l.city, NVL(l.state, 'no state')
  INTO wID, wName, wCity, wState
  FROM warehouses w INNER JOIN locations l 
  ON (w.location_id = l.location_id)
  WHERE w.warehouse_id = i;
    DBMS_OUTPUT.PUT_LINE('Warehouse ID: ' || wID);
    DBMS_OUTPUT.PUT_LINE('Warehouse name: ' || wName);
    DBMS_OUTPUT.PUT_LINE('City: ' || wCity);
    DBMS_OUTPUT.PUT_LINE('State: ' || wState);
END LOOP;

EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows returned!');
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No data found!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error!');
END; 
/

begin
warehouse_report;
end;
/
  




