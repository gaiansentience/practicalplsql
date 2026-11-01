---simple framework for timing test iterations with multiple test variants

--using a locally declared record type and collection
--converting to varray prior to converting to json

set serveroutput on;

declare
type r_timing is record(
    starts timestamp default localtimestamp, 
    ends timestamp default null, 
    duration interval day(9) to second(9) default null, --ds_interval_unconstrained
    loops number default 0, 
    --result number default 0,
    iterand varchar2(20) default null,
    message varchar2(100) default null);
type r_timing_aa is table of r_timing index by pls_integer;
type r_timing_va is varray(100000) of r_timing;
r r_timing;
a r_timing_aa;
v r_timing_va;
jdoc json;

procedure start_test(l in number, i in varchar2)
is
begin
    r := r_timing(starts => localtimestamp, loops => l, iterand => i);
end start_test;

procedure end_test(m in varchar2 default null)
is
begin
    r.ends := localtimestamp;
    r.duration := r.ends - r.starts;
    r.message := m;
    a(a.count + 1) := r;
end end_test;

begin


--run tests

for j in 
    --1, 10, 100, 1000, 10000, 100000
    1..9
    , 10..90 by 10, 100..900 by 100
    , 1000..9000 by 1000
    , 10000..90000 by 10000
    --, 100000..900000 by 100000 
    loop


    start_test(j, 'pls_integer');
    
    for i pls_integer in 1..j loop
        null;
    end loop;
    
    end_test;

    start_test(j, 'simple_integer');
    
    for i simple_integer in 1..j loop
        null;
    end loop;
    
    end_test;

--    start_test(j, 'naturaln');
--    
--    for i naturaln in 1..j loop
--        null;
--    end loop;
--    
--    end_test;

    
    start_test(j, 'number');

    for i number in 1..j loop
        null;
    end loop;
    
    end_test;

--    start_test(j, 'float');
--    
--    for i float in 1..j loop
--        null;
--    end loop;
--
--    end_test;
--
--    start_test(j, 'real');
--    
--    for i real in 1..j loop
--        null;
--    end loop;
--
--    end_test;

    start_test(j, 'integer');
    
    for i integer in 1..j loop
        null;
    end loop;

    end_test;
    

    start_test(j, 'binary_float');

--    for i binary_float in 1..j loop
--        null;
--    end loop;
--    
--    end_test;
--
--    start_test(j, 'simple_float');
--
--    for i simple_float in 1..j loop
--        null;
--    end loop;
--    
--    end_test;

--    start_test(j, 'binary_double');
--
--    for i binary_double in 1..j loop
--        null;
--    end loop;
--    
--    end_test;

--    start_test(j, 'simple_double');
--
--    for i simple_double in 1..j loop
--        null;
--    end loop;
--    
--    end_test;

end loop;

dbms_output.put_line('test runs summarized: ' || a.count);


dbms_output.put_line('
summarizing results collection by converting to json and querying');

--invalid type error (locally declared collection)
--select json(a) into jdoc;

jdoc := json(a);
dbms_output.put_line('
json from associative array directly-each array element is a numbered attribute');
dbms_output.put_line(
json_serialize(jdoc returning clob));

jdoc := json_query(json(a),'$.*' with array wrapper);
dbms_output.put_line('
json from associative array - using json_query($.* with array wrapper) to convert map to array
');
dbms_output.put_line(json_serialize(jdoc returning clob));


--convert associative array to varray
v := r_timing_va(for i in 1..a.count index i => a(i));


jdoc := json(v);
dbms_output.put_line('
json from varray from associative array
');
dbms_output.put_line(json_serialize(jdoc returning clob));


dbms_output.put_line('
************
show results ordered from fastest to slowest overall
************');

for r in (

select iterand, sum(loops) as total_loops, to_char(sum(duration)) as total_time
    , to_char(
        sum(duration)/sum(loops)
        ) as per_loop
from (
select
    j.*
from

json_table(
jdoc, '$[*]'
columns(STARTS timestamp, ENDS timestamp, DURATION interval day to second(9), LOOPS number, ITERAND varchar2(20))
) j
) 
group by iterand
order by total_time

) loop

    dbms_output.put_line('iterand datatype: ' || r.iterand || ', loops ' || r.total_loops 
        || ', total time: ' || r.total_time || ', average loop: ' || r.per_loop);

end loop;


end;
/

