set SERVEROUTPUT ON


declare 

l_ids udt_id_nt;
l_odd_ids udt_id_nt;
l_even_ids udt_id_nt;
BEGIN

with base as (
    select level as id connect by level <= 10
)
select udt_id(id) bulk collect into l_ids from base;

select udt_id(t.id)  bulk collect into l_odd_ids 
from table(l_ids) T 
where mod(t.id,2) = 1;

select udt_id(t.id) bulk collect into l_even_ids
from table(l_ids) T 
where mod(t.id,2) = 0;

delete from test_types;

insert into test_types(id)
select t.id
from table(l_even_ids) t;

dbms_output.put_line('inserted ' || sql%rowcount);

dbms_output.put_line('All ids: ' || l_ids.count);
dbms_output.put_line('Odd ids: ' || l_odd_ids.count);
dbms_output.put_line('Even ids: ' || l_even_ids.count);

END;
/

