--this script requires function.get_sql_engine_fetches.f and select rights on v_$sqlarea
set feedback off;
set serveroutput on;

prompt Cursor Iteration Control Bulk Optimization
create or replace procedure cursor_iteration_control_optimization
is
    l_records number := 1000;
    l_fetches_previous number;
    l_fetches number;
    cursor cur_data is
        select 
            'cursor_iteration_control_optimization' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= l_records;  
        
    c_data sys_refcursor; 

    type t_rows is table of cur_data%rowtype index by pls_integer;
    l_row_table t_rows;
begin

	open c_data for 
        select 
            'cursor_iteration_control_optimization' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= l_records;  


    l_fetches_previous := get_sql_engine_fetches('cursor_iteration_control_optimization');

    l_row_table := t_rows(for r cur_data%rowtype in cur_data sequence => r);

    l_fetches := get_sql_engine_fetches('cursor_iteration_control_optimization') - l_fetches_previous;
    
    dbms_output.put_line('plsql_optimize_level = ' || $$plsql_optimize_level || ': ' 
        || l_fetches || ' fetches for ' || l_records || ' records');
end cursor_iteration_control_optimization;
/

alter procedure cursor_iteration_control_optimization compile plsql_optimize_level=0;
begin
    cursor_iteration_control_optimization;
end;
/

alter procedure cursor_iteration_control_optimization compile plsql_optimize_level=1;
begin
    cursor_iteration_control_optimization;
end;
/

alter procedure cursor_iteration_control_optimization compile plsql_optimize_level=2;
begin
    cursor_iteration_control_optimization;
end;
/

alter procedure cursor_iteration_control_optimization compile plsql_optimize_level=3;
begin
    cursor_iteration_control_optimization;
end;
/

drop procedure cursor_iteration_control_optimization;
/*
plsql_optimize_level = 0: 1001 fetches for 1000 records
plsql_optimize_level = 1: 1001 fetches for 1000 records
plsql_optimize_level = 2: 11 fetches for 1000 records
plsql_optimize_level = 3: 11 fetches for 1000 records
*/