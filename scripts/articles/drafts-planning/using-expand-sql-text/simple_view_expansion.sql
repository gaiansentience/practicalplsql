set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := '
        select location_name, address, city 
        from location_info 
        order by location_name
        ';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

select
    "A1"."LOCATION_NAME" "LOCATION_NAME"
   ,"A1"."ADDRESS" "ADDRESS"
   ,"A1"."CITY" "CITY"
from
    (
        select
            "A2"."NAME" "LOCATION_NAME"
           ,"A2"."ADDRESS" "ADDRESS"
           ,"A2"."CITY" "CITY"
        from "PRACTICALPLSQL"."LOCATIONS" "A2"
    ) "A1"
order by "A1"."LOCATION_NAME"
