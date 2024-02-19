
create table products (
    product_id number generated always as identity 
        constraint products_pk primary key,
    code varchar2(100) not null 
        constraint products_uk unique
        constraint products_code_uc
            check (code = upper(code)),
    name varchar2(100) not null,
    description varchar2(4000),
    style varchar2(100),
    unit_msrp number
);
    
prompt created table products