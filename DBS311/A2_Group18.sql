-- We (Juhee Lee, Seonhye Hyeon) declare that the attached assignment is our own work in 
--accordance with the Seneca Academic Policy.  
--No part of this assignment has been copied manually or electronically from any other source
--(including web sites) or distributed to other students.
-- ***********************
-- Name: Juhee Lee
-- ID: 128261203
-- Name: Seonhye Hyeon
-- ID: 125635193
-- Date: November 28, 2021
-- Purpose: Assignment2 DBS311
-- ***********************
SET SERVEROUTPUT ON;

-- find_customer
CREATE OR REPLACE PROCEDURE find_customer (customer_idd IN NUMBER, found OUT NUMBER)
AS
  counts NUMBER :=0;
BEGIN 
SELECT COUNT(*) INTO counts FROM customers
WHERE customer_id = customer_idd;
IF counts != 0 THEN
  found :=1;
ELSE 
  found :=0;
END IF;
EXCEPTION
WHEN no_data_found THEN
    	found := 0;
END;
/

CREATE OR REPLACE PROCEDURE find_product (product_idd IN NUMBER, price OUT products.list_price%TYPE)
AS
 pprice products.list_price%TYPE;
BEGIN
  SELECT list_price INTO pprice FROM products
  WHERE product_id = product_idd;
  IF pprice IS NOT NULL THEN
    price := pprice;
  ELSE
    price :=0;
  END IF;
EXCEPTION
WHEN no_data_found THEN
    	price := 0;
END;
/

CREATE OR REPLACE PROCEDURE add_order (customer_idd IN NUMBER, new_order_id OUT NUMBER)
AS
BEGIN
  SELECT MAX(order_id) +1 INTO new_order_id FROM orders;
  INSERT INTO orders
  VALUES (new_order_id, customer_idd, 'Shipped', 56, sysdate);
END;
/

CREATE OR REPLACE PROCEDURE add_order_item (orderId IN order_items.order_id%type,
                                            itemId IN order_items.item_id%type, 
                                            productId IN order_items.product_id%type, 
                                            quantity IN order_items.quantity%type,
                                            price IN order_items.unit_price%type)
AS
BEGIN
  INSERT INTO order_items
  VALUES (orderId, itemId, productId, quantity, price);
END;
/







