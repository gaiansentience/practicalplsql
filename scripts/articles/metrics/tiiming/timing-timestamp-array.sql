set feedback off
set serveroutput on

declare
    type t_timing_aa is table of timestamp index by varchar2(20);
    t t_timing_aa;
begin
    t('both') := localtimestamp;

    begin
        t('block1') := localtimestamp;
        dbms_output.put_line('block1 sleeps 1.5 seconds');
        dbms_session.sleep(1.5);
        dbms_output.put_line('block1 ' || to_char(localtimestamp - t('block1')));
    end;
    
    begin
        t('block2') := localtimestamp;
        dbms_output.put_line('block2 sleeps 0.5 seconds');
        dbms_session.sleep(0.5);
        dbms_output.put_line('block2 ' || to_char(localtimestamp - t('block2')));
    end;

    dbms_output.put_line('both ' || to_char(localtimestamp - t('both')));
    
end;
/

set feedback on

/*
block1 sleeps 1.5 seconds
block1 +000000000 00:00:01.514804000
block2 sleeps 0.5 seconds
block2 +000000000 00:00:00.500157000
both +000000000 00:00:02.015022000
*/