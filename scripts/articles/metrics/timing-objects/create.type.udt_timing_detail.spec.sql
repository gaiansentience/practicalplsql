create or replace type udt_timing_detail as object(
    name varchar2(100),
    start_ts timestamp,
    stop_ts timestamp,
    constructor function udt_timing_detail(n in varchar2 default null) return self as result,
    member procedure start_timer(t in timestamp default localtimestamp),
    member procedure stop_timer(t in timestamp default localtimestamp, print in boolean default true),
    member function get_timing return interval day to second,
    member procedure print_timer
)
/
