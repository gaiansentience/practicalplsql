set feedback off
set serveroutput on;

declare
    l_start date;
    l_seconds number;
begin
    for test in 1..5 loop
    
        l_start := sysdate;
        dbms_session.sleep(1.5);
        
        l_seconds := (sysdate - l_start) * 24 * 60 * 60;
        dbms_output.put_line(l_seconds || ' seconds');
    end loop;
end;
/

set feedback on

/*
2 seconds
1 seconds
2 seconds
1 seconds
2 seconds
*/