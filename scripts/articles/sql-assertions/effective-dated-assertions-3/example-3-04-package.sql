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
end sales_api;
/

--modify the package body to handle effective dated customer status
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
        l_info t_details := 'create customer ' || p_customer_name || ' with status ' || p_status;
    begin
        insert into customers(customer_name)
        values (p_customer_name);
        
        insert into customer_loyalty(customer_name, status)
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
        l_date date := sysdate;
    begin
        update customer_loyalty
        set expires = l_date
        where customer_name = p_customer_name and expires is null;
        
        insert into customer_loyalty(customer_name, status, effective)
        values (p_customer_name, p_status, l_date);
        
        commit;    
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end update_customer_loyalty;

end sales_api;
/
