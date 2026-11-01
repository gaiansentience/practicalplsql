set feedback off
set serveroutput on

declare
    type t_timing_rec is record(
        start_ts timestamp default localtimestamp,
        stop_ts timestamp default null
    );
    
    type t_timing_aa is table of t_timing_rec index by varchar2(20);
    t t_timing_aa;
        
    procedure start_timer(timer in varchar2)
    is
    begin
        t(timer).start_ts := localtimestamp;
    end start_timer;
    
    procedure print_timer(timer in varchar2)
    is
    begin
        dbms_output.put_line(timer || ' ' || to_char(t(timer).stop_ts - t(timer).start_ts));
    end print_timer;
    
    procedure stop_timer(timer in varchar2, print in boolean default true)
    is
    begin
        t(timer).stop_ts := localtimestamp;
        if print 
            then print_timer(timer);
        end if;
    end stop_timer;
    
    procedure print_timers(heading in varchar2 default 'all timers')
    is
    begin
        dbms_output.put_line(heading);
        for i in indices of t loop
            print_timer(i);
        end loop;
    end print_timers;
begin
    start_timer('both');

    begin
        start_timer('block1');
        dbms_output.put_line('block1 sleeps 1.5 seconds');
        dbms_session.sleep(1.5);
        stop_timer('block1');
    end;
    
    begin
        start_timer('block2');
        dbms_output.put_line('block2 sleeps 0.5 seconds');
        dbms_session.sleep(0.5);
        stop_timer('block2');
    end;

    stop_timer('both');
    
    print_timers;
end main_block;
/

set feedback on
/*
block1 sleeps 1.5 seconds
block1 +000000000 00:00:01.535869000
block2 sleeps 0.5 seconds
block2 +000000000 00:00:00.524612000
both +000000000 00:00:02.060540000
all timers
block1 +000000000 00:00:01.535869000
block2 +000000000 00:00:00.524612000
both +000000000 00:00:02.060540000
*/