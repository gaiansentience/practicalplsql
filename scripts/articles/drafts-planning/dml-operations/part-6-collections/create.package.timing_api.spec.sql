


create or replace package test_timing_api as

    subtype t_test_name is varchar2(100);
    
    type t_test_rec is record (
        name t_test_name,
        details number,
        started timestamp,
        duration interval day to second(9) default null
        );

    type t_test_nt is table of t_test_rec;

    procedure start_test(nm in t_test_name, dtls in number default null);
    
    procedure stop_test;
    
    procedure print_test_errors;
    
    procedure print_results;
    
end test_timing_api;
/

create or replace package body test_timing_api as

    g_test t_test_rec;    
    g_results t_test_nt := t_test_nt();
        
    procedure p(msg in varchar2)
    is
    begin
        dbms_output.put_line(msg);
    end p;
        
    procedure start_test(nm in t_test_name, dtls in number default null)
    is
    begin
        g_test := t_test_rec(nm, dtls, localtimestamp);
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
            || ', details => ' || t.details
            || ', test => ' || t.name);
    end print_test;
    
    procedure stop_test
    is
    begin
        g_test.duration := localtimestamp - g_test.started;
        print_test(g_test);
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
            p(i || ') duration =>' || to_char(v.duration) || ', details => ' || v.details || ', test => ' || v.name
                || ', ratio to best: ' || v.ratio_to_best
                || ', ratio to worst: ' || v.ratio_to_worst
                || ', ratio_to_avg: ' || v.ratio_to_avg);
        end loop;
    end print_results;
    
    procedure print_test_errors
    is
    begin
        p('Errors: ' || g_test.name || ' ' || sqlerrm);
    end print_test_errors;

end test_timing_api;
/

