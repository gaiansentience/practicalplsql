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
