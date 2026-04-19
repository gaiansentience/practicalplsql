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
        p_status in loyalty.status%type,
        p_expire_current in boolean default true);
        
    procedure update_loyalty_discount(
        p_status in loyalty.status%type, 
        p_discount_min in loyalty_discounts.discount_min%type,
        p_expire_current in boolean default true);
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
                when p_committed then ' COMMITTED SUCCESSFULLY'
                else ' ROLLED BACK WITH ERRORS' 
                || chr(10) || 'SQLERRM: ' || sqlerrm 
                || chr(10) || 'ERROR_STACK: ' || dbms_utility.format_error_stack()
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

    procedure expire_customer_loyalty(
        p_customer_name in customers.customer_name%type,
        p_expires in date default sysdate)
    is
        l_info t_details := 'update customer ' || p_customer_name 
            || ' current status to expired';
    begin

        savepoint expire_loyalty_period;
        
        update customer_loyalty
        set expires = p_expires
        where customer_name = p_customer_name and expires is null;
        
        print_tx_state(l_info);
    exception
        when others then
            rollback to expire_loyalty_period;
            print_tx_state(l_info, false);
            raise;
    end expire_customer_loyalty;
    
    procedure insert_customer_loyalty(
        p_customer_name in customers.customer_name%type, 
        p_status in loyalty.status%type,
        p_effective in date default sysdate)
    is
        l_info t_details := 'insert customer ' || p_customer_name 
            || ' status of ' || p_status;
    begin

        savepoint insert_loyalty_period;
        
        insert into customer_loyalty(customer_name, status, effective)
        values (p_customer_name, p_status, p_effective);
        
        print_tx_state(l_info);
    exception
        when others then
            rollback to insert_loyalty_period;
            print_tx_state(l_info, false);
            raise;
    end insert_customer_loyalty;

    procedure update_customer_loyalty(
        p_customer_name in customers.customer_name%type, 
        p_status in loyalty.status%type,
        p_expire_current in boolean default true)
    is
        l_info t_details := 'update customer ' || p_customer_name 
            || ' status to ' || p_status
            || case when p_expire_current then ' [expire previous, insert new]' else '[insert new only]' end;
        l_date date := sysdate;
    begin
        if p_expire_current then
            expire_customer_loyalty(p_customer_name, l_date);
--            update customer_loyalty
--            set expires = l_date
--            where customer_name = p_customer_name and expires is null;
        end if;

        insert_customer_loyalty(p_customer_name, p_status, l_date);        
--        insert into customer_loyalty(customer_name, status, effective)
--        values (p_customer_name, p_status, l_date);
        
        commit;    
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end update_customer_loyalty;

    procedure update_loyalty_discount(
        p_status in loyalty.status%type, 
        p_discount_min in loyalty_discounts.discount_min%type,
        p_expire_current in boolean default true)
    is
        l_info t_details := 'update status ' || p_status 
            || ' discount minimum to ' || (100 * p_discount_min) || '%'
            || case when p_expire_current then ' [expire previous, insert new]' else '[insert new only]' end;
        l_date date := sysdate;
    begin
        if p_expire_current then
            update loyalty_discounts
            set expires = l_date
            where status = p_status and expires is null;
        end if;
        
        insert into loyalty_discounts(status, discount_min, effective)
        values (p_status, p_discount_min, l_date);
        
        commit;    
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end update_loyalty_discount;

end sales_api;
/
