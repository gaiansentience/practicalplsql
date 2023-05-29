set serveroutput on;
declare
    cursor cur_data is
    select level as id, 'item ' || level as info
    from dual connect by level <= 5;    
begin
    for r in cur_data loop
        dbms_output.put_line('Processing ' || r.info);
    end loop;
end;
/

/*
Processing item 1
Processing item 2
Processing item 3
Processing item 4
Processing item 5
*/
