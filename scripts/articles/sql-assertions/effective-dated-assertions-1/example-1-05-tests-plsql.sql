column loyalty_discount format a18;
column order_discount format a18;

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


prompt upgrading Nina to preferred customer status fails because all order discounts are validated at the new status level
begin
    dbms_output.put_line('#Upgrade Nina to Preferred status with assertion enabled');
    sales_api.update_customer_loyalty('Nina', 'Preferred');
end;
/

prompt even setting the assertion to novalidate before updating status fails 
prompt the change in status still gets validated against all orders
alter assertion loyalty_discount_applied enable novalidate;
begin
    dbms_output.put_line('#Upgrade Nina to Preferred status with assertion enabled novalidate');
    sales_api.update_customer_loyalty('Nina', 'Preferred');
end;
/

prompt disable the assertion to update the status
alter assertion loyalty_discount_applied disable novalidate;
begin
    dbms_output.put_line('#Upgrade Nina to Preferred status with assertion disabled');
    sales_api.update_customer_loyalty('Nina', 'Preferred');
end;
/
prompt after updating the status, the assertion can only be enabled in novalidate state
alter assertion loyalty_discount_applied enable novalidate;


prompt the assertion is working for new orders only
begin
    dbms_output.put_line('#Place valid orders: Nina, Preferred, [0.05,0.05]');
    sales_api.add_order('Nina', 0.05);
    sales_api.add_order('Nina', 0.05);
    
    dbms_output.put_line('#Place invalid order: Nina, Preferred, 0.01');
    sales_api.add_order('Nina', 0.01);    
end;
/

prompt Ninas original orders before the status update cannot be validated by the assertion
prompt Ninas new orders are validated by the assertion
select * from review_order_discounts
/

prompt the only way to change customer status is to disable the assertion
alter assertion loyalty_discount_applied disable novalidate;
begin
    dbms_output.put_line('#Upgrade Nina to Elite status with assertion disabled');
    sales_api.update_customer_loyalty('Nina', 'Elite');
end;
/
prompt enable the assertion after the status update in novalidate state
alter assertion loyalty_discount_applied enable novalidate;

begin

    dbms_output.put_line('#Place valid orders: Nina, Elite, [0.10,0.11]');
    sales_api.add_order('Nina', 0.10);
    sales_api.add_order('Nina', 0.11);
    
    dbms_output.put_line('#Place invalid order: Nina, Elite, 0.05');
    sales_api.add_order('Nina', 0.05);
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
