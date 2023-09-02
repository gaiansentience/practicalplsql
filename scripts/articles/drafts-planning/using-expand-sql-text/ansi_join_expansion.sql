set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := q'[
        select e.first_name, e.last_name, j.name as job_name
        from 
        employees e
        join jobs j on e.job_id = j.id
        order by e.last_name, e.first_name
        ]';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

select
    "A1"."FIRST_NAME_1" "FIRST_NAME"
   ,"A1"."LAST_NAME_2" "LAST_NAME"
   ,"A1"."NAME_5" "JOB_NAME"
from
    (
        select
            "A3"."ID" "QCSJ_C000000000300000"
           ,"A3"."FIRST_NAME" "FIRST_NAME_1"
           ,"A3"."LAST_NAME" "LAST_NAME_2"
           ,"A3"."JOB_ID" "JOB_ID"
           ,"A2"."ID" "QCSJ_C000000000300001"
           ,"A2"."NAME" "NAME_5"
        from
            "PRACTICALPLSQL"."EMPLOYEES" "A3"
           ,"PRACTICALPLSQL"."JOBS" "A2"
        where
            "A3"."JOB_ID" = "A2"."ID"
    ) "A1"
order by
    "A1"."LAST_NAME_2"
   ,"A1"."FIRST_NAME_1";