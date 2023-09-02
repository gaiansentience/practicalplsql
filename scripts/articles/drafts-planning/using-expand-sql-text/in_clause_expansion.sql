set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := q'[
        select * 
        from jobs 
        where
            code in ('EXECUTIVE','MANAGER','ASSOCIATE')
        ]';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

select
    "A1"."ID" "ID"
   ,"A1"."CODE" "CODE"
   ,"A1"."NAME" "NAME"
   ,"A1"."DESCRIPTION" "DESCRIPTION"
from
    "PRACTICALPLSQL"."JOBS" "A1"
where
    "A1"."CODE" = 'EXECUTIVE' or "A1"."CODE" = 'MANAGER' or "A1"."CODE" = 'ASSOCIATE';