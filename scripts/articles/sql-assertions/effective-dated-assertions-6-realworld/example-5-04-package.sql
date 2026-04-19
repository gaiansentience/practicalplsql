create or replace package sales_api
as
    procedure add_customer(
        p_customer_name in customers.customer_name%type, 
        p_status in loyalty.status%type);
        
    procedure add_order(
        p_customer_name in customers.customer_name%type, 
        p_discount in orders.discount%type default 0);
        
    procedure update_customer_loyalty(
        p_customer_name in customers.customer_name%type, 
        p_status in loyalty.status%type);
        
    procedure update_loyalty_discount(
        p_status in loyalty.status%type, 
        p_discount_min in loyalty_discounts.discount_min%type default 0, 
        p_discount_max in loyalty_discounts.discount_max%type default 0);
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
        
    function get_customer_id(
        p_customer_name in customers.customer_name%type
    ) return customers.customer_id%type
    is
        l_customer_id customers.customer_id%type;
    begin
        select customer_id into l_customer_id
        from customers 
        where customer_name = p_customer_name;
        return l_customer_id;
    end get_customer_id;
    
    function get_loyalty_status_id(
        p_status in loyalty.status%type
    ) return loyalty.status_id%type
    is
        l_status_id loyalty.status_id%type;
    begin
        select status_id into l_status_id
        from loyalty
        where status = p_status;
        return l_status_id;
    end get_loyalty_status_id;

    procedure add_customer(
        p_customer_name in customers.customer_name%type, 
        p_status in loyalty.status%type)
    is
        l_info t_details := 'create customer ' || p_customer_name 
            || ' with status ' || p_status;
        l_customer_id customers.customer_id%type;
        l_status_id loyalty.status_id%type := get_loyalty_status_id(p_status);
    begin
        insert into customers(customer_name)
        values (p_customer_name)
        returning customer_id into l_customer_id;
        
        insert into customer_loyalty(customer_id, status_id)
        values (l_customer_id, l_status_id);

        commit;        
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end add_customer;        
    
    procedure add_order(
        p_customer_name in customers.customer_name%type, 
        p_discount in orders.discount%type default 0)
    is
        l_info t_details := 'place order for customer ' || p_customer_name 
            || ' with ' || (100 * p_discount) || '% discount';
        l_customer_id customers.customer_id%type := get_customer_id(p_customer_name);
    begin
        insert into orders(customer_id, discount)
        values (l_customer_id, p_discount);
        
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
            || ' to status ' || p_status;
        l_date date := sysdate;
        l_customer_id customers.customer_id%type := get_customer_id(p_customer_name);
        l_status_id loyalty.status_id%type := get_loyalty_status_id(p_status);
    begin
        update customer_loyalty
        set expires = l_date
        where customer_id = l_customer_id and expires is null;
        
        insert into customer_loyalty(customer_id, status_id, effective)
        values (l_customer_id, l_status_id, l_date);
        
        commit;    
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end update_customer_loyalty;

    procedure update_loyalty_discount(
        p_status in loyalty.status%type, 
        p_discount_min in loyalty_discounts.discount_min%type default 0, 
        p_discount_max in loyalty_discounts.discount_max%type default 0)
    is
        l_info t_details := 'update status ' || p_status 
            || ' min discount ' || (100 * p_discount_min) || '%'
            || ', max discount ' || (100 * p_discount_max) || '%';
        l_date date := sysdate;
        l_status_id loyalty.status_id%type := get_loyalty_status_id(p_status);
    begin
        update loyalty_discounts
        set expires = l_date
        where status_id = l_status_id and expires is null;
        
        insert into loyalty_discounts(status_id, discount_min, discount_max, effective)
        values (l_status_id, p_discount_min, p_discount_max, l_date);
        
        commit;    
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end update_loyalty_discount;

end sales_api;
/
