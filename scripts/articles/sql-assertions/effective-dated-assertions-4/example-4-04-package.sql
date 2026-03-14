create or replace package sales_api
as
    procedure add_customer(c in customers.customer_name%type, s in loyalty.status%type);
    procedure add_order(c in customers.customer_name%type, d in orders.order_discount%type);
    procedure update_status(c in customers.customer_name%type, s in loyalty.status%type);
    procedure update_status_discount(s in loyalty.status%type, d in loyalty.discount_minimum%type);
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
                else ' ROLLED BACK ' || sqlerrm
            end
            );
    end print_tx_state;

    procedure add_customer(c in customers.customer_name%type, s in loyalty.status%type)
    is
        l_info t_details := 'create customer ' || c || ' with status ' || s;
    begin
        insert into customers(customer_name)
        values (c);
        insert into customer_loyalty_periods(customer_name, status)
        values (c, s);

        commit;        
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end add_customer;        
    
    procedure add_order(c in customers.customer_name%type, d in orders.order_discount%type)
    is
        l_info t_details := 'place order for customer ' || c || ' with ' || (d * 100) || '% discount';
    begin
        insert into orders(customer_name, order_discount)
        values (c, d);
        commit;        
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end add_order;
    
    procedure update_status(c in customers.customer_name%type, s in loyalty.status%type)
    is
        l_info t_details := 'update customer ' || c || ' status to ' || s;
        l_date date := sysdate;
    begin
        update customer_loyalty_periods
        set expires = l_date
        where customer_name = c and expires is null;
        insert into customer_loyalty_periods(customer_name, status, effective)
        values (c, s, l_date);
        commit;    
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end update_status;

    procedure update_status_discount(s in loyalty.status%type, d in loyalty.discount_minimum%type)
    is
        l_info t_details := 'update status ' || s || ' discount minimum to ' || (100 * d) || '%';
        l_date date := sysdate;
    begin
        update loyalty
        set expires = l_date
        where status = s and expires is null;
        insert into loyalty(status, discount_minimum, effective)
        values (s, d, l_date);
        commit;    
        print_tx_state(l_info);
    exception
        when others then
            rollback;
            print_tx_state(l_info, false);
    end update_status_discount;

end sales_api;
/
