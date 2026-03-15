column customer format a10
column status format a10
column discount format a8
column status_min format a10
column status_max format a10
set pagesize 25
alter session set nls_date_format = 'yyyy-mm-dd hh24:mi:ss';

set serveroutput on;
declare
    function get_status_id(s in loyalty_status.status%type) return loyalty_status.status_id%type
    is
        l_status_id loyalty_status.status_id%type;
    begin
        select status_id into l_status_id
        from loyalty_status
        where status = s;
        return l_status_id;
    end get_status_id;
begin
    
    <<place_valid_orders>>
    begin
        dbms_output.put_line('#Create customer Nina, status New');
        insert into customers set customer_name = 'Nina';
        insert into customer_loyalty set 
            customer_id = (select customer_id from customers where customer_name = 'Nina'), 
            status_id = (select status_id from loyalty_status where status = 'New');
    
        dbms_output.put_line('#Place valid orders: Nina, New, [0, 0.05]');    
        insert into orders set
            customer_id = (select customer_id from customers where customer_name = 'Nina'), discount = 0;
            
        insert into orders set
            customer_id = (select customer_id from customers where customer_name = 'Nina'), discount = 0.05;
    
        dbms_output.put_line('#Create customer Prue, status Preferred');
        insert into customers set customer_name = 'Prue';
        insert into customer_loyalty set
            customer_id = (select customer_id from customers where customer_name = 'Prue'), 
            status_id = (select status_id from loyalty_status where status = 'Preferred');
        
        dbms_output.put_line('#Place valid order: Prue, Preferred, 0.05');
        insert into orders set
            customer_id = (select customer_id from customers where customer_name = 'Prue'), discount = 0.05;
        
        dbms_output.put_line('#Create customer Liza, Elite');
        insert into customers set customer_name = 'Liza';
        insert into customer_loyalty set
            customer_id = (select customer_id from customers where customer_name = 'Liza'), 
            status_id = (select status_id from loyalty_status where status = 'Elite');
        
        dbms_output.put_line('#Place valid orders: Liza, Elite, [0.10,0.11]');
        insert into orders set
            customer_id = (select customer_id from customers where customer_name = 'Liza'), discount = 0.10;
            
        insert into orders set
            customer_id = (select customer_id from customers where customer_name = 'Liza'), discount = 0.11;
        
        commit;
    end;
    
    <<place_invalid_orders>>
    begin

        begin
            dbms_output.put_line('#Place invalid order: Prue, Preferred, 0');
            insert into orders set
                customer_id = (select customer_id from customers where customer_name = 'Prue'), discount = 0;
        exception
            when others then
                rollback;
                dbms_output.put_line(sqlerrm);
        end;
        
        begin
            dbms_output.put_line('#Place invalid order: Liza, Elite, 0.05');
            insert into orders set
                customer_id = (select customer_id from customers where customer_name = 'Liza'), discount = 0.05;
        exception
            when others then
                rollback;
                dbms_output.put_line(sqlerrm);
        end;
        
    end place_invalid_orders;

end;
/



prompt all valid orders have discount minimum that matches customer status
select * from review_order_discounts
/


exec dbms_session.sleep(5);
declare
    l_change_date date := sysdate;
begin

    <<update_customer_status>>
    begin
        dbms_output.put_line('#Upgrade Nina to Preferred status');
        update customer_loyalty
        set expires = l_change_date 
        where customer_id = (select customer_id from customers where customer_name = 'Nina') 
            and expires is null;
    
        insert into customer_loyalty(customer_id, status_id, effective)
        values(
            (select customer_id from customers where customer_name = 'Nina'), 
            (select status_id from loyalty_status where status = 'Preferred'), 
            l_change_date);
    
        dbms_output.put_line('#Place valid orders: Nina, Preferred, [0.05,0.05]');
        insert into orders(customer_id, discount)
        values
            ((select customer_id from customers where customer_name = 'Nina'), 0.05),
            ((select customer_id from customers where customer_name = 'Nina'), 0.05);
        
        commit;
    end update_customer_status;
    
    <<place_invalid_orders>>
    begin
        begin
            dbms_output.put_line('#Place invalid order: Nina, Preferred, 0.01');
            insert into orders(customer_id, discount)
            values((select customer_id from customers where customer_name = 'Nina'), 0.01);
        exception
            when others then
                rollback;
                dbms_output.put_line(sqlerrm);
        end;
    end place_invalid_orders;

