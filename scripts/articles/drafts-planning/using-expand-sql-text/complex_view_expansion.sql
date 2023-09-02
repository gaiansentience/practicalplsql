set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := '
        select employee, manager, job_name, department_name
        from employee_info 
        order by department_name, employee_sort
        ';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

select
    "A1"."EMPLOYEE" "EMPLOYEE"
   ,"A1"."MANAGER" "MANAGER"
   ,"A1"."JOB_NAME" "JOB_NAME"
   ,"A1"."DEPARTMENT_NAME" "DEPARTMENT_NAME"
from
    (
        select
            "A6"."FIRST_NAME" || ' ' || "A6"."LAST_NAME" "EMPLOYEE"
           ,"A6"."LAST_NAME" || ', ' || "A6"."FIRST_NAME" "EMPLOYEE_SORT"
           ,"A5"."JOB_NAME" "JOB_NAME"
           ,"A4"."DEPARTMENT_NAME" "DEPARTMENT_NAME"
           ,nvl("A3"."FIRST_NAME" || ' ' || "A3"."LAST_NAME",'No Manager') "MANAGER"
        from
            "PRACTICALPLSQL"."EMPLOYEES" "A6"
           ,(
                select
                    "A7"."ID" "JOB_ID"
                   ,"A7"."NAME" "JOB_NAME"
                from "PRACTICALPLSQL"."JOBS" "A7"
            ) "A5"
           ,(
                select
                    "A8"."ID" "DEPARTMENT_ID"
                   ,"A8"."NAME" "DEPARTMENT_NAME"
                from "PRACTICALPLSQL"."DEPARTMENTS" "A8"
            ) "A4"
           ,"PRACTICALPLSQL"."EMPLOYEES" "A3"
           ,(
                select "A9"."ID" "LOCATION_ID"
                from "PRACTICALPLSQL"."LOCATIONS" "A9"
            ) "A2"
        where
                "A6"."JOB_ID" = "A5"."JOB_ID"
            and "A6"."DEPARTMENT_ID" = "A4"."DEPARTMENT_ID"
            and "A6"."MANAGER_ID" = "A3"."ID" (+)
            and "A6"."LOCATION_ID" = "A2"."LOCATION_ID" (+)
    ) "A1"
order by
    "A1"."DEPARTMENT_NAME"
   ,"A1"."EMPLOYEE_SORT";