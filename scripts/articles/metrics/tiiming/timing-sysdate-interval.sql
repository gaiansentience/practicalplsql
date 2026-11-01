set feedback off
set serveroutput on;

declare
    l_start date;
    l_timing dsinterval_unconstrained;
begin
    for test in 1..5 loop
    
        l_start := sysdate;
        dbms_session.sleep(1.5);
        
        l_timing := (sysdate - l_start) day to second;
        dbms_output.put_line(to_char(l_timing));
    end loop;
end;
/

set feedback on

/*
+000000000 00:00:01.000000000
+000000000 00:00:02.000000000
+000000000 00:00:01.000000000
+000000000 00:00:02.000000000
+000000000 00:00:01.000000000
*/