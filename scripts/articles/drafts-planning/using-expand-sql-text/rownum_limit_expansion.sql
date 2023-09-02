set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := '
    select *
    from
        (
        select 
            first_name
            , last_name
        from employees 
        order by 
            last_name
            , first_name
        )
    where rownum <= 5
        ';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

select
    "A1"."FIRST_NAME" "FIRST_NAME"
   ,"A1"."LAST_NAME" "LAST_NAME"
from
    (
        select
            "A2"."FIRST_NAME" "FIRST_NAME"
           ,"A2"."LAST_NAME" "LAST_NAME"
        from
            "PRACTICALPLSQL"."EMPLOYEES" "A2"
        order by
            "A2"."LAST_NAME"
           ,"A2"."FIRST_NAME"
    ) "A1"
where
    rownum <= 5;