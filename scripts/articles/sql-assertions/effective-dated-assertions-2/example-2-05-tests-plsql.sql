column loyalty_discount format a18;
column order_discount format a18;
set pagesize 100

set serveroutput on;

begin
    dbms_output.put_line('#Create customer Nina, status New');
    sales_api.add_customer('Nina', 'New');

    dbms_output.put_line('#Place valid orders: Nina, New, [0, 0.05]');    
    sales_api.add_order('Nina', 0);
    sales_api.add_order('Nina', 0.05);

    dbms_output.put_line('#Create customer Prue, status Preferred');
    sales_api.add_customer('Prue', 'Preferred');
    
    dbms_output.put_line('#Place valid order: Prue, Preferred, 0.05');
    sales_api.add_order('Prue', 0.05);

    dbms_output.put_line('#Create customer Liza, Elite');
    sales_api.add_customer('Liza', 'Elite');
    
    dbms_output.put_line('#Place valid orders: Liza, Elite, [0.10,0.11]');
    sales_api.add_order('Liza', 0.10);
    sales_api.add_order('Liza', 0.11);
        
    dbms_output.put_line('#Place invalid order: Prue, Preferred, 0');
    sales_api.add_order('Prue', 0);
    
    dbms_output.put_line('#Place invalid order: Liza, Elite, 0.05');    
    sales_api.add_order('Liza', 0.05);
end;
/

prompt all valid orders have discount minimum that matches customer status
select * from review_order_discounts
/

exec dbms_session.sleep(5);
prompt upgrading Nina to preferred customer status creates a new effective status period
begin
    dbms_output.put_line('#Upgrade Nina to Preferred status');
    sales_api.update_status('Nina', 'Preferred');
    
    dbms_output.put_line('#Place valid orders: Nina, Preferred, [0.05,0.05]');
    sales_api.add_order('Nina', 0.05);
    sales_api.add_order('Nina', 0.05);
    
    dbms_output.put_line('#Place invalid order: Nina, Preferred, 0.01');
    sales_api.add_order('Nina', 0.01);    
end;
/

prompt Nina's original orders are not validated by the assertion because their order dates make them legacy orders that arent validated
prompt Nina's new orders after status was upgraded to Preferred satisfy the assertion
select * from review_order_discounts
/

exec dbms_session.sleep(5);
begin
    dbms_output.put_line('#Upgrade Nina to Elite status');
    sales_api.update_status('Nina', 'Elite');
    
    dbms_output.put_line('#Place valid orders: Nina, Elite, [0.10,0.11]');
    sales_api.add_order('Nina', 0.10);
    sales_api.add_order('Nina', 0.11);
    
    dbms_output.put_line('#Place invalid order: Nina, Elite, 0.05');
    sales_api.add_order('Nina', 0.05);
end;
/

prompt Nina's status is updated to elite, and all earlier orders show as Legacy Orders that are no longer eligible to be checked by the assertion
select * from review_order_discounts
/
