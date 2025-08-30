---simple framework for timing test iterations with multiple test variants

set serveroutput on;

declare
type r_timing is record(
    starts timestamp default localtimestamp, 
    ends timestamp default null, 
    duration interval day to second(9) default null, 
    loops number default 0, 
    counter varchar2(20) default null);
type r_timing_aa is table of r_timing index by pls_integer;
type r_timing_va is varray(10000) of r_timing;
r r_timing;
a r_timing_aa;
v r_timing_va;
jdoc json;

n_n number;
n_i integer;
n_pi pls_integer;
n_bd binary_double;
l_test_iterations number := 0;
l_start timestamp;
l_end timestamp;
l_method pls_integer := 4;--simple variables  2 record field assignment  3 record fields named association 4 record field named association defaults
begin



for j in 1..9, 10..90 by 10, 100..900 by 100, 1000..9000 by 1000, 10000..90000 by 10000 loop
    l_test_iterations := l_test_iterations + 1;

    case l_method
    when 1 then      
        l_start := localtimestamp;
    when 2 then      
        r.starts := localtimestamp;
    when 3 then 
        r := r_timing(starts => localtimestamp);
    when 4 then 
        r := r_timing();
    end case;
    
    for i integer in 1..j loop
        null;
    end loop;

    case l_method
    when 1 then
        l_end := localtimestamp;
        r.starts := l_start;
        r.ends := l_end;
    when 2, 3, 4 then
        r.ends := localtimestamp;
    end case;
    r.loops := j;
    r.counter := 'integer';
    r.duration := r.ends - r.starts;
    a(a.count + 1) := r;

    case l_method
    when 1 then      
        l_start := localtimestamp;
    when 2 then      
        r.starts := localtimestamp;
    when 3 then 
        r := r_timing(starts => localtimestamp);
    when 4 then 
        r := r_timing();
    end case;
    
    for i pls_integer in 1..j loop
        null;
    end loop;
    
    case l_method
    when 1 then
        l_end := localtimestamp;
        r.starts := l_start;
        r.ends := l_end;
    when 2, 3, 4 then
        r.ends := localtimestamp;
    end case;
    r.loops := j;
    r.counter := 'pls_integer';
    r.duration := r.ends - r.starts;
    a(a.count + 1) := r;

    
    case l_method
    when 1 then      
        l_start := localtimestamp;
    when 2 then      
        r.starts := localtimestamp;
    when 3 then 
        r := r_timing(starts => localtimestamp);
    when 4 then 
        r := r_timing();
    end case;

    for i number in 1..j loop
        null;
    end loop;
    
    case l_method
    when 1 then
        l_end := localtimestamp;
        r.starts := l_start;
        r.ends := l_end;
    when 2, 3, 4 then
        r.ends := localtimestamp;
    end case;
    r.loops := j;
    r.counter := 'number';
    r.duration := r.ends - r.starts;
    a(a.count + 1) := r;

    
    case l_method
    when 1 then      
        l_start := localtimestamp;
    when 2 then      
        r.starts := localtimestamp;
    when 3 then 
        r := r_timing(starts => localtimestamp);
    when 4 then 
        r := r_timing();
    end case;

    for i binary_double in 1..j loop
        null;
    end loop;
    
    case l_method
    when 1 then
        l_end := localtimestamp;
        r.starts := l_start;
        r.ends := l_end;
    when 2, 3, 4 then
        r.ends := localtimestamp;
    end case;
    r.loops := j;
    r.counter := 'binary_double';
    r.duration := r.ends - r.starts;
    a(a.count + 1) := r;

end loop;



v := r_timing_va(for i in 1..a.count index i => a(i));


jdoc := json(v);

--dbms_output.put_line(json_serialize(jdoc));

for r in (
select counter, sum(loops) as total_loops, to_char(sum(duration)) as total_time, to_char(avg(avg_dur)) as per_loop
from (
select
    j.*, j.duration/j.loops as avg_dur
from

json_table(
jdoc, '$[*]'
columns(STARTS timestamp, ENDS timestamp, DURATION interval day to second(9), LOOPS number, COUNTER varchar2(20))
) j
) group by counter
) loop

    dbms_output.put_line('counter datatype: ' || r.counter || ', loops ' || r.total_loops || ', total time: ' || r.total_time || ', average per loop: ' || r.per_loop);

end loop;

dbms_output.put_line('test iterations: ' || l_test_iterations);

end;
/

