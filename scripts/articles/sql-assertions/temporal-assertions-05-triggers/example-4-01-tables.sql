create table if not exists loyalty(
    status varchar2(10) 
        constraint loyalty_pk primary key
)
/

--use loyalty discount minimum effective periods
--use virtual column with conditional unique index to enforce single active row per status discount
create table if not exists loyalty_discounts(
    status varchar2(10)
        constraint loyalty_discounts_fk_loyalty
        references loyalty(status)
        not null, 
    discount_min number(5,4) default 0 not null,
    effective date default sysdate not null,
    expires date,
    created_by varchar2(30) default user not null,
    create_date date default sysdate not null,
    changed_by varchar2(30) default user not null,
    change_date date default sysdate not null
    constraint loyalty_discounts_ck_dates 
        check (effective < expires),
    constraint loyalty_discounts_pk 
        primary key (status, effective),
    active#row as (nvl2(expires, null, status)) virtual,
    constraint loyalty_discounts_u_active#row unique (active#row) deferrable initially deferred
)
/

prompt insert the discount minimum for each loyalty status
begin
    insert into loyalty(status)
    values('New'), ('Preferred'), ('Elite');
    
    insert into loyalty_discounts(status, discount_min)
    values
        ('New', 0), ('Preferred', .05), ('Elite', 0.10);
    
    commit;
end;
/

create table if not exists customers(
    customer_name varchar2(10) 
        constraint customers_pk primary key
)
/

--use customer loyalty status effective periods
--use virtual column with conditional unique index to enforce single active row per customer status
create table if not exists customer_loyalty(
    customer_name varchar2(10)
        constraint customer_loyalty_fk_customers
        references customers(customer_name)
        not null,
    status varchar2(10) default 'New' 
        constraint customer_loyalty_fk_loyalty
        references loyalty (status)
        not null,
    effective date default sysdate not null,
    expires date,
    created_by varchar2(30) default user not null,
    create_date date default sysdate not null,
    changed_by varchar2(30) default user not null,
    change_date date default sysdate not null
    constraint customer_loyalty_ck_dates 
        check (effective < expires),
    constraint customer_loyalty_pk 
        primary key (customer_name, effective),
    active#row as (nvl2(expires, null, customer_name)) virtual,
    constraint customer_loyalty_u_active#row unique (active#row) deferrable initially deferred
)
/

create table if not exists orders(
    order_id integer generated always as identity primary key,
    customer_name varchar2(10)
        constraint orders_fk_customers
        references customers(customer_name) not null,
    discount number(5,4) default 0 not null,
    placed date default sysdate not null
)
/
