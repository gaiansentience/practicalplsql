
create table products_source as 
select * from products;

alter table products_source add (
    constraint products_source_pk primary key (product_id),
    constraint products_source_uk unique(code)
);

prompt created table products_source

