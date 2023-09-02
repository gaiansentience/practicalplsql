set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := '
        select e.first_name, e.last_name 
        from employees e 
        order by e.last_name, e.first_name
        ';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

/*
select
    "A1"."FIRST_NAME" "FIRST_NAME"
   ,"A1"."LAST_NAME" "LAST_NAME"
from
    "PRACTICALPLSQL"."EMPLOYEES" "A1"
order by
    "A1"."LAST_NAME"
   ,"A1"."FIRST_NAME";
*/