set feedback off
set serveroutput on;

create or replace package util_timing 
authid current_user
is

    subtype t_timing_name is varchar2(50);
    
    procedure start_timer(timer in t_timing_name);
    
    procedure print_timer(timer in t_timing_name);
    
    procedure stop_timer(timer in t_timing_name, print in boolean default true);
    
    procedure print_all_timers(heading in varchar2 default 'all timers', clear in boolean default true);
    
    procedure clear_timers;

end util_timing;
/

create or replace package body util_timing 
is

    type t_timing_rec is record(
        start_ts timestamp default localtimestamp,
        stop_ts timestamp default null
        );
    
    type t_timing_aa is table of t_timing_rec index by t_timing_name;

    g_timers t_timing_aa;
    
    procedure start_timer(timer in t_timing_name)
    is
    begin
        g_timers(timer).start_ts := localtimestamp;
    end start_timer;
    
    procedure print_timer(timer in t_timing_name)
    is
    begin
        dbms_output.put_line(timer || ' ' || to_char(g_timers(timer).stop_ts - g_timers(timer).start_ts));
    end print_timer;
    
    procedure stop_timer(timer in t_timing_name, print in boolean default true)
    is
    begin
        g_timers(timer).stop_ts := localtimestamp;
        if print 
            then print_timer(timer);
        end if;
    end stop_timer;
    
    procedure print_all_timers(heading in varchar2 default 'all timers', clear in boolean default true)
    is
    begin
        dbms_output.put_line(heading);
        for i in indices of g_timers loop
            print_timer(i);
        end loop;
        if clear then 
            clear_timers;
        end if;
    end print_all_timers;
    
    procedure clear_timers
    is
    begin
        g_timers.delete;
    end clear_timers;

end util_timing;
/


begin
    util_timing.start_timer('both');

    begin
        util_timing.start_timer('block1');
        dbms_output.put_line('block1 sleeps 1.5 seconds');
        dbms_session.sleep(1.5);
        util_timing.stop_timer('block1');
    end;
    
    begin
        util_timing.start_timer('block2');
        dbms_output.put_line('block2 sleeps 0.5 seconds');
        dbms_session.sleep(0.5);
        util_timing.stop_timer('block2');
    end;

    util_timing.stop_timer('both');
    
    util_timing.print_all_timers;
end;
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