end;
/

prompt Nina's original orders still satisfy the assertion based on the status that was effective (New)
prompt Nina's new orders after status was upgraded to Preferred also satisfy the assertion
select * from review_order_discounts
/

exec dbms_session.sleep(5);
declare
    l_change_date date := sysdate;
begin

    <<update_customer_status>>
    begin
        dbms_output.put_line('#Upgrade Nina to Elite status');
        update customer_loyalty
        set expires = l_change_date 
        where 
            customer_id = (select customer_id from customers where customer_name = 'Nina') 
            and expires is null;
    
        insert into customer_loyalty (customer_id, status_id, effective)
        values(
            (select customer_id from customers where customer_name = 'Nina'), 
            (select status_id from loyalty_status where status = 'Elite')
            , l_change_date);
    
        dbms_output.put_line('#Place valid orders: Nina, Elite, [0.10,0.11]');
        insert into orders(customer_id, discount)
        values
            ((select customer_id from customers where customer_name = 'Nina'), 0.10),
            ((select customer_id from customers where customer_name = 'Nina'), 0.11);
        
        commit;
    end update_customer_status;

    <<place_invalid_orders>>
    begin
        begin
            dbms_output.put_line('#Place invalid order: Nina, Elite, 0.05');
            insert into orders(customer_id, discount)
            values((select customer_id from customers where customer_name = 'Nina'), 0.05);
        exception
            when others then
                rollback;
                dbms_output.put_line(sqlerrm);
        end;
    end place_invalid_orders;

end;
/

prompt Nina's status is updated to Elite, all earlier orders show valid discounts for the status that was effective when the orders were placed
select * from review_order_discounts
/

exec dbms_session.sleep(5);
declare
    l_change_date date := sysdate;
begin

    <<update_status_discounts>>
    begin
        dbms_output.put_line('#Change Preferred discount to 6.25% min, 16.25% max');
        update loyalty_discounts
        set expires = l_change_date
        where status_id = (select status_id from loyalty_status where status = 'Preferred') and expires is null;
        
        insert into loyalty_discounts (status_id, discount_min, discount_max, effective)
        values ((select status_id from loyalty_status where status = 'Preferred'), 0.0625, 0.1625, l_change_date);
    
        dbms_output.put_line('#Change Elite discount to 11.25% min, 21.25% max');    
        update loyalty_discounts
        set expires = l_change_date
        where status_id = (select status_id from loyalty_status where status = 'Elite') and expires is null;
        
        insert into loyalty_discounts (status_id, discount_min, discount_max, effective)
        values ((select status_id from loyalty_status where status = 'Elite'), 0.1125, 0.2125, l_change_date);
    
        commit;
    end update_status_discounts;

    <<place_valid_orders>>
    begin
    
        dbms_output.put_line('#Place valid orders: Prue, Preferred [0.07, 0.065]');
        insert into orders(customer_id, discount)
        values 
        ((select customer_id from customers where customer_name = 'Prue'), 0.07),
        ((select customer_id from customers where customer_name = 'Prue'), 0.065);
    
        dbms_output.put_line('#Place valid order: Nina, Elite, 0.12');
        insert into orders(customer_id, discount)
        values ((select customer_id from customers where customer_name = 'Nina'), 0.12);
        
        commit;
        
    end place_valid_orders;

    <<place_invalid_orders>>
    begin
    
        begin
            dbms_output.put_line('#Place invalid order: Prue, Preferred, 0.05');
            insert into orders(customer_id, discount)
            values((select customer_id from customers where customer_name = 'Prue'), 0.05);
        
        exception
            when others then
                rollback;
                dbms_output.put_line(sqlerrm);
        end;
        
        begin
            dbms_output.put_line('#Place invalid order: Nina, Elite, 0.10');
            insert into orders(customer_id, discount)
            values((select customer_id from customers where customer_name = 'Nina'), 0.10);
        
        exception
            when others then
                rollback;
                dbms_output.put_line(sqlerrm);
        end;
    
    end place_invalid_orders;

end;
/


prompt after the change in minimum discounts for Preferred and Elite, all orders are validated correctly and show valid for the discount requirements in effect
select * from review_order_discounts
/