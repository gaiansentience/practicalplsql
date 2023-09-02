--this script requires function.get_sql_engine_fetches.f and select rights on v_$sqlarea
--this script requires procedure.print_timing.p

set feedback off;
set serveroutput on;

prompt Cursor For Loop Optimization
create or replace procedure cursor_for_loop_optimization
is
    l_records number := 500000;
    l_start timestamp := localtimestamp;
    l_fetches_previous number;
    l_fetches number;
    cursor cur_data is
        select 
            'cursor_for_loop_optimization' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= l_records;   
begin

    l_fetches_previous := get_sql_engine_fetches('cursor_for_loop_optimization');
    
    for r in cur_data loop
        null;
    end loop;

    l_fetches := get_sql_engine_fetches('cursor_for_loop_optimization') - l_fetches_previous;
    
    dbms_output.put(l_fetches || ' fetches, ');
    print_timing(l_start, l_records, 'cursor for loop, optimize_level ' || $$plsql_optimize_level);

end cursor_for_loop_optimization;
/

alter procedure cursor_for_loop_optimization compile plsql_optimize_level=0;
begin
    cursor_for_loop_optimization;
end;
/

alter procedure cursor_for_loop_optimization compile plsql_optimize_level=1;
begin
    cursor_for_loop_optimization;
end;
/

alter procedure cursor_for_loop_optimization compile plsql_optimize_level=2;
begin
    cursor_for_loop_optimization;
end;
/

drop procedure cursor_for_loop_optimization;
/*
Cursor For Loop Optimization
500001 fetches, 0.992 seconds for 500000 rows: cursor for loop, optimize_level 0
500001 fetches, 0.999 seconds for 500000 rows: cursor for loop, optimize_level 1
5001 fetches, 0.333 seconds for 500000 rows: cursor for loop, optimize_level 2
*/