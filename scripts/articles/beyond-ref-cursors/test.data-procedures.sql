

set serveroutput on;

declare
    rc data_api.rc_data;
    t data_api.data_tab;
begin
    data_api.get_ref_cursor(50,rc);
    fetch rc bulk collect into t;
    close rc;
    
    for i in 1..t.count loop
        dbms_output.put_line(t(i).info);
    end loop;
    
end;
/

declare
    c clob;
begin
    data_api.get_json(50, c);
    dbms_output.put_line(c);
end;
/