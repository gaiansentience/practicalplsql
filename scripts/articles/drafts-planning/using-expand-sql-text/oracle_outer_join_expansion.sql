set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := q'[
        select e.first_name, e.last_name, m.first_name || ' ' || m.last_name as manager
        from 
            employees e,
            employees m 
            where e.manager_id = m.id(+)
        order by e.last_name, e.first_name
        ]';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

select
    "A2"."FIRST_NAME" "FIRST_NAME"
   ,"A2"."LAST_NAME" "LAST_NAME"
   ,"A1"."FIRST_NAME" || ' ' || "A1"."LAST_NAME" "MANAGER"
from
    "PRACTICALPLSQL"."EMPLOYEES" "A2"
   ,"PRACTICALPLSQL"."EMPLOYEES" "A1"
where
    "A2"."MANAGER_ID" = "A1"."ID" (+)
order by
    "A2"."LAST_NAME"
   ,"A2"."FIRST_NAME";