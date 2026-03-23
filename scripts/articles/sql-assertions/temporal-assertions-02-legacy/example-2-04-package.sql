--adjust the api package to set customer.status_updated when changing status
create or replace package sales_api
as
    procedure add_customer(
        p_customer_name in customers.customer_name%type, 
        p_status in loyalty.status%type);
        
    procedure add_order(
        p_customer_name in customers.customer_name%type, 
        p_discount in orders.discount%type);
        
    procedure update_customer_loyalty(
        p_customer_name in customers.customer_name%type, 
        p_status in loyalty.status%type);
        
    procedure update_loyalty_discount(
        p_status in loyalty.status%type,
        p_discount_min in loyalty.discount_min%type);        
end sales_api;
/

create or replace package body sales_api
as
    subtype t_details is varchar2(4000);
    procedure print_tx_state(p_details in t_details, p_committed in boolean default true)
    is
    begin
        dbms_output.put_line(p_details 
            || case 
                when p_committed then ' COMMITTED'
                else chr(10) || '    ROLLED BACK ' || sqlerrm
            end
            );
    end print_tx_state;

    procedure add_customer(
        p_customer_name in customers.customer_name%type, 
        p_status in loyalty.status%type)
    is
        l_info t_details := 'create customer ' || p_customer_name 
            || ' with status ' || p_status;
    begin
        insert into customers(customer_name, status)
        values (p_customer_name, p_status);
        
        commit;        
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end add_customer;        
    
    procedure add_order(
        p_customer_name in customers.customer_name%type, 
        p_discount in orders.discount%type)
    is
        l_info t_details := 'place order for customer ' || p_customer_name 
            || ' with ' || (p_discount * 100) || '% discount';
    begin
        insert into orders(customer_name, discount)
        values (p_customer_name, p_discount);
        
        commit;        
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end add_order;
    
    procedure update_customer_loyalty(
        p_customer_name in customers.customer_name%type, 
        p_status in loyalty.status%type)
    is
        l_info t_details := 'update customer ' || p_customer_name 
            || ' status to ' || p_status;
    begin
        update customers 
        set status = p_status, status_updated = sysdate
        where customer_name = p_customer_name;
        
        commit;    
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end update_customer_loyalty;
    
    procedure update_loyalty_discount(
        p_status in loyalty.status%type,
        p_discount_min in loyalty.discount_min%type)
    is
        l_info t_details := 'update status ' || p_status
            || ' to discount minimum ' || (p_discount_min * 100) || '%';
    begin
        update loyalty
        set discount_min = p_discount_min, discount_updated = sysdate
        where status = p_status;
        
        commit;
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end update_loyalty_discount;    

end sales_api;
/
