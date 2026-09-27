
insert into products (sku, name, description, unit_price, detail)
values ('UMB-L-R', 'Large Red Umbrella', 'Red Umbrella', 19, json{'fabric': 'nylon', 'handle': 'curved', 'color' : 'red'})
, ('UMB-L-B', 'Large Black Umbrella', 'Black Umbrella', 19, json{'fabric': 'nylon', 'handle': 'curved', 'color' : 'black'})
/

select * from products_dv
;

--cannot insert empty json object into a flex field
insert into customers (name, detail) 
values ('Sam', json{}), ('June', json{}), ('April',json{})
/


select * from customers_dv;

insert into orders
set customer_id = 1, placed = sysdate;

insert into orders
set customer_id = 2, placed = sysdate;

select * from orders_dv;



create table if not exists order_details(
    id number generated always as identity primary key,
    order_id references orders(id) not null,
    product_id references products(id) not null,
    quantity number,
    unit_price number,
    extended_price number as (quantity * unit_price)
)
/

select * from customers;