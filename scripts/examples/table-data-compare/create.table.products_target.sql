
create table products_target as 
select * from products;

alter table products_target add (
    constraint products_target_pk primary key (product_id),
    constraint products_target_uk unique(code),
    constraint products_target_code_uc 
        check (code = upper(code))    
);

prompt created table products_target