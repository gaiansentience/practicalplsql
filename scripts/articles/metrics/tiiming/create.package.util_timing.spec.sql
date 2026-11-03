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
