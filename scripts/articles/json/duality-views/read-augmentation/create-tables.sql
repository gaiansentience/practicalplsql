drop table if exists order_details;
drop table if exists orders;
drop table if exists customers;
drop table if exists products;


create table if not exists products(
    id number generated always as identity primary key,
    sku varchar2(100) unique,
    name varchar2(100),
    description varchar2(1000),
    unit_price number not null,
    detail json
)
/

create table if not exists customers(
    id number generated always as identity primary key,
    name varchar2(100),
    detail json
)
/

create table if not exists orders(
    id number generated always as identity primary key,
    customer_id references customers(id) not null,
    placed date default sysdate,
    paid date
)
/

create table if not exists order_details(
    id number generated always as identity primary key,
    order_id references orders(id) not null,
    product_id references products(id) not null,
    quantity number,
    unit_price number,
    extended_price number as (quantity * unit_price)
)
/

