drop type if exists udt_orders_nt;
drop type if exists udt_order;
drop table if exists orders purge;
drop type if exists udt_order_details_nt;
drop type if exists udt_order_detail;

select json{'order_id' value order_id,'details' value json_array(details)}
from orders;

create type if not exists udt_order_detail as object (
    qty number,
    item varchar2(20),
    member function to_json return json,
    member procedure from_json(j in json)
)
/

create or replace type body udt_order_detail
as
member function to_json return json
is
begin
    return json_object('qty' value self.qty, 'item' value self.item returning json);
end to_json;
member procedure from_json(j in json)
is
begin
    self := json_value(j, '$' returning udt_order_detail);
end from_json;
end;
/

create type if not exists udt_order_details_nt as table of udt_order_detail
/

create or replace type udt_order as object (
    order_id number,
    details udt_order_details_nt,
    member function to_json return json,
    member procedure from_json(j in json)
)
/

create or replace type body udt_order
as
member function to_json return json
is
r json;
begin
    select
    json_object('order_id' value self.order_id
        , 'details' value json_arrayagg(value(t).to_json() returning json)
        returning json)
    into r
    from table(self.details) t;
    return r;
end to_json;
member procedure from_json(j in json)
is
begin
self := json_value(j, '$' returning udt_order);
end from_json;
end;
/

create type if not exists udt_orders_nt is table of udt_order
/




create table if not exists orders (
order_id number primary key,
details udt_order_details_nt
)
nested table details store as nt_order_details
/

--object view on orders
create or replace view orders_o of udt_order with object identifier (order_id) as
select order_id, details 
from orders;

select json_value(value(o).to_json(), '$' returning udt_order) as x from orders_o o;

select deref(ref(o)), ref(o), value(o), o.object_value from orders_o o;

select json_object(*) from user_nested_tables;


--ORA-00902: invalid datatype
create global temporary table orders_gtt (
order_id number,
details udt_order_details_nt
)
nested table details store as gtt_nt_order_details
/



create global temporary table if not exists orders_gtt_json (
order_id number,
details json
)
/


create or replace view orders_gtt as
select order_id, json_value(details,'$' returning udt_order_details_nt) as details
from orders_gtt_json
/


insert into orders_gtt_json(order_id, details)
select 1 as order_id, json_array(udt_order_details_nt(udt_order_detail(1, 'hat'), udt_order_detail(2, 'sock'))) as details
/

select * from orders_gtt;

select order_id, json_value(details,'$' returning udt_order_details_nt) as details
from orders_gtt_json;

select * from orders_gtt_json;

insert into orders(order_id, details)
select 2 as order_id, udt_order_details_nt(udt_order_detail(1, 'hat'), udt_order_detail(2, 'sock')) as details
/

insert into orders
select order_id, details from orders_gtt
/

select * from orders;

select o.*, d.qty, d.item, d.to_json() 
from orders o
cross apply table(o.details) d;


create or replace view orders_json as
select order_id, json_array(details) as details from orders;


select * from orders_json;

insert into orders_gtt_json(order_id, details)
select order_id, details
from orders_json;

set serveroutput on;
declare 
c udt_orders_nt;

begin
dbms_session.free_unused_user_memory;

select udt_order(order_id, details)
bulk collect into c
from orders;

insert into orders_gtt_json(order_id, details)
select t.order_id, json_array(t.details returning clob)  as details
from table(c) t;

for r in (select order_id, json_serialize(details returning clob) as details from orders_gtt_json) loop
dbms_output.put_line(r.order_id || ':' || r.details);
end loop;

c.delete;
dbms_session.free_unused_user_memory;

end;
/
