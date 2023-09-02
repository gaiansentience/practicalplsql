set serveroutput on;

create or replace function format_name (
    p_first in varchar2
   ,p_last  in varchar2
) return varchar2 sql_macro ( scalar ) 
is
begin
    return q'[p_first || ' ' || p_last]';
end format_name;
/

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := q'[
        select
            format_name(e.first_name, e.last_name) as employee 
        from 
            employees e
        ]';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

begin
dbms_output.put_line(format_name('first','last'));
end;
/

--scalar sql macro is not expanded
select
    "PRACTICALPLSQL"."FORMAT_NAME"("A1"."FIRST_NAME","A1"."LAST_NAME") "EMPLOYEE"
from
    "PRACTICALPLSQL"."EMPLOYEES" "A1";

drop function format_name;