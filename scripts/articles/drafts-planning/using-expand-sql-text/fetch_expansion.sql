set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := '
        select 
            first_name
            , last_name
        from employees 
        order by 
            last_name
            , first_name
        fetch first 5 rows only
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
           ,"A2"."LAST_NAME" "rowlimit_$_0"
           ,"A2"."FIRST_NAME" "rowlimit_$_1"
           ,row_number()
             over(
                order by
                    "A2"."LAST_NAME"
                   ,"A2"."FIRST_NAME"
             ) "rowlimit_$$_rownumber"
        from
            "PRACTICALPLSQL"."EMPLOYEES" "A2"
    ) "A1"
where
    "A1"."rowlimit_$$_rownumber" <= 5
order by
    "A1"."rowlimit_$_0"
   ,"A1"."rowlimit_$_1";