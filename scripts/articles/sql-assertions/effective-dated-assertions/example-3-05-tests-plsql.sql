column loyalty_discount format a18;
column order_discount format a18;

set serveroutput on;

--Nina is a new customer, can have any discount or none
begin
    sales_api.add_customer('Nina', 'New');
    sales_api.add_order('Nina', 0);
    sales_api.add_order('Nina', 0.05);
end;
/
--create customer Nina with status New COMMITTED
--place order for customer Nina with 0% discount COMMITTED
--place order for customer Nina with 5% discount COMMITTED

--Prue is a preferred customer, discount must be at least 5%
--only order with 5% discount succeeds
begin
    sales_api.add_customer('Prue', 'Preferred');
    sales_api.add_order('Prue', 0.05);
    sales_api.add_order('Prue', 0);
end;
/
--create customer Prue with status Preferred COMMITTED
--place order for customer Prue with 5% discount COMMITTED
--place order for customer Prue with 0% discount ROLLED BACK ORA-08601: SQL assertion (DEVGYM.LOYALTY_DISCOUNT_APPLIED) violated.

--Liza is a preferred customer, discount must be at least 10%
--only orders with 10% or more discounts succeed
begin
    sales_api.add_customer('Liza', 'Elite');
    sales_api.add_order('Liza', 0.10);
    sales_api.add_order('Liza', 0.11);
    sales_api.add_order('Liza', 0.05);
end;
/
--create customer Liza with status Elite COMMITTED
--place order for customer Liza with 10% discount COMMITTED
--place order for customer Liza with 11% discount COMMITTED
--place order for customer Liza with 5% discount ROLLED BACK ORA-08601: SQL assertion (DEVGYM.LOYALTY_DISCOUNT_APPLIED) violated.

select * from review_order_discounts
/
/*
CUSTOMER_N STATUS     LOYALTY_DISCOUNT     ORDER_ID ORDER_DISCOUNT     DISCOUNT_VALID  PLACED              EFFECTIVE           EXPIRES            
---------- ---------- ------------------ ---------- ------------------ --------------- ------------------- ------------------- -------------------
Liza       Elite      10%                         5 10%                Meets Minimum   2026-03-08 22:31:32 2026-03-08 22:31:32                    
Liza       Elite      10%                         6 11%                Exceeds Minimum 2026-03-08 22:31:32 2026-03-08 22:31:32                    
Nina       New        0%                          1 0%                 Meets Minimum   2026-03-08 22:31:32 2026-03-08 22:31:32                    
Nina       New        0%                          2 5%                 Exceeds Minimum 2026-03-08 22:31:32 2026-03-08 22:31:32                    
Prue       Preferred  5%                          3 5%                 Meets Minimum   2026-03-08 22:31:32 2026-03-08 22:31:32                    
*/

exec dbms_session.sleep(5);
--upgrading Nina to preferred customer status creates a new effective status
begin
    sales_api.update_status('Nina', 'Preferred');
end;
/
--update customer Nina status to Preferred COMMITTED


--now Nina cant create an order without a 5% discount, assertion is working for new orders only
begin
    sales_api.add_order('Nina', 0.01);
    sales_api.add_order('Nina', 0.05);
    sales_api.add_order('Nina', 0.05);
end;
/
--place order for customer Nina with 1% discount ROLLED BACK ORA-08601: SQL assertion (DEVGYM.LOYALTY_DISCOUNT_APPLIED) violated.
--place order for customer Nina with 5% discount COMMITTED
--place order for customer Nina with 5% discount COMMITTED

--Nina's original orders still satisfy the assertion based on the status that was effective
select * from review_order_discounts
/
/*
CUSTOMER_N STATUS     LOYALTY_DISCOUNT     ORDER_ID ORDER_DISCOUNT     DISCOUNT_VALID  PLACED              EFFECTIVE           EXPIRES            
---------- ---------- ------------------ ---------- ------------------ --------------- ------------------- ------------------- -------------------
Liza       Elite      10%                         5 10%                Meets Minimum   2026-03-08 22:31:32 2026-03-08 22:31:32                    
Liza       Elite      10%                         6 11%                Exceeds Minimum 2026-03-08 22:31:32 2026-03-08 22:31:32                    
Nina       New        0%                          1 0%                 Meets Minimum   2026-03-08 22:31:32 2026-03-08 22:31:32 2026-03-08 22:31:37
Nina       New        0%                          2 5%                 Exceeds Minimum 2026-03-08 22:31:32 2026-03-08 22:31:32 2026-03-08 22:31:37
Nina       Preferred  5%                          9 5%                 Meets Minimum   2026-03-08 22:31:37 2026-03-08 22:31:37                    
Nina       Preferred  5%                         10 5%                 Meets Minimum   2026-03-08 22:31:37 2026-03-08 22:31:37                    
Prue       Preferred  5%                          3 5%                 Meets Minimum   2026-03-08 22:31:32 2026-03-08 22:31:32                    
*/

exec dbms_session.sleep(5);
begin
    sales_api.update_status('Nina', 'Elite');
end;
/
--update customer Nina status to Elite COMMITTED



--now Nina cant create an order without a 10% discount, assertion is working for new orders only
begin
    sales_api.add_order('Nina', 0.10);
    sales_api.add_order('Nina', 0.11);
    sales_api.add_order('Nina', 0.05);
end;
/
--place order for customer Nina with 10% discount COMMITTED
--place order for customer Nina with 11% discount COMMITTED
--place order for customer Nina with 5% discount ROLLED BACK ORA-08601: SQL assertion (DEVGYM.LOYALTY_DISCOUNT_APPLIED) violated.


prompt Nina's status is updated to elite, and all earlier orders show valid discounts for the status that was effective when the orders were placed
select * from review_order_discounts
/
/*
CUSTOMER_N STATUS     LOYALTY_DISCOUNT     ORDER_ID ORDER_DISCOUNT     DISCOUNT_VALID  PLACED              EFFECTIVE           EXPIRES            
---------- ---------- ------------------ ---------- ------------------ --------------- ------------------- ------------------- -------------------
Liza       Elite      10%                         5 10%                Meets Minimum   2026-03-08 22:31:32 2026-03-08 22:31:32                    
Liza       Elite      10%                         6 11%                Exceeds Minimum 2026-03-08 22:31:32 2026-03-08 22:31:32                    
Nina       New        0%                          1 0%                 Meets Minimum   2026-03-08 22:31:32 2026-03-08 22:31:32 2026-03-08 22:31:37
Nina       New        0%                          2 5%                 Exceeds Minimum 2026-03-08 22:31:32 2026-03-08 22:31:32 2026-03-08 22:31:37
Nina       Preferred  5%                          9 5%                 Meets Minimum   2026-03-08 22:31:37 2026-03-08 22:31:37 2026-03-08 22:31:42
Nina       Preferred  5%                         10 5%                 Meets Minimum   2026-03-08 22:31:37 2026-03-08 22:31:37 2026-03-08 22:31:42
Nina       Elite      10%                        11 10%                Meets Minimum   2026-03-08 22:31:42 2026-03-08 22:31:42                    
Nina       Elite      10%                        12 11%                Exceeds Minimum 2026-03-08 22:31:42 2026-03-08 22:31:42                    
Prue       Preferred  5%                          3 5%                 Meets Minimum   2026-03-08 22:31:32 2026-03-08 22:31:32                    
*/