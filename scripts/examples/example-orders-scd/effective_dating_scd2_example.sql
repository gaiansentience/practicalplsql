create table orders (
    order_id number constraint orders_pk primary key,
    customer_id number,
    order_date date
);

--drop table order_details purge;
create table order_details (
    order_detail_id number generated always as identity
        constraint order_details_pk primary key,
    order_id number references orders (order_id),
    line_item number,
    quantity number,
    item_code varchar2(20)
);


truncate table order_details drop storage;
truncate table orders drop storage;

insert into orders 
select order_id, customer_id, order_date from (
select level as order_id, round(dbms_random.value(1,500)) as customer_id, sysdate - dbms_random.value(1,1000) as order_date
from dual connect by level <= 100000
)
order by order_date;

insert into order_details(order_id, line_item, quantity, item_code)
with order_base as (
select o.order_id, round(dbms_random.value(5,50)) as items_ordered 
from orders o
order by o.order_date
)
select o.order_id, i.line_item, i.quantity, i.item_code
from order_base o
cross join lateral (
    select rownum as line_item, dbms_random.string('U',2) || '-' || to_char(round(dbms_random.value(1,10)),'fm099') as item_code, round(dbms_random.value(1,100)) as quantity
    from dual connect by level <= o.items_ordered) i
/

commit;

select min(customer_id), max(customer_id), count(distinct customer_id) from orders;

select o.* from orders o where customer_id = 333;
/

select * from order_details;

alter table item_pricing rename to items;

alter index item_pricing_pk rename to items_pk;

alter table items rename constraint item_pricing_pk to items_pk;

create table items(
    item_id number generated always as identity
        constraint items_pk primary key,
    item_code varchar2(20),
    item_price number,
    effective date,
    expires date
);

insert into items(item_code, item_price, effective)
select d.item_code, round(dbms_random.value(1, 1000),2) as item_price,trunc(min(o.order_date),'MM') as effective 
from order_details d
join orders o on o.order_id = d.order_id
group by item_code
/

insert into items (item_code, item_price, effective)
with item_base as (
select i.item_code, i.item_price, i.effective, i.price_changes, chg.price_change_number, chg.change_multiplier, chg.change_months
from (
    select i.item_code, i.item_price, i.effective, round(dbms_random.value(0,10)) as price_changes
    from items i
) i
cross join lateral (
    select level as price_change_number, 1 + round(dbms_random.value(-10,10),2)/100 as change_multiplier, round(dbms_random.value(1,3)) as change_months
    from dual connect by level <= i.price_changes
) chg
), change_history (item_code, starting_price, previous_price, item_price, previous_effective, effective, price_changes, price_change_number, change_multiplier, change_months) as (
select 
    item_code
    , item_price as starting_price, item_price as previous_price, round(item_price * change_multiplier,2) as item_price
    , effective as previous_effective, add_months(effective, change_months) as effective
    , price_changes, price_change_number, change_multiplier, change_months
from item_base where price_change_number = 1
union all
select 
    h.item_code
    , h.starting_price, h.item_price as previous_price, round(h.item_price * b.change_multiplier,2) as item_price
    , h.effective as previous_effective, add_months(h.effective, b.change_months) as effective
    , h.price_changes, b.price_change_number, b.change_multiplier, b.change_months
from item_base b
join change_history h on b.item_code = h.item_code and b.price_change_number = h.price_change_number + 1 
) search depth first by item_code, price_change_number set history_ordering
select 
--item_code, starting_price, previous_price, item_price, item_price - previous_price as price_change, previous_effective, effective, price_changes, price_change_number, change_multiplier, change_months
item_code, item_price, effective
from change_history;

merge into items t
using (
select 
    i.item_id, i.item_code, i.item_price, i.effective, i.expires
    , row_number() over (partition by i.item_code order by i.effective desc) as price_entry
    , lead(i.effective, 1) over (partition by i.item_code order by i.effective asc) as new_expires
from items i
) s
on (t.item_id = s.item_id)
when matched then
update set t.expires = s.new_expires where s.price_entry > 1;


select count(*), count(distinct item_code)
from items
where expires is not null
order by item_code, effective;


alter table items add is_current varchar2(1) as (nvl2(expires, null, 'Y'));

create index items_i_effective_expires on items(effective, expires);

create index items_i_current on items(is_current);

select * from items
where is_current = 'Y';

alter table items add current_item_code as (nvl2(expires, null, item_code));

alter table items add constraint items_u_current_item_code unique (current_item_code);


with 
function format_currency(p_value in number) return varchar2
is
begin
    return to_char(p_value, 'fm999,999,999,999.99');
end format_currency;
base as (
select 
    o.order_id, o.customer_id, o.order_date, od.line_item, od.quantity, od.item_code
    , i.item_price, i.item_price * od.quantity as extended_price, i.effective, i.expires, i.is_current
    , c.item_price as current_item_price, c.item_price * od.quantity as current_extended_price, c.effective as current_effective
from 
    orders o
    join order_details od on o.order_id = od.order_id
    join items c on od.item_code = c.current_item_code
    join items i on od.item_code = i.item_code and o.order_date >= i.effective and (i.expires is null or i.expires > o.order_date)
--where i.is_current = 'Y'    
)
select trunc(order_date,'YYYY') as order_year, format_currency(sum(extended_price)) as orders_as_priced, format_currency(sum(current_extended_price)) orders_at_current_pricing
from base
group by trunc(order_date, 'YYYY')
order by trunc(order_date, 'YYYY')
--order by o.order_date, o.order_id, od.line_item
/









