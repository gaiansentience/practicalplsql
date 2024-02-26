
create table products_source as 
select * from products
where 1 = 0;

alter table products_source add (
    constraint products_source_pk primary key (product_id),
    constraint products_source_uk unique(code),
    constraint products_source_code_uc 
        check (code = upper(code))
);

prompt created table products_source

