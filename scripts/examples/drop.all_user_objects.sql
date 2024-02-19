prompt dropping all user objects
set serveroutput on;

declare
cursor c is
select 
object_type || ' ' || object_name as object,
'drop ' || object_type || ' ' || object_name 
|| case object_type when 'TABLE' then ' purge' end as ddl
from user_objects
where object_type in ('FUNCTION','PROCEDURE','TYPE','TABLE','VIEW','SEQUENCE');

begin

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