--select counter, sum(loops) as total_loops, sum(duration) as total_time, avg(avg_dur) as per_loop
--from (
--select
--    j.*, j.duration/j.loops as avg_dur
--from
--
--json_table(
--json(
--to_clob('[')
--|| to_clob('
--{"STARTS":"2025-06-28T07:09:17.454343","ENDS":"2025-06-28T07:09:17.454348","DURATION":"PT0.000005S","LOOPS":10,"COUNTER":"default"},{"STARTS":"2025-06-28T07:09:17.454352","ENDS":"2025-06-28T07:09:17.454352","DURATION":"P0D","LOOPS":10,"COUNTER":"pls_integer"},{"STARTS":"2025-06-28T07:09:17.454353","ENDS":"2025-06-28T07:09:17.454355","DURATION":"PT0.000002S","LOOPS":10,"COUNTER":"number"},{"STARTS":"2025-06-28T07:09:17.454356","ENDS":"2025-06-28T07:09:17.454358","DURATION":"PT0.000002S","LOOPS":10,"COUNTER":"binary_double"},{"STARTS":"2025-06-28T07:09:17.454359","ENDS":"2025-06-28T07:09:17.454359","DURATION":"P0D","LOOPS":25,"COUNTER":"default"},{"STARTS":"2025-06-28T07:09:17.454360","ENDS":"2025-06-28T07:09:17.454361","DURATION":"PT0.000001S","LOOPS":25,"COUNTER":"pls_integer"},{"STARTS":"2025-06-28T07:09:17.454361","ENDS":"2025-06-28T07:09:17.454363","DURATION":"PT0.000002S","LOOPS":25,"COUNTER":"number"},{"STARTS":"2025-06-28T07:09:17.454363","ENDS":"2025-06-28T07:09:17.454364","DURATION":"PT0.000001S","LOOPS":25,"COUNTER":"binary_double"},
--') || to_clob('
--{"STARTS":"2025-06-28T07:09:17.454365","ENDS":"2025-06-28T07:09:17.454366","DURATION":"PT0.000001S","LOOPS":50,"COUNTER":"default"},{"STARTS":"2025-06-28T07:09:17.454366","ENDS":"2025-06-28T07:09:17.454367","DURATION":"PT0.000001S","LOOPS":50,"COUNTER":"pls_integer"},{"STARTS":"2025-06-28T07:09:17.454367","ENDS":"2025-06-28T07:09:17.454369","DURATION":"PT0.000002S","LOOPS":50,"COUNTER":"number"},{"STARTS":"2025-06-28T07:09:17.454370","ENDS":"2025-06-28T07:09:17.454371","DURATION":"PT0.000001S","LOOPS":50,"COUNTER":"binary_double"},{"STARTS":"2025-06-28T07:09:17.454372","ENDS":"2025-06-28T07:09:17.454372","DURATION":"P0D","LOOPS":100,"COUNTER":"default"},{"STARTS":"2025-06-28T07:09:17.454373","ENDS":"2025-06-28T07:09:17.454373","DURATION":"P0D","LOOPS":100,"COUNTER":"pls_integer"},{"STARTS":"2025-06-28T07:09:17.454374","ENDS":"2025-06-28T07:09:17.454377","DURATION":"PT0.000003S","LOOPS":100,"COUNTER":"number"},{"STARTS":"2025-06-28T07:09:17.454378","ENDS":"2025-06-28T07:09:17.454380","DURATION":"PT0.000002S","LOOPS":100,"COUNTER":"binary_double"},
--') || to_clob('
--{"STARTS":"2025-06-28T07:09:17.454380","ENDS":"2025-06-28T07:09:17.454381","DURATION":"PT0.000001S","LOOPS":500,"COUNTER":"default"},{"STARTS":"2025-06-28T07:09:17.454381","ENDS":"2025-06-28T07:09:17.454382","DURATION":"PT0.000001S","LOOPS":500,"COUNTER":"pls_integer"},{"STARTS":"2025-06-28T07:09:17.454383","ENDS":"2025-06-28T07:09:17.454394","DURATION":"PT0.000011S","LOOPS":500,"COUNTER":"number"},{"STARTS":"2025-06-28T07:09:17.454395","ENDS":"2025-06-28T07:09:17.454403","DURATION":"PT0.000008S","LOOPS":500,"COUNTER":"binary_double"},{"STARTS":"2025-06-28T07:09:17.454404","ENDS":"2025-06-28T07:09:17.454404","DURATION":"P0D","LOOPS":1000,"COUNTER":"default"},{"STARTS":"2025-06-28T07:09:17.454405","ENDS":"2025-06-28T07:09:17.454405","DURATION":"P0D","LOOPS":1000,"COUNTER":"pls_integer"},{"STARTS":"2025-06-28T07:09:17.454406","ENDS":"2025-06-28T07:09:17.454428","DURATION":"PT0.000022S","LOOPS":1000,"COUNTER":"number"},{"STARTS":"2025-06-28T07:09:17.454429","ENDS":"2025-06-28T07:09:17.454445","DURATION":"PT0.000016S","LOOPS":1000,"COUNTER":"binary_double"},
--') || to_clob('
--{"STARTS":"2025-06-28T07:09:17.454446","ENDS":"2025-06-28T07:09:17.454446","DURATION":"P0D","LOOPS":5000,"COUNTER":"default"},{"STARTS":"2025-06-28T07:09:17.454447","ENDS":"2025-06-28T07:09:17.454447","DURATION":"P0D","LOOPS":5000,"COUNTER":"pls_integer"},{"STARTS":"2025-06-28T07:09:17.454449","ENDS":"2025-06-28T07:09:17.454554","DURATION":"PT0.000105S","LOOPS":5000,"COUNTER":"number"},{"STARTS":"2025-06-28T07:09:17.454555","ENDS":"2025-06-28T07:09:17.454633","DURATION":"PT0.000078S","LOOPS":5000,"COUNTER":"binary_double"},{"STARTS":"2025-06-28T07:09:17.454634","ENDS":"2025-06-28T07:09:17.454634","DURATION":"P0D","LOOPS":10000,"COUNTER":"default"},{"STARTS":"2025-06-28T07:09:17.454635","ENDS":"2025-06-28T07:09:17.454636","DURATION":"PT0.000001S","LOOPS":10000,"COUNTER":"pls_integer"},{"STARTS":"2025-06-28T07:09:17.454636","ENDS":"2025-06-28T07:09:17.454856","DURATION":"PT0.000220S","LOOPS":10000,"COUNTER":"number"},{"STARTS":"2025-06-28T07:09:17.454857","ENDS":"2025-06-28T07:09:17.455014","DURATION":"PT0.000157S","LOOPS":10000,"COUNTER":"binary_double"}
--') || to_clob(']')
--), '$[*]'
--columns(STARTS timestamp, ENDS timestamp, DURATION interval day to second(9), LOOPS number, COUNTER varchar2(20))
--) j
--) group by counter;