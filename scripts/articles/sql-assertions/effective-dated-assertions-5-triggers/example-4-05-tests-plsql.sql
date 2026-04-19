column loyalty_discount format a16
column order_discount format a16
column customer_status_current format a25
column loyalty_discount_current format a25

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
prompt upgrading Nina to preferred customer status without expiring previous record violates overlap assertion
begin
    dbms_output.put_line('#Upgrade Nina to Preferred status WITHOUT EXPIRING PREVIOUS STATUS');
    sales_api.update_customer_loyalty('Nina', 'Preferred', p_expire_previous => false);
end;
/

prompt upgrading Nina to preferred customer status creates a new effective status period
begin
    dbms_output.put_line('#Upgrade Nina to Preferred status');
    sales_api.update_customer_loyalty('Nina', 'Preferred');
    
    dbms_output.put_line('#Place valid orders: Nina, Preferred, [0.05,0.05]');
    sales_api.add_order('Nina', 0.05);
    sales_api.add_order('Nina', 0.05);
    
    dbms_output.put_line('#Place invalid order: Nina, Preferred, 0.01');
    sales_api.add_order('Nina', 0.01);    
end;
/

prompt Nina's original orders still satisfy the assertion based on the status that was effective (New)
prompt Nina's new orders after status was upgraded to Preferred also satisfy the assertion
select * from review_order_discounts
/

exec dbms_session.sleep(5);
begin
    dbms_output.put_line('#Upgrade Nina to Elite status');
    sales_api.update_customer_loyalty('Nina', 'Elite');
    
    dbms_output.put_line('#Place valid orders: Nina, Elite, [0.10,0.11]');
    sales_api.add_order('Nina', 0.10);
    sales_api.add_order('Nina', 0.11);
    
    dbms_output.put_line('#Place invalid order: Nina, Elite, 0.05');
    sales_api.add_order('Nina', 0.05);
end;
/

prompt Nina's status is updated to Elite, all earlier orders show valid discounts for the status that was effective when the orders were placed
select * from review_order_discounts
/


exec dbms_session.sleep(5);

prompt inserting a new discount without expiring the previous discount violates overlap assertion
begin
    dbms_output.put_line('#Change Preferred to 0.0625 minimum discount WITHOUT EXPIRING PREVIOUS DISCOUNT');
    sales_api.update_loyalty_discount('Preferred', 0.0625, p_expire_previous => false);
    
    dbms_output.put_line('#Change Elite to 0.1125 minimum discount WITHOUT EXPIRING PREVIOUS DISCOUNT');        
    sales_api.update_loyalty_discount('Elite', 0.1125, p_expire_previous => false);
end;
/

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

prompt after the change in minimum discounts for Preferred and Elite, all orders are validated correctly and show valid for the discount requirements in effect
select * from review_order_discounts
/