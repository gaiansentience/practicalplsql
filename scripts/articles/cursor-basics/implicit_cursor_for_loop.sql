set serveroutput on;
declare
begin
    for r in (
        select level as id, 'item ' || level as info
        from dual connect by level <= 5) 
    loop
        dbms_output.put_line('processing ' || r.info);
    end loop;
end;
/