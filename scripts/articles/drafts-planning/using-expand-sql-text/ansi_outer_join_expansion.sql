set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := q'[
        select e.first_name, e.last_name, m.first_name || ' ' || m.last_name as manager
        from 
            employees e
            left outer join employees m on e.manager_id = m.id
        order by e.last_name, e.first_name
        ]';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

select
    "A1"."QCSJ_C000000000300002_1" "FIRST_NAME"
   ,"A1"."QCSJ_C000000000300004_2" "LAST_NAME"
   ,"A1"."QCSJ_C000000000300003_5" || ' ' || "A1"."QCSJ_C000000000300005_6" "MANAGER"
from
    (
        select
            "A3"."ID" "QCSJ_C000000000300000"
           ,"A3"."FIRST_NAME" "QCSJ_C000000000300002_1"
           ,"A3"."LAST_NAME" "QCSJ_C000000000300004_2"
           ,"A3"."MANAGER_ID" "QCSJ_C000000000300006"
           ,"A2"."ID" "QCSJ_C000000000300001"
           ,"A2"."FIRST_NAME" "QCSJ_C000000000300003_5"
           ,"A2"."LAST_NAME" "QCSJ_C000000000300005_6"
           ,"A2"."MANAGER_ID" "QCSJ_C000000000300007"
        from
            "PRACTICALPLSQL"."EMPLOYEES" "A3"
           ,"PRACTICALPLSQL"."EMPLOYEES" "A2"
        where
            "A3"."MANAGER_ID" = "A2"."ID"   --should have (+)
    ) "A1"
order by
    "A1"."QCSJ_C000000000300004_2"
   ,"A1"."QCSJ_C000000000300002_1";