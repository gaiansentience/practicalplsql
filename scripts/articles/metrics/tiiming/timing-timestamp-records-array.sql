set feedback off
set serveroutput on

declare
    type t_timing_rec is record(
        start_ts timestamp default localtimestamp,
        stop_ts timestamp default null
    );
    
    type t_timing_aa is table of t_timing_rec index by varchar2(20);
    t t_timing_aa;
begin
    t('both').start_ts := localtimestamp;

    begin
        t('block1').start_ts := localtimestamp;
        dbms_output.put_line('block1 sleeps 1.5 seconds');
        dbms_session.sleep(1.5);
        t('block1').stop_ts := localtimestamp;
        dbms_output.put_line('block1 ' || to_char(t('block1').stop_ts - t('block1').start_ts));
    end;
    
    begin
        t('block2').start_ts := localtimestamp;
        dbms_output.put_line('block2 sleeps 0.5 seconds');
        dbms_session.sleep(0.5);
        t('block2').stop_ts := localtimestamp;
        dbms_output.put_line('block2 ' || to_char(t('block2').stop_ts - t('block2').start_ts));
    end;

    t('both').stop_ts := localtimestamp;
    dbms_output.put_line('both ' || to_char(t('both').stop_ts - t('both').start_ts));
    
    dbms_output.put_line('all timers');
    for i, r in pairs of t loop
        dbms_output.put_line(i || ' ' || to_char(r.stop_ts - r.start_ts));
    end loop;
end main_block;
/

set feedback on
/*
block1 sleeps 1.5 seconds
block1 +000000000 00:00:01.500862000
block2 sleeps 0.5 seconds
block2 +000000000 00:00:00.504464000
both +000000000 00:00:02.005376000
all timers
block1 +000000000 00:00:01.500862000
block2 +000000000 00:00:00.504464000
both +000000000 00:00:02.005376000
*/