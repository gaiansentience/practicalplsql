
select interval '00:33.123456789' minute to second(9)
from dual
/

select count(*) from dba_objects;

drop table test_many_details purge;

create table test_many_details as
select ds.dataset#, dv.dataset#version#, o.* from dba_objects o
cross apply (select level as dataset# from dual connect by level <= 100) ds
cross apply (select level as dataset#version# from dual connect by level <= 5) dv;




select count(*) from test_many_details;


with 
function fmt_n(n in number) return varchar2 sql_macro(scalar)
is
begin
    return q'~to_char(n, 'fm9,999,999,999,999')~';
end fmt_n;

function fmt_count(t in dbms_tf.table_t) return varchar2 sql_macro(table)
is
begin
    return q'~
    select to_char(count(*),'fm9,999,999,999,999') as table_rows
    from t
    ~';
end fmt_count;

select *
from fmt_count(test_many_details)
/

select json_serialize(json_object(d.* returning json) returning clob pretty) as jrow
from test_many_details d
/

select d.dataset#, d.dataset#version#,
length(
json_serialize(json_arrayagg(json_object(d.* returning json) returning clob) returning clob value pretty) 
) as dataset_version_json
from test_many_details d
where d.dataset# = 7 and d.dataset#version# = 1
group by d.dataset#, d.dataset#version#
/


