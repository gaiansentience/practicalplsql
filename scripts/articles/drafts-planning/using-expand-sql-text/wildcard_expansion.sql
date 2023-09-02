set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := '
        select * 
        from employees 
        order by 3, 2
        ';
        
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

/*
select
    "A1"."ID" "ID"
   ,"A1"."FIRST_NAME" "FIRST_NAME"
   ,"A1"."LAST_NAME" "LAST_NAME"
   ,"A1"."EMAIL" "EMAIL"
   ,"A1"."JOB_ID" "JOB_ID"
   ,"A1"."DEPARTMENT_ID" "DEPARTMENT_ID"
   ,"A1"."LOCATION_ID" "LOCATION_ID"
   ,"A1"."MANAGER_ID" "MANAGER_ID"
   ,"A1"."SALARY" "SALARY"
   ,"A1"."HIRE_DATE" "HIRE_DATE"
from
    "PRACTICALPLSQL"."EMPLOYEES" "A1"
order by
    "A1"."LAST_NAME"
   ,"A1"."FIRST_NAME"
*/