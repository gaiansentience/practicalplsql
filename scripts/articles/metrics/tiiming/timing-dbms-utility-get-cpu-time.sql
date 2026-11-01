set feedback off
set serveroutput on

declare
    l_start number;
begin

    begin
        l_start := dbms_utility.get_cpu_time;

        dbms_output.put_line('block 1 sleeps 1.5 seconds');
        dbms_session.sleep(1.5);

        dbms_output.put_line('block 1: ' || to_char(dbms_utility.get_cpu_time - l_start) || ' centiseconds cpu time');
    end;
    
    declare
        n number;
    begin
        l_start := dbms_utility.get_cpu_time;

        dbms_output.put_line('block 2 adds a million numbers squared');
        for i in 1..1e6 loop
            n := n + power(i, 2);
        end loop;

        dbms_output.put_line('block 2: ' || to_char(dbms_utility.get_cpu_time - l_start) || ' centiseconds cpu time');
    end;


end;
/

set feedback on

/*
block 1 sleeps 1.5 seconds
block 1: 0 centiseconds cpu time
block 2 adds a million numbers squared
block 2: 1 centiseconds cpu time
*/