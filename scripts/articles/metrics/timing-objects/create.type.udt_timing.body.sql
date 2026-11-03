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
                
    member procedure get_timer_index(n in varchar2, i out number)
    is
    begin
        i := get_timer_index(n);
        if i is null then
            self.add_timer(n);
            i := self.details.last;
        end if;
    end get_timer_index;

    member procedure start_timer(n in varchar2)
    is
        l_index number;
        t timestamp := localtimestamp;
    begin
        self.get_timer_index(n, l_index);
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