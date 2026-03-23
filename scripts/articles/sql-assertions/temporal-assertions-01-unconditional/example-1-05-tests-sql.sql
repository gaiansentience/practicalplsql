--example-1-05-tests-sql.sql

column loyalty_discount format a18
column order_discount format a18
set pagesize 100

set serveroutput on;

begin
    dbms_output.put_line('#Create customer Nina, status New');
    insert into customers (customer_name, status) values ('Nina', 'New');

    dbms_output.put_line('#Place valid orders: Nina, New, [0, 0.05]');    
    insert into orders(customer_name, discount)
    values('Nina', 0), ('Nina', 0.05);

    dbms_output.put_line('#Create customer Prue, status Preferred');
    insert into customers (customer_name, status) values ('Prue', 'Preferred');
    
    dbms_output.put_line('#Place valid order: Prue, Preferred, 0.05');
    insert into orders(customer_name, discount)
    values('Prue', 0.05);
    
    dbms_output.put_line('#Create customer Liza, Elite');
    insert into customers(customer_name, status) values('Liza', 'Elite');
    
    dbms_output.put_line('#Place valid orders: Liza, Elite, [0.10,0.11]');
    insert into orders(customer_name, discount)
    values('Liza', 0.10),('Liza', 0.11);
    
    commit;
end;
/

begin
    dbms_output.put_line('#Place invalid order: Prue, Preferred, 0');
    insert into orders(customer_name, discount)
    values('Prue', 0);
exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/

begin
    dbms_output.put_line('#Place invalid order: Liza, Elite, 0.05');
    insert into orders(customer_name, discount)
    values('Liza', 0.05);
exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/

prompt all valid orders have discount minimum that matches customer status
select * from review_order_discounts
/

prompt upgrading Nina to preferred customer status fails because all order discounts are validated at the new status level
begin
    dbms_output.put_line('#Upgrade Nina to Preferred status with assertion enabled');
    update customers
    set status = 'Preferred' 
    where customer_name = 'Nina';

exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/

prompt even setting the assertion to novalidate before updating status fails 
prompt the change in status still gets validated against all orders
alter assertion loyalty_discount_applied enable novalidate;
begin
    dbms_output.put_line('#Upgrade Nina to Preferred status with assertion enabled novalidate');
    update customers
    set status = 'Preferred' 
    where customer_name = 'Nina';

exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/

prompt disable the assertion to update the status
alter assertion loyalty_discount_applied disable novalidate;
begin
    dbms_output.put_line('#Upgrade Nina to Preferred status with assertion disabled');
    update customers
    set status = 'Preferred' 
    where customer_name = 'Nina';

    commit;
end;
/
prompt after updating the status, the assertion can only be enabled in novalidate state
alter assertion loyalty_discount_applied enable novalidate;

begin
    dbms_output.put_line('#Place valid orders: Nina, Preferred, [0.05,0.05]');
    insert into orders(customer_name, discount)
    values('Nina', 0.05),('Nina', 0.05);
    
    commit;
end;
/

begin
    dbms_output.put_line('#Place invalid order: Nina, Preferred, 0.01');
    insert into orders(customer_name, discount)
    values('Nina', 0.01);
exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/

prompt Ninas original orders before the status update cannot be validated by the assertion
prompt Ninas new orders are validated by the assertion
select * from review_order_discounts
/

prompt the only way to change customer status is to disable the assertion
begin
    dbms_output.put_line('disable the assertion');
    execute immediate 'alter assertion loyalty_discount_applied disable novalidate';
    
    dbms_output.put_line('#Upgrade Nina to Elite status with assertion disabled');
    update customers
    set status = 'Elite' 
    where customer_name = 'Nina';
    commit;
    
    dbms_output.put_line('enable the assertion after upgrading customer status');
    execute immediate 'alter assertion loyalty_discount_applied enable novalidate';    
end;
/

begin
   dbms_output.put_line('#Place valid orders: Nina, Elite, [0.10,0.11]');
    insert into orders(customer_name, discount)
    values('Nina', 0.10),('Nina', 0.11);
    
    commit;
end;
/

begin
    dbms_output.put_line('#Place invalid order: Nina, Elite, 0.05');
    insert into orders(customer_name, discount)
    values('Nina', 0.05);
exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/

prompt Nina's status is updated to elite, and all earlier orders show invalid discounts that cannot be validated by the assertion
select * from review_order_discounts
/

prompt because existing data violates the assertion, it still cannot be validated
begin
    dbms_output.put_line('#enable the assertion in validate state');
    execute immediate 'alter assertion loyalty_discount_applied enable validate';
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

--------------------------------------------
prompt changing loyalty discounts cannot be done with assertion enabled, existing data violates the assertion
begin
    dbms_output.put_line('#Change Preferred to 0.0625 minimum discount');
    update loyalty set discount_min = 0.0625
    where status = 'Preferred';
exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/

begin
    dbms_output.put_line('#Change Elite to 0.1125 minimum discount');        
    update loyalty set discount_min = 0.1125
    where status = 'Elite';
exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/

prompt to change the discount minimums, the assertion must be disabled
prompt after updating the discounts, the assertion can be enabled in novalidate state
begin
    dbms_output.put_line('disable the assertion to change loyalty discount minimum');
    execute immediate 'alter assertion loyalty_discount_applied disable novalidate';
    
    dbms_output.put_line('#Change Preferred to 0.0625 minimum discount');
    update loyalty set discount_min = 0.0625
    where status = 'Preferred';
    
    dbms_output.put_line('#Change Elite to 0.1125 minimum discount');        
    update loyalty set discount_min = 0.1125
    where status = 'Elite';
    
    commit;

    dbms_output.put_line('enable the assertion');
    execute immediate 'alter assertion loyalty_discount_applied enable novalidate';
end;
/


begin

    dbms_output.put_line('#Place valid orders: Prue, Preferred [0.07, 0.065]');
    insert into orders(customer_name, discount)
    values('Prue', 0.07), ('Prue', 0.065);

    dbms_output.put_line('#Place valid order: Nina, Elite, 0.12');
    insert into orders(customer_name, discount)
    values('Nina', 0.12);

    commit;
end;
/

begin
    dbms_output.put_line('#Place invalid order: Prue, Preferred, 0.05');
    insert into orders(customer_name, discount)
    values('Prue', 0.05);
exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/


begin
    dbms_output.put_line('#Place invalid order: Nina, Elite, 0.10');      
    insert into orders(customer_name, discount)
    values('Nina', 0.10);
exception
    when others then
        rollback;
        dbms_output.put_line(sqlerrm);
end;
/

prompt while new orders will be validated by the assertion, not all existing orders meet the revised minimum discount requirements
select * from review_order_discounts
/
