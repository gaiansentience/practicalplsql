
create table products (
    product_id number generated always as identity 
        constraint products_pk primary key,
    code varchar2(100) not null 
        constraint products_uk unique,
    name varchar2(100) not null,
    description varchar2(1000),
    style varchar2(100),
    unit_msrp number,
    unit_cost number,
    unit_qty number default 1 not null
);
    
prompt created table products