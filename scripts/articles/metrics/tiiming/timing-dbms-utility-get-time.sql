set feedback off
set serveroutput on

declare
    l_start number;
begin

    begin
        l_start := dbms_utility.get_time;

        dbms_output.put_line('block 1 sleeps 1.5 seconds');
        dbms_session.sleep(1.5);

        dbms_output.put_line('block 1: ' || to_char(dbms_utility.get_time - l_start) || ' centiseconds');
    end;
    
    begin
        l_start := dbms_utility.get_time;

        dbms_output.put_line('block 2 sleeps 0.5 seconds');
        dbms_session.sleep(0.5);

        dbms_output.put_line('block 2: ' || to_char(dbms_utility.get_time - l_start) || ' centiseconds');
    end;

end;
/

set feedback on

/*
block 1 sleeps 1.5 seconds
block 1: 150 centiseconds
block 2 sleeps 0.5 seconds
block 2: 51 centiseconds
*/