column loyalty_discount format a18;
column order_discount format a18;

set serveroutput on;

--Nina is a new customer, can have any discount or none
begin
    insert into customers(customer_name, status)
    values('Nina', 'New');
    
    insert into orders(customer_name, order_discount)
    values('Nina', 0), ('Nina', 0.05);
    
    commit;
end;
/
/*
create customer Nina with status New COMMITTED
place order for customer Nina with 0% discount COMMITTED
place order for customer Nina with 5% discount COMMITTED
*/

--Prue is a preferred customer, discount must be at least 5%
--only order with 5% discount succeeds
begin
    insert into customers(customer_name, status)
    values('Prue', 'Preferred');
    
    insert into orders(customer_name, order_discount)
    values('Prue', 0.05);
    
    commit;
end;
/

begin
    insert into orders(customer_name, order_discount)
    values('Prue', 0);

exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/

/*
create customer Prue with status Preferred COMMITTED
place order for customer Prue with 5% discount COMMITTED
place order for customer Prue with 0% discount ROLLED BACK ORA-08601: SQL assertion (DEVGYM.LOYALTY_DISCOUNT_APPLIED) violated.
*/


--Liza is a preferred customer, discount must be at least 10%
--only orders with 10% or more discounts succeed
begin
    insert into customers(customer_name, status)
    values('Liza', 'Elite');
    
    insert into orders(customer_name, order_discount)
    values('Liza', 0.10), ('Liza', 0.11);
    
    commit;
end;
/

begin
    insert into orders(customer_name, order_discount)
    values('Liza', 0.05);
exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/

/*
create customer Liza with status Elite COMMITTED
place order for customer Liza with 10% discount COMMITTED
place order for customer Liza with 11% discount COMMITTED
place order for customer Liza with 5% discount ROLLED BACK ORA-08601: SQL assertion (DEVGYM.LOYALTY_DISCOUNT_APPLIED) violated.
*/


select * from review_order_discounts
/
/*
CUSTOMER_N STATUS     LOYALTY_DISCOUNT     ORDER_ID ORDER_DISCOUNT     DISCOUNT_VALID 
---------- ---------- ------------------ ---------- ------------------ ---------------
Liza       Elite      10%                         5 10%                Meets Minimum  
Liza       Elite      10%                         6 11%                Exceeds Minimum
Nina       New        0%                          1 0%                 Meets Minimum  
Nina       New        0%                          2 5%                 Exceeds Minimum
Prue       Preferred  5%                          3 5%                 Meets Minimum  
*/

--upgrading Nina to preferred customer status fails
--all order discounts are validated at new status level
begin
    update customers
    set status = 'Preferred' 
    where customer_name = 'Nina';

exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/
--update customer Nina status to Preferred ROLLED BACK ORA-08601: SQL assertion (DEVGYM.LOYALTY_DISCOUNT_APPLIED) violated.


--setting the assertion to novalidate before updating status
--the change in status still gets validated against all orders
alter assertion loyalty_discount_applied enable novalidate;
begin
    update customers
    set status = 'Preferred' 
    where customer_name = 'Nina';

exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/
--Assertion LOYALTY_DISCOUNT_APPLIED altered.
--update customer Nina status to Preferred ROLLED BACK ORA-08601: SQL assertion (DEVGYM.LOYALTY_DISCOUNT_APPLIED) violated.

--after disabling the assertion, the status update can happen
alter assertion loyalty_discount_applied disable novalidate;
begin
    update customers
    set status = 'Preferred' 
    where customer_name = 'Nina';

    commit;
end;
/
alter assertion loyalty_discount_applied enable novalidate;
--Assertion LOYALTY_DISCOUNT_APPLIED altered.
--update customer Nina status to Preferred COMMITTED
--Assertion LOYALTY_DISCOUNT_APPLIED altered.


--now Nina cant create an order without a 5% discount, assertion is working for new orders only
begin
    insert into orders(customer_name, order_discount)
    values('Nina', 0.01);

exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/

begin
    insert into orders(customer_name, order_discount)
    values('Nina', 0.05), ('Nina', 0.05);
    
    commit;
end;
/
--place order for customer Nina with 1% discount ROLLED BACK ORA-08601: SQL assertion (DEVGYM.LOYALTY_DISCOUNT_APPLIED) violated.
--place order for customer Nina with 5% discount COMMITTED
--place order for customer Nina with 5% discount COMMITTED


select * from review_order_discounts
/
/*
CUSTOMER_N STATUS     LOYALTY_DISCOUNT     ORDER_ID ORDER_DISCOUNT     DISCOUNT_VALID 
---------- ---------- ------------------ ---------- ------------------ ---------------
Liza       Elite      10%                         5 10%                Meets Minimum  
Liza       Elite      10%                         6 11%                Exceeds Minimum
Nina       Preferred  5%                          1 0%                 Insufficient   
Nina       Preferred  5%                          2 5%                 Meets Minimum  
Nina       Preferred  5%                          9 5%                 Meets Minimum  
Nina       Preferred  5%                         10 5%                 Meets Minimum  
Prue       Preferred  5%                          3 5%                 Meets Minimum  
*/

prompt the only way to change customer status is to disable the assertion
alter assertion loyalty_discount_applied disable novalidate;
begin
    update customers
    set status = 'Elite' 
    where customer_name = 'Nina';
    commit;
end;
/
alter assertion loyalty_discount_applied enable novalidate;

--Assertion LOYALTY_DISCOUNT_APPLIED altered.
--update customer Nina status to Elite COMMITTED
--Assertion LOYALTY_DISCOUNT_APPLIED altered.


--now Nina cant create an order without a 10% discount, assertion is working for new orders only
begin
    insert into orders(customer_name, order_discount)
    values('Nina', 0.10),('Nina', 0.11);
    
    commit;
end;
/

begin

    insert into orders(customer_name, order_discount)
    values('Nina', 0.05), ('Nina', 0.05);

exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/

/*
place order for customer Nina with 10% discount COMMITTED
place order for customer Nina with 11% discount COMMITTED
place order for customer Nina with 5% discount ROLLED BACK ORA-08601: SQL assertion (DEVGYM.LOYALTY_DISCOUNT_APPLIED) violated.
*/

prompt Nina's status is updated to elite, and all earlier orders show invalid discounts
select * from review_order_discounts
/
/*
CUSTOMER_N STATUS     LOYALTY_DISCOUNT     ORDER_ID ORDER_DISCOUNT     DISCOUNT_VALID 
---------- ---------- ------------------ ---------- ------------------ ---------------
Liza       Elite      10%                         5 10%                Meets Minimum  
Liza       Elite      10%                         6 11%                Exceeds Minimum
Nina       Elite      10%                         1 0%                 Insufficient   
Nina       Elite      10%                         2 5%                 Insufficient   
Nina       Elite      10%                         9 5%                 Insufficient   
Nina       Elite      10%                        10 5%                 Insufficient   
Nina       Elite      10%                        11 10%                Meets Minimum  
Nina       Elite      10%                        12 11%                Exceeds Minimum
Prue       Preferred  5%                          3 5%                 Meets Minimum  
*/

prompt because existing data violates the assertion, it still cannot be validated
begin
    execute immediate 'alter assertion loyalty_discount_applied enable validate';
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
