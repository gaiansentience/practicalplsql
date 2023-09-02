set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := q'[
        with 
        function format_name(p_first in varchar2, p_last in varchar2)
        return varchar2
        is
        begin
            return p_first || ' ' || p_last;
        end format_name;
        employees_base as 
        (
            select
                format_name(e.first_name, e.last_name) as employee,
                e.id,
                e.manager_id,
                e.job_id
            from employees e
        ) 
        select
            e.employee, 
            m.employee as manager, 
            j.name as job
        from 
            employees_base e,
            employees_base m,
            jobs j
        where
            e.manager_id = m.id (+)
            and e.job_id = j.id
        ]';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

select
    "A3"."EMPLOYEE" "EMPLOYEE"
   ,"A2"."EMPLOYEE" "MANAGER"
   ,"A1"."NAME" "JOB"
from
    (
        select
            "SYS"." "("A5"."FIRST_NAME","A5"."LAST_NAME") "EMPLOYEE"
           ,"A5"."ID" "ID"
           ,"A5"."MANAGER_ID" "MANAGER_ID"
           ,"A5"."JOB_ID" "JOB_ID"
        from
            "PRACTICALPLSQL"."EMPLOYEES" "A5"
    ) "A3"
   ,(
        select
            "SYS"." "("A4"."FIRST_NAME","A4"."LAST_NAME") "EMPLOYEE"
           ,"A4"."ID" "ID"
           ,"A4"."MANAGER_ID" "MANAGER_ID"
           ,"A4"."JOB_ID" "JOB_ID"
        from
            "PRACTICALPLSQL"."EMPLOYEES" "A4"
    ) "A2"
   ,"PRACTICALPLSQL"."JOBS" "A1"
where
        "A3"."MANAGER_ID" = "A2"."ID" (+)
    and "A3"."JOB_ID" = "A1"."ID";