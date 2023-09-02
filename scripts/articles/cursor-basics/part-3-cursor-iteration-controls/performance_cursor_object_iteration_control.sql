--this script requires procedure.print_timing_and_fetches.p from the simple-employees example
--the get_sql_engine_fetches function requires select rights on v_$sqlarea
set feedback off;
set serveroutput on;
alter session set plsql_optimize_level = 2;

prompt Cursor Iteration Performance: cursor object iteration controls
declare
    l_method varchar2(50) := 'cursor object iteration controls';
    l_start timestamp := localtimestamp;
    l_records number := 500001;
    l_fetches_previous number := get_sql_engine_fetches('cursor_iteration_performance');
    l_fetches number;
    type t_rec is record(
        seed varchar2(50),
        id   number,
        info varchar2(20));
    type t_rows is table of t_rec;
    l_rows t_rows := t_rows();
        
    cursor c_1 return t_rec is
        select 
            'cursor_iteration_performance' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= l_records;  
        
    cursor c_2 return t_rec is
        select 
            'cursor_iteration_performance' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= l_records;  
            
begin

    l_rows := t_rows(for r t_rec in c_1, c_2 sequence => r);

    l_fetches := get_sql_engine_fetches('cursor_iteration_performance') - l_fetches_previous;
    print_timing_and_fetches(l_start, l_fetches, l_rows.count, l_method);

exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

/* Script Output:
Cursor Iteration Performance: cursor object iteration controls
cursor object iteration controls
10002 fetches for 1000002 rows
1.082 seconds for 1000002 rows
*/