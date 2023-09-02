set serveroutput on;
column plan_table_output format a100;
set pagesize 0;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := '
        select 
            count(rowid) as total_employees_r, 
            count(1) as total_employees_1, 
            count(*) as total_employees_star, 
            count(location_id) as total_employees_with_locations 
        from employees 
        having 
            count(1) = count(*) 
            or count(rowid) = count(1)
        ';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/
/*
--nothing changes for the expansion
select
    count("A1".rowid) "TOTAL_EMPLOYEES_R"
   ,count(1) "TOTAL_EMPLOYEES_1"
   ,count(*) "TOTAL_EMPLOYEES_STAR"
   ,count("A1"."LOCATION_ID") "TOTAL_EMPLOYEES_WITH_LOCATIONS"
from
    "PRACTICALPLSQL"."EMPLOYEES" "A1"
having 
    count(1) = count(*) 
    or count("A1".rowid) = count(1);
*/    
explain plan for    
select
    count("A1".rowid) "TOTAL_EMPLOYEES_R"
   ,count(1) "TOTAL_EMPLOYEES_1"
   ,count(*) "TOTAL_EMPLOYEES_STAR"
   ,count("A1"."LOCATION_ID") "TOTAL_EMPLOYEES_WITH_LOCATIONS"
from
    "PRACTICALPLSQL"."EMPLOYEES" "A1"
having 
    count(1) = count(*) 
    or count("A1".rowid) = count(1);
    
select * from dbms_xplan.display();