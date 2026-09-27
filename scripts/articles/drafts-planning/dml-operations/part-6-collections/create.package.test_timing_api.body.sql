create or replace package body test_timing_api as

    g_test t_test_rec;    
    g_results t_test_nt := t_test_nt();
        
    procedure p(msg in varchar2)
    is
    begin
        dbms_output.put_line(msg);
    end p;
        
    procedure start_test(name in t_test_name, details in number default null)
    is
    begin
        g_test := t_test_rec(name, details, localtimestamp);
    end start_test;
    
    procedure submit_test
    is
    begin
        g_results.extend;
        g_results(g_results.last) := g_test;
    end submit_test; 
    
    procedure print_test(t in t_test_rec)
    is
    begin
        p('duration => ' || to_char(t.duration)
            || case when t.details is not null then ', details => ' || t.details end
            || ', test => ' || t.name);
    end print_test;
    
    procedure stop_test(print in boolean default false)
    is
    begin
        g_test.duration := localtimestamp - g_test.started;
        if print then print_test(g_test); end if;
        submit_test;        
    end stop_test;
    
    procedure print_results
    is
    begin
        p('Comparing ' || g_results.count || ' test cases, ordered from best to worst');
        
        for i,v in pairs of (
            select b.duration, b.details, b.name
                , round(best_seconds/test_seconds,4) * 100 || '%' as ratio_to_best
                , round(worst_seconds/test_seconds,4) * 100 || '%' as ratio_to_worst
                , round(avg_seconds/test_seconds,4) * 100 || '%' as ratio_to_avg
            from 
                (
                select 
                    t.duration
                    , extract(second from t.duration) as test_seconds
                    ,t.details, t.name
                    , extract(second from min(t.duration) over ()) as best_seconds
                    , extract(second from max(t.duration) over ()) as worst_seconds
                    , extract(second from avg(t.duration) over ()) as avg_seconds
                from table(g_results) t
                ) b
            order by b.duration
        ) loop
            p(i || ') duration => ' || to_char(v.duration) 
                || case when v.details is not null then ', details => ' || v.details end
                || ', test => ' || v.name
                || ', ratio to best ' || v.ratio_to_best
                || ', ratio to worst ' || v.ratio_to_worst
                || ', ratio_to_avg ' || v.ratio_to_avg);
        end loop;
    end print_results;
    
    procedure print_error
    is
    begin
        p('Errors for test => ' || g_test.name || ' ' || sqlerrm);
    end print_error;
    
    procedure initialize
    is
    begin
        g_results := t_test_nt();
    end initialize;

end test_timing_api;
/
