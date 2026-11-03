create or replace type udt_timing as object(
    details udt_timing_detail_nt,
    constructor function udt_timing return self as result,
    member procedure add_timer(n in varchar2),
    member function get_timer_index(n in varchar2) return number,
    member procedure get_timer_index(n in varchar2, i out number),
    member procedure start_timer(n in varchar2),
    member procedure stop_timer(n in varchar2, print in boolean default true),
    member procedure print_timer(n in varchar2),
    member procedure print_all_timers(h in varchar2 default 'all timers', clear in boolean default true),
    member procedure clear_timers
)
/