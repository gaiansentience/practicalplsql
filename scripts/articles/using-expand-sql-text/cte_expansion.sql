set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := q'[
        with employees_base as 
        (
            select
                e.first_name || ' ' || e.last_name as employee,
                e.id,
                e.manager_id
            from employees e
        ) 
        select
            e.employee, 
            m.employee as manager 
        from 
            employees_base e,
            employees_base m
        where
            e.manager_id = m.id (+)
        ]';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

select
    "A2"."EMPLOYEE" "EMPLOYEE"
   ,"A1"."EMPLOYEE" "MANAGER"
from
    (
        select
            "A4"."FIRST_NAME" || ' ' || "A4"."LAST_NAME" "EMPLOYEE"
           ,"A4"."ID" "ID"
           ,"A4"."MANAGER_ID" "MANAGER_ID"
        from
            "PRACTICALPLSQL"."EMPLOYEES" "A4"
    ) "A2"
   ,(
        select
            "A3"."FIRST_NAME" || ' ' || "A3"."LAST_NAME" "EMPLOYEE"
           ,"A3"."ID" "ID"
           ,"A3"."MANAGER_ID" "MANAGER_ID"
        from
            "PRACTICALPLSQL"."EMPLOYEES" "A3"
    ) "A1"
where
    "A2"."MANAGER_ID" = "A1"."ID" (+);