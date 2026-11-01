--create table test_types(id number)
--/
set serveroutput on

declare

l_ids package_types.rec_id_nt;
l_odd_ids package_types.rec_id_nt;
l_even_ids package_types.rec_id_nt;

begin

with base as (
    select level as id
    connect by level <= 10
)
select id bulk collect into l_ids
from base;

select t.id bulk collect into l_odd_ids
from table(l_ids) t
where mod(t.id,2) = 1;

select t.id bulk collect into l_even_ids
from table(l_ids) t
where mod(t.id,2) = 0;

forall i in indices of l_odd_ids
insert into test_types(id)
select l_odd_ids(i).id;


select id bulk collect into l_ids
from test_types;

dbms_output.put_line(sql%rowcount);
dbms_output.put_line(l_ids.count);

end;
/

