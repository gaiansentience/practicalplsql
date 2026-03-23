create table if not exists loyalty(
    status_id integer default 0
        constraint loyalty_pk primary key,
    status varchar2(20)  not null
        constraint loyalty_u_status unique
)
/
--todo: add effective dates for status codes also???

create table if not exists loyalty_discounts(
    status_id integer
        constraint loyalty_discounts_fk_loyalty
            references loyalty(status_id) not null,
    discount_min number(5,4) default 0 not null,
    discount_max number(5,4) default 0 not null,
    effective date default sysdate not null,
    expires date,
    constraint loyalty_discounts_ck_discount_min_lte_discount_max
        check (discount_min <= discount_max),
    constraint loyalty_discounts_ck_effective_lt_expires 
        check (effective < expires),
    constraint loyalty_discounts_pk 
        primary key (status_id, effective),
    active#row number as ( nvl2(expires, null, status_id) ) virtual,
    constraint loyalty_discounts_u_active#row unique (active#row)        
)
/

prompt insert the discount minimum/maximum for each loyalty status
begin
    insert into loyalty(status_id, status)
    values(0, 'New'), (1, 'Preferred'), (2, 'Elite'), (3, 'Cosmic');
    
    insert into loyalty_discounts(status_id, discount_min, discount_max)
    values
        (0, 0, 0.10),
        (1, .05, 0.15),
        (2, 0.10, 0.20),
        (3, 0.15, 0.25);
    
    commit;
end;
/

create table if not exists customers(
    customer_id integer generated always as identity
        constraint customers_pk primary key,
    customer_name varchar2(50)
        constraint customers_u_customer_name unique
)
/

create table if not exists customer_loyalty(
    customer_id integer
        constraint customer_loyalty_fk_customers
            references customers(customer_id) not null,
    status_id integer default 0 
        constraint customer_loyalty_fk_loyalty
            references loyalty (status_id) not null,
    effective date default sysdate not null,
    expires date,
    constraint customer_loyalty_ck_effective_lt_expires
        check (effective < expires),
    constraint customer_loyalty_pk 
        primary key (customer_id, effective),
    active#row number as ( nvl2(expires, null, customer_id) ) virtual,
    constraint customer_loyalty_u_active#row unique (active#row)
)
/

create table if not exists orders(
    order_id integer generated always as identity
        constraint orders_pk primary key,
    customer_id integer
        constraint orders_fk_customers
            references customers(customer_id) not null,
    discount number(5,4) default 0 not null,
    placed date default sysdate not null
)
/
