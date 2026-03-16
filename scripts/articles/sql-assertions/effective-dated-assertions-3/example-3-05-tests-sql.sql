column loyalty_discount format a18;
column order_discount format a18;
set pagesize 100

set serveroutput on;

begin
    dbms_output.put_line('#Create customer Nina, status New');
    insert into customers (customer_name) values ('Nina');
    insert into customer_loyalty (customer_name, status) values ('Nina', 'New');

    dbms_output.put_line('#Place valid orders: Nina, New, [0, 0.05]');    
    insert into orders(customer_name, discount)
    values('Nina', 0), ('Nina', 0.05);

    dbms_output.put_line('#Create customer Prue, status Preferred');
    insert into customers (customer_name) values ('Prue');
    insert into customer_loyalty (customer_name, status) values ('Prue', 'Preferred');
    
    dbms_output.put_line('#Place valid order: Prue, Preferred, 0.05');
    insert into orders(customer_name, discount)
    values('Prue', 0.05);
    
    dbms_output.put_line('#Create customer Liza, Elite');
    insert into customers(customer_name) values ('Liza');
    insert into customer_loyalty(customer_name, status) values('Liza', 'Elite');
    
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

exec dbms_session.sleep(5);
declare
    l_date date := sysdate;
begin
    dbms_output.put_line('#Upgrade Nina to Preferred status');
    update customer_loyalty
    set expires = l_date 
    where customer_name = 'Nina' and expires is null;

    insert into customer_loyalty(customer_name, status, effective)
    values('Nina', 'Preferred', l_date);

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

prompt Nina's original orders still satisfy the assertion based on the status that was effective (New)
prompt Nina's new orders after status was upgraded to Preferred also satisfy the assertion
select * from review_order_discounts
/

exec dbms_session.sleep(5);
declare
    l_date date := sysdate;
begin
    dbms_output.put_line('#Upgrade Nina to Elite status');
    update customer_loyalty
    set expires = l_date 
    where customer_name = 'Nina' and expires is null;

    insert into customer_loyalty(customer_name, status, effective)
    values('Nina', 'Elite', l_date);

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

prompt Nina's status is updated to Elite, all earlier orders show valid discounts for the status that was effective when the orders were placed
select * from review_order_discounts
/

--TODO: Implement these tests with SQL
prompt changing loyalty discounts can be done with assertion enabled, existing data that violates the assertion is ignored
exec dbms_session.sleep(5);
begin
    dbms_output.put_line('#Change Preferred to 0.0625 minimum discount');
    sales_api.update_loyalty_discount('Preferred', 0.0625);
    
    dbms_output.put_line('#Change Elite to 0.1125 minimum discount');        
    sales_api.update_loyalty_discount('Elite', 0.1125);
    
end;
/

begin

    dbms_output.put_line('#Place valid orders: Prue, Preferred [0.07, 0.065]');
    sales_api.add_order('Prue', 0.07);
    sales_api.add_order('Prue', 0.065);

    dbms_output.put_line('#Place valid order: Nina, Elite, 0.12');
    sales_api.add_order('Nina', 0.12);     
    
    dbms_output.put_line('#Place invalid order: Prue, Preferred, 0.05');
    sales_api.add_order('Prue', 0.05);

    dbms_output.put_line('#Place invalid order: Nina, Elite, 0.10');
    sales_api.add_order('Nina', 0.10); 
      
end;
/

prompt while new orders will be validated by the assertion, existing orders that would not meet the assertion are ignored (shown as Legacy Order)
select * from review_order_discounts
/
