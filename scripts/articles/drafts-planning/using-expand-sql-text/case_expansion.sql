set serveroutput on;

declare
    l_sql          clob;
    l_expanded_sql clob;
begin
    l_sql := q'[
        select 
            case code
                when 'MANAGER' then 'Being Busy'
                when 'ASSOCIATE' then 'Getting Things Done'
                else 'Not so clear'
            end as responsibilities
        from jobs 
        ]';
    dbms_utility.expand_sql_text(l_sql,l_expanded_sql);
    dbms_output.put_line(l_expanded_sql);
end;
/

select
    case "A1"."CODE"
        when 'MANAGER'   then 'Being Busy'
        when 'ASSOCIATE' then 'Getting Things Done'
        else 'Not so clear'
    end "RESPONSIBILITIES"
from
    "PRACTICALPLSQL"."JOBS" "A1";