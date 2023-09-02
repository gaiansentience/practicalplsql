set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := q'[
with pivot_base as
(
select
    e.first_name || ' ' || e.last_name as employee
    , j.code as job
    , d.name as department
from
    employees e
   , jobs j
   , departments d
where
    e.job_id = j.id
    and e.department_id = d.id
    and j.code in ('EXECUTIVE','MANAGER','ASSOCIATE')
)
select
    department
    , executives
    , managers
    , associates
from 
    (
    select
        department
        , listagg(case when job = 'EXECUTIVE' then employee end,', ')
            within group (order by employee) as executives
        , listagg(case when job = 'MANAGER' then employee end,', ') 
            within group (order by employee) as managers
        , listagg(case when job = 'ASSOCIATE' then employee end,', ') 
            within group (order by employee) as associates
    from pivot_base
    group by department    
    )
]';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

select
    "A1"."DEPARTMENT" "DEPARTMENT"
   ,"A1"."EXECUTIVES" "EXECUTIVES"
   ,"A1"."MANAGERS" "MANAGERS"
   ,"A1"."ASSOCIATES" "ASSOCIATES"
from
    (
        select
            "A5"."DEPARTMENT" "DEPARTMENT"
           ,listagg(case when "A5"."JOB" = 'EXECUTIVE' then "A5"."EMPLOYEE" end,', ') 
                within group(order by "A5"."EMPLOYEE") "EXECUTIVES"
           ,listagg(case when "A5"."JOB" = 'MANAGER' then "A5"."EMPLOYEE" end,', ') 
                within group(order by "A5"."EMPLOYEE") "MANAGERS"
           ,listagg(case when "A5"."JOB" = 'ASSOCIATE' then "A5"."EMPLOYEE" end,', ') 
                within group(order by "A5"."EMPLOYEE") "ASSOCIATES"
        from
            (
                select
                    "A4"."FIRST_NAME" || ' ' || "A4"."LAST_NAME" "EMPLOYEE"
                   ,"A3"."CODE" "JOB"
                   ,"A2"."NAME" "DEPARTMENT"
                from
                    "PRACTICALPLSQL"."EMPLOYEES" "A4"
                   ,"PRACTICALPLSQL"."JOBS" "A3"
                   ,"PRACTICALPLSQL"."DEPARTMENTS" "A2"
                where
                        "A4"."JOB_ID" = "A3"."ID" 
                        and "A4"."DEPARTMENT_ID" = "A2"."ID" 
                        and ( "A3"."CODE" = 'EXECUTIVE' or "A3"."CODE" = 'MANAGER' or "A3"."CODE" = 'ASSOCIATE' )
            ) "A5"
        group by "A5"."DEPARTMENT"
    ) "A1";