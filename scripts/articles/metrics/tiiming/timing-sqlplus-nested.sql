set feedback off
set serveroutput on
set timing on

begin

    begin
        dbms_output.put_line('block 1 sleeps 1.5 seconds');
        dbms_session.sleep(1.5);
    end;
    
    begin
        dbms_output.put_line('block 2 sleeps 0.5 seconds');
        dbms_session.sleep(0.5);
    end;

end;
/

set timing off
set feedback on

/*
block 1 sleeps 1.5 seconds
block 2 sleeps 0.5 seconds

Elapsed: 00:00:02.011
*/