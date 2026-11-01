set feedback off
set serveroutput on
set timing on

begin
    dbms_output.put_line('first block sleeps 1.5 seconds');
    dbms_session.sleep(1.5);
end;
/

begin
    dbms_output.put_line('second block sleeps 0.5 seconds');
    dbms_session.sleep(0.5);
end;
/

set timing off
set feedback on

/*
first block sleeps 1.5 seconds

Elapsed: 00:00:01.561
second block sleeps 0.5 seconds

Elapsed: 00:00:00.609
*/