set feedback off
set serveroutput on;

declare
    l_start date;
    l_days number;
begin
    for test in 1..5 loop
    
        l_start := sysdate;
        dbms_session.sleep(1.5);
        
        l_days := (sysdate - l_start);
        dbms_output.put_line(l_days || ' days');
    end loop;
end;
/

set feedback on

/*
.00001157407407407407407407407407407407407407 days
.00002314814814814814814814814814814814814815 days
.00001157407407407407407407407407407407407407 days
.00002314814814814814814814814814814814814815 days
.00001157407407407407407407407407407407407407 days
*/
