create or replace package sales_api
as
    subtype t_customer_name is customers.customer_name%type;
    subtype t_loyalty_status is loyalty_status.status%type;
    subtype t_discount is number(5,4);
    procedure add_customer(c in t_customer_name, s in t_loyalty_status);
    procedure add_order(c in t_customer_name, d in t_discount default 0);
    procedure update_customer_loyalty(c in t_customer_name, s in t_loyalty_status);
    procedure update_loyalty_discounts(s in t_loyalty_status, d_min in t_discount default 0, d_max in t_discount default 0);
end sales_api;
/

--modify the package body to handle effective dated customer status
create or replace package body sales_api
as
    subtype t_details is varchar2(4000);
    subtype t_loyalty_status_id is loyalty_status.status_id%type;
    subtype t_customer_id is customers.customer_id%type;
    
    procedure print_tx_state(p_details in t_details, p_committed in boolean default true)
    is
    begin
        dbms_output.put_line(p_details 
            || case 
                when p_committed then ' COMMITTED'
                else ' ROLLED BACK ' || sqlerrm
            end
            );
    end print_tx_state;
    
    function format_discount(d in t_discount default 0) return varchar2
    is
    begin
        return (100 * d) || '% discount';
    end format_discount;
    
    function format_customer_name(c in t_customer_name) return varchar2
    is
    begin
        return 'customer ' || c;
    end format_customer_name;
    
    function format_loyalty_status(s in t_loyalty_status) return varchar2
    is
    begin
        return 'status ' || s;
    end format_loyalty_status;
    
    function get_customer_id(c in t_customer_name) return t_customer_id
    is
        l_id t_customer_id;
    begin
        select customer_id into l_id
        from customers 
        where customer_name = c;
        return l_id;
    end get_customer_id;
    
    function get_loyalty_status_id(s in t_loyalty_status) return t_loyalty_status_id
    is
        l_id t_loyalty_status_id;
    begin
        select status_id into l_id
        from loyalty_status
        where status = s;
        return l_id;
    end get_loyalty_status_id;

    procedure add_customer(c in t_customer_name, s in t_loyalty_status)
    is
        l_info t_details := 'create ' || format_customer_name(c) || ' with ' || format_loyalty_status(s);
        c_id t_customer_id;
        s_id t_loyalty_status_id := get_loyalty_status_id(s);
    begin
        insert into customers(customer_name)
        values (c)
        returning customer_id into c_id;
        
        insert into customer_loyalty(customer_id, status_id)
        values (c_id, s_id);

        commit;        
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end add_customer;        
    
    procedure add_order(c in t_customer_name, d in t_discount default 0)
    is
        l_info t_details := 'place order for ' || format_customer_name(c) || ' with ' || format_discount(d);
        c_id t_customer_id := get_customer_id(c);
    begin
        insert into orders(customer_id, discount)
        values (c_id, d);
        commit;        
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end add_order;
    
    procedure update_customer_loyalty(c in t_customer_name, s in t_loyalty_status)
    is
        l_info t_details := 'update ' || format_customer_name(c) || ' to ' || format_loyalty_status(s);
        l_date date := sysdate;
        c_id t_customer_id := get_customer_id(c);
        s_id t_loyalty_status_id := get_loyalty_status_id(s);
    begin
        update customer_loyalty
        set expires = l_date
        where customer_id = c_id and expires is null;
        
        insert into customer_loyalty(customer_id, status_id, effective)
        values (c_id, s_id, l_date);
        commit;    
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end update_customer_loyalty;

    procedure update_loyalty_discounts(s in t_loyalty_status, d_min in t_discount default 0, d_max in t_discount default 0)
    is
        l_info t_details := 'update ' || format_loyalty_status(s) || ' min ' || format_discount(d_min) || ' max ' || format_discount(d_max);
        l_date date := sysdate;
        s_id t_loyalty_status_id := get_loyalty_status_id(s);
    begin
        update loyalty_discounts
        set expires = l_date
        where status_id = s_id and expires is null;
        
        insert into loyalty_discounts(status_id, discount_min, discount_max, effective)
        values (s_id, d_min, d_max, l_date);
        
        commit;    
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end update_loyalty_discounts;

end sales_api;
/
