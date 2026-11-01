alter session disable parallel dml;

select json_object('order_id' value order_id,'details' value json_array(json_object(details)))
from orders;

create type udt_order_detail as object (
    qty number,
    item varchar2(20)
)
/

create type udt_order_details_nt is table of udt_order_detail
/


create type udt_order as object (
    order_id number,
    details udt_order_details_nt
)
/

create type udt_orders_nt is table of udt_order
/


create table orders (
order_id number,
details udt_order_details_nt
)
nested table details store as nt_order_details
/



--ORA-00902: invalid datatype
create global temporary table orders_gtt (
order_id number,
details udt_order_details_n
)
nested table details store as gtt_nt_order_details
/



create global temporary table orders_gtt_json (
order_id number,
details clob check (details is json)
)
/


create or replace view orders_gtt as
select order_id, json_value(details,'$' returning udt_order_details_nt) as details
from orders_gtt_json
/


insert into orders_gtt_json(order_id, details)
select 1 as order_id, json_array(udt_order_details_nt(udt_order_detail(1, 'hat'), udt_order_detail(2, 'sock'))) as details
from dual
/

insert into orders_gtt_json(order_id, details)
select order_id, json_array(details)
from orders;

select * from orders_gtt;

select order_id, json_value(details,'$' returning udt_order_details_nt) as details
from orders_gtt_json;

select * from orders_gtt_json;

begin

for i in 1..100 loop
insert into orders(order_id, details)
select i as order_id, udt_order_details_nt(udt_order_detail(i, 'hat'), udt_order_detail(i+1, 'sock')) as details
from dual;

end loop;
commit;

end;
/

select * from orders;


create or replace view orders_json as
select order_id, json_array(details) as details from orders;


select * from orders_json;

insert into orders_gtt_json(order_id, details)
select order_id, details
from orders_json;


insert into orders_gtt_json
select 4242 as order_id, json_arrayagg(json_object('QTY' value j.qty, 'ITEM' value j.item || b.order_id ) returning clob) as details
from orders_gtt_json b, json_table(b.details, '$[*]' columns (qty number path '$.QTY', item path '$.ITEM')) j
/
--inserting to nested table slows with record volumn relative to inserting to json table

insert into orders
select order_id, details from orders_gtt
where order_id = 4242
/

commit;

delete from orders where order_id = 4242;


truncate table orders drop storage;

select * from orders;

set serveroutput on;
declare 
c udt_orders_nt;

begin
dbms_session.free_unused_user_memory;

select udt_order(order_id, details)
bulk collect into c
from orders;

insert into orders_gtt_json(order_id, details)
select t.order_id, json_array(t.details returning clob) as details
from table(c) t;

for r in (select order_id, details from orders_gtt_json) loop
dbms_output.put_line(r.order_id || ':' || r.details);
end loop;

c.delete;
dbms_session.free_unused_user_memory;

end;
/

select category, sum(allocated), sum(used), max(max_allocated) from v$process_memory
group by category;
