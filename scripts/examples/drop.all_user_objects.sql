prompt dropping all example objects for PRACTICALPLSQL
set serveroutput on;

declare
cursor c is
select 
object_type || ' ' || object_name as object,
'drop ' || object_type || ' ' || object_name 
|| case object_type when 'TABLE' then ' purge' end as ddl
from user_objects
where object_type in ('FUNCTION','PROCEDURE','TYPE','TABLE','VIEW','SEQUENCE', 'PACKAGE');

begin

    if user not in ('CLOUD_PRACTICALPLSQL', 'PRACTICALPLSQL') then
        raise_application_error(-20100, 'script intended to remove all example objects in PRACTICALPLSQL schema, cancelling execution for ' || user);
    end if;

    for r in c loop
        dbms_output.put_line('dropping ' || r.object);
        begin
            execute immediate r.ddl;
        exception
            when others then
                dbms_output.put_line(sqlerrm);
        end;
    end loop;

exception
    when others then
        dbms_output.put_line('Error encountered: ' || sqlerrm);
end;
/