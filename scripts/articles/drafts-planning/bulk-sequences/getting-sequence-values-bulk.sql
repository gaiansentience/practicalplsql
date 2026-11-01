
--dynamic sequence cache resizing
-- alter system set "_dynamic_sequence_cache" = FALSE;

create sequence seq_test_id cache 100;

create or replace function f_seq_test_id return number
is
pragma udf;
begin
    return seq_test_id.nextval;
end f_seq_test_id;
/

/*
--sequence is not valid in subquery or inline view (or cte expression)
--only solution is to wrap in function
select 
    seq_test_id.nextval as seq_direct_outer
--,(select seq_test_id.nextval from dual) as seq_subquery
--    b.id, b.seq_using_function, seq_test_id.nextval as x
    ,b.*
from
(
select  level as id
    --, seq_test_id.nextval as seq_direct_inner
    , f_seq_test_id as seq_using_function
from dual connect by level < 100
) b;

with base as (
select  level as id
    , seq_test_id.nextval as seq_direct_inner
    , f_seq_test_id as seq_using_function
from dual connect by level < 100

)
select 
    seq_test_id.nextval as seq_direct_outer
--,(select seq_test_id.nextval from dual) as seq_subquery
--    b.id, b.seq_using_function, seq_test_id.nextval as x
    ,b.*
from base b;

*/

set serveroutput on;
declare
l_start timestamp;
n number := 100000;

cursor c_f is
select line
--, seq_test_id.nextval as next_seq
, f_seq_test_id as next_seq
from all_source
where rownum < n;

cursor c_s is
select line
, seq_test_id.nextval as next_seq
--, f_seq_test_id as next_seq
from all_source
where rownum < n;

type t_rows is table of c_f%rowtype;
l_rows t_rows := t_rows();
begin
l_rows := t_rows();
l_start := localtimestamp;
open c_f;
fetch c_f bulk collect into l_rows;
close c_f;

dbms_output.put_line(to_char(localtimestamp - l_start) || ' fetched ' || l_rows.count || ' sequence values using select and wrapper udf function');
l_rows := t_rows();
l_start := localtimestamp;

open c_s;
fetch c_s bulk collect into l_rows;
close c_s;

dbms_output.put_line(to_char(localtimestamp - l_start) || ' fetched ' || l_rows.count || ' sequence values using select and sequence directly');
l_rows := t_rows();
l_start := localtimestamp;


for i in 1..n loop
    l_rows.extend;
    l_rows(l_rows.last).next_seq := seq_test_id.nextval;
end loop;

dbms_output.put_line(to_char(localtimestamp - l_start) || ' assigned ' || l_rows.count || ' sequence values direct from sequence');

end;
/

drop function f_seq_test_id;
drop sequence seq_test_id;