set feedback off
set serveroutput on
alter session set time_zone = 'america/new_york';

declare
    l_start timestamp;
begin

    begin
        l_start := cast(systimestamp as timestamp);

        dbms_output.put_line('block 1 sleeps 1.5 seconds');
        dbms_session.sleep(1.5);

        dbms_output.put_line('block 1: ' || to_char(cast(systimestamp as timestamp) - l_start));
    end;
    
    begin
        l_start := systimestamp;

        dbms_output.put_line('block 2 sleeps 0.5 seconds');
        dbms_session.sleep(0.5);

        dbms_output.put_line('block 2: ' || to_char(cast(systimestamp as timestamp) - l_start));
    end;

end;
/

set feedback on

/*
block 1 sleeps 1.5 seconds
block 1: +000000000 00:00:01.500726000
block 2 sleeps 0.5 seconds
block 2: +000000000 00:00:00.510885000
*/