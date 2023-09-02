set serveroutput on;

create or replace function employee_names return varchar2
    sql_macro ( table )
is
begin
    return q'[
        select e.first_name || ' ' || e.last_name as employee
        from employees e]';
end employee_names;
/

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := q'[
        select * from employee_names()
        ]';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

begin
    dbms_output.put_line(employee_names());
end;
/

--table sql macro is expanded
select
    "A1"."EMPLOYEE" "EMPLOYEE"
from
    (
        select
            "A2"."EMPLOYEE" "EMPLOYEE"
        from
            (
                select
                    "A3"."FIRST_NAME" || ' ' || "A3"."LAST_NAME" "EMPLOYEE"
                from
                    "PRACTICALPLSQL"."EMPLOYEES" "A3"
            ) "A2"
    ) "A1";

drop function employee_names;