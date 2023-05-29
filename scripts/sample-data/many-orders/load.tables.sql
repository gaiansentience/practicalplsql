truncate table order_details drop storage;

truncate table orders drop storage;

truncate table products drop storage;

truncate table product_types drop storage;

truncate table customers drop storage;

truncate table accounts drop storage;

insert into accounts (account_id, account_name)
select level, 'account ' || level
from dual connect by level <= 20;

insert into customers (customer_id, customer_name, account_id)
select level, 'customer ' || level, mod(level,20)+1
from dual connect by level <= 10000;

insert into product_types (product_type_id, product_type_name)
select level, 'product type ' || level
from dual connect by level <= 10;

insert into products (product_id, product_type_id, product_name, unit_price)
select level, mod(level, 10) + 1, 'product ' || level, round(dbms_random.value(1, 100)) 
from dual connect by level <= 100;

insert into orders (customer_id, order_date)
with customer_orders as
(select c.customer_id, round(dbms_random.value(mod(c.customer_id, 7) + 1, 10)) as order_count 
from customers c
)
select co.customer_id, trunc(sysdate - o.order_sequence) as order_date
from customer_orders co 
cross apply (select level * 7 as order_sequence from dual connect by level <= co.order_count) o
order by order_date;

insert into order_details (order_id, product_id, quantity)
with order_base as (
select o.order_id, round(dbms_random.value(mod(o.order_id, 7) + 1, 10)) as item_count
from orders o
)
select b.order_id, p.product_id, round(dbms_random.value(1,20)) as quantity
from order_base b
cross apply (select level as item_sequence from dual connect by level <= b.item_count) d
inner join lateral (select product_id from products order by dbms_random.value() offset d.item_sequence rows fetch first 1 row only) p on 1 = 1;

commit;


prompt many orders tables sample data loaded