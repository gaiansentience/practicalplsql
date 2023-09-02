set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := q'[
        select 
            emp.employee, 
            emp.manager
        from 
            (
            select 
                e.first_name || ' ' || e.last_name as employee, 
                m.first_name || ' ' || m.last_name as manager
            from
                employees e,
                employees m
            where 
                e.manager_id = m.id(+)
            ) emp
        ]';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

--inline view with oracle joins is not expanded
select
    "A1"."EMPLOYEE" "EMPLOYEE"
   ,"A1"."MANAGER" "MANAGER"
from
    (
        select
            "A3"."FIRST_NAME" || ' ' || "A3"."LAST_NAME" "EMPLOYEE"
           ,"A2"."FIRST_NAME" || ' ' || "A2"."LAST_NAME" "MANAGER"
        from
            "PRACTICALPLSQL"."EMPLOYEES" "A3"
           ,"PRACTICALPLSQL"."EMPLOYEES" "A2"
        where
            "A3"."MANAGER_ID" = "A2"."ID" (+)
    ) "A1";