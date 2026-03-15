create table if not exists loyalty_status_codes(
    status varchar2(10) 
        constraint loyalty_status_codes_pk primary key
)
/

create table if not exists loyalty(
    status varchar2(10)
        constraint loyalty_fk_loyalty_status_codes
        references loyalty_status_codes(status)
        not null, 
    discount_minimum number(5,4) default 0 not null,
    effective date default sysdate not null,
    expires date,
    constraint loyalty_ck_dates 
        check (effective < expires),
    constraint loyalty_pk 
        primary key (status, effective)
    
)
/

prompt insert the discount minimum for each loyalty status
begin
    insert into loyalty_status_codes(status)
    values('New'), ('Preferred'), ('Elite');
    
    insert into loyalty(status, discount_minimum)
    values
        ('New', 0),
        ('Preferred', .05),
        ('Elite', 0.10);
    
    commit;
end;
/

create table if not exists customers(
    customer_name varchar2(10) 
        constraint customers_pk primary key
)
/

create table if not exists customer_loyalty_periods(
    customer_name varchar2(10)
        constraint customer_loyalty_periods_fk_customers
        references customers(customer_name)
        not null,
    status varchar2(10) default 'New' 
        constraint customer_loyalty_periods_fk_loyalty_status_codes
        references loyalty_status_codes (status)
        not null,
    effective date default sysdate not null,
    expires date,
    constraint customer_loyalty_periods_ck_dates 
        check (effective < expires),
    constraint customer_loyalty_periods_pk 
        primary key (customer_name, effective)
)
/

create table if not exists orders(
    order_id integer generated always as identity primary key,
    customer_name varchar2(10)
        constraint orders_fk_customers
        references customers(customer_name) not null,
    order_discount number(5,4) default 0 not null,
    placed date default sysdate not null
)
/
