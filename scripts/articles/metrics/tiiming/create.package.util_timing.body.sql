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
