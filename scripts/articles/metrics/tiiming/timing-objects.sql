set feedback off
set serveroutput on;

drop type if exists udt_timing;
drop type if exists udt_timing_detail_nt;
drop type if exists udt_timing_detail;

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

create or replace type body udt_timing_detail
as
    constructor function udt_timing_detail(n in varchar2 default null) return self as result
    is
    begin
        self.name := n;
        return;
    end udt_timing_detail;
    
    member procedure start_timer(t in timestamp default localtimestamp)
    is
    begin
        self.start_ts := t;
    end start_timer;
    
    member procedure stop_timer(t in timestamp default localtimestamp, print in boolean default true)
    is
    begin
        self.stop_ts := t;
        if print then
            self.print_timer;
        end if;
    end stop_timer;
    
    member function get_timing return interval day to second
    is
    begin
        return self.stop_ts - self.start_ts;
    end get_timing;
    
    member procedure print_timer
    is
    begin
        dbms_output.put_line(self.name || ' ' || to_char(self.get_timing));
    end print_timer;
end;
/

create or replace type udt_timing_detail_nt as table of udt_timing_detail
/

create or replace type udt_timing as object(
    details udt_timing_detail_nt,
    constructor function udt_timing return self as result,
    member procedure add_timer(n in varchar2),
    member function get_timer_index(n in varchar2) return number,
    member procedure start_timer(n in varchar2),
    member procedure stop_timer(n in varchar2, print in boolean default true),
    member procedure print_timer(n in varchar2),
    member procedure print_all_timers(h in varchar2 default 'all timers', clear in boolean default true),
    member procedure clear_timers
)
/

create or replace type body udt_timing
is
    constructor function udt_timing return self as result
    is
    begin
        self.details := udt_timing_detail_nt();
        return;
    end udt_timing;
    
    member procedure add_timer(n in varchar2)
    is
    begin
        self.details.extend();
        self.details(self.details.last) := udt_timing_detail(n);
    end add_timer;

    member function get_timer_index(n in varchar2) return number
    is
        l_index number;
    begin
        for idx in 1..self.details.count loop
            if self.details(idx).name = n then
                l_index := idx;
                exit;
            end if;
        end loop;
        return l_index;
    end get_timer_index;
                
    member procedure start_timer(n in varchar2)
    is
        l_index number;
        t timestamp := localtimestamp;
    begin
        l_index := get_timer_index(n);
        if l_index is null then
            self.add_timer(n);
            l_index := self.details.last;
        end if;
        self.details(l_index).start_timer(t);
    end start_timer;
        
    member procedure stop_timer(n in varchar2, print in boolean default true)
    is
        l_index number;
        t timestamp := localtimestamp;
    begin
        l_index := get_timer_index(n);
        self.details(l_index).stop_timer(t, print);
    end stop_timer;
    
    member procedure print_timer(n in varchar2)
    is
        l_index number;
    begin
        l_index := get_timer_index(n);
        self.details(l_index).print_timer;
    end print_timer;
    
    member procedure print_all_timers(h in varchar2 default 'all timers', clear in boolean default true)
    is
    begin
        dbms_output.put_line(h);
        for idx in 1..self.details.count loop
            self.details(idx).print_timer;
        end loop;
        if clear then
            self.clear_timers;
        end if;
    end print_all_timers;
    
    member procedure clear_timers
    is
    begin
        self.details.delete;
    end clear_timers;

end;
/

declare
    t udt_timing := udt_timing();
begin
    t.start_timer('both');

    begin
        t.start_timer('block1');
        dbms_output.put_line('block1 sleeps 1.5 seconds');
        dbms_session.sleep(1.5);
        t.stop_timer('block1');
    end;
    
    begin
        t.start_timer('block2');
        dbms_output.put_line('block2 sleeps 0.5 seconds');
        dbms_session.sleep(0.5);
        t.stop_timer('block2');
    end;

    t.stop_timer('both');
    
    t.print_all_timers;
end;
/

set feedback on

/*
block1 sleeps 1.5 seconds
block1 +00 00:00:01.500200
block2 sleeps 0.5 seconds
block2 +00 00:00:00.500131
both +00 00:00:02.000738
all timers
both +00 00:00:02.000738
block1 +00 00:00:01.500200
block2 +00 00:00:00.500131
*/