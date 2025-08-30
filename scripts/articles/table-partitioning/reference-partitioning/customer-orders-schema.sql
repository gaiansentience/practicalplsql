--create schema authorization devgym (

create table products(
product_id integer generated always as identity primary key,
product_name varchar2(100) not null,
upc_code varchar2(50) unique not null,
qty_units varchar2(20) default 'ea',
unit_price number not null,
unit_cost number not null,
description varchar2(1000),
created date default sysdate,
created_by varchar2(100),
updated date,
updated_by varchar2(100)
);

create table customers(
customer_id integer generated always as identity primary key, 
customer_name varchar2(50) unique not null,
created date default sysdate,
created_by varchar2(100),
updated date,
updated_by varchar2(100)
) partition by hash(customer_id) 
partitions 64;

--customer locations/addresses

create table contacts(
contact_id integer generated always as identity primary key,
customer_id integer not null
    constraint contacts_fk_customers references customers(customer_id),
first_name varchar2(50),
last_name varchar2(50),
title varchar2(20),
created date default sysdate,
created_by varchar2(100),
updated date,
updated_by varchar2(100)
) partition by reference (contacts_fk_customers);

--add customer location id as ship to location
create table orders (
order_id integer generated always as identity primary key, 
customer_id integer not null
    constraint orders_fk_customers references customers(customer_id),
order_reference varchar2(20), 
ordered_date date,
ordered_by varchar2(100),
created date default sysdate,
created_by varchar2(100),
updated date,
updated_by varchar2(100)
) partition by reference (orders_fk_customers);

create table order_archive (
order_id integer not null,
customer_id integer not null
    constraint order_archive_fk_customers references customers(customer_id),
archive_date date,
archive_data clob constraint order_archive_ck_json check (archive_data is json),
constraint order_archive_pk primary key (order_id, archive_date)
) partition by reference (orders_fk_customers);

create table order_details(
order_detail_id integer generated always as identity primary key,
order_id integer not null
    constraint order_details_fk_orders references orders(order_id),
product_id integer not null
    constraint order_details_fk_products references products(product_id),
qty number not null,
price number not null,
created date default sysdate,
created_by varchar2(100),
updated date,
updated_by varchar2(100)
) partition by reference (order_details_fk_orders);