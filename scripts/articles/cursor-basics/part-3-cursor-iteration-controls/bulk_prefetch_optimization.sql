--this script requires function.get_sql_engine_fetches.f and select rights on v_$sqlarea
set feedback off;
set serveroutput on;

prompt Cursor Iteration Control Bulk Optimization
alter session set plsql_optimize_level = 0;
declare
    l_records number;
    l_fetches_previous number;
    l_fetches number;
    c_data sys_refcursor; 
	type t_iterand is record(seed varchar2(50), id number, info varchar2(4000));
begin

	open c_data for 
        select 
            'cursor_iteration_control_bulk_prefetch' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= 500;   

    l_fetches_previous := get_sql_engine_fetches('cursor_iteration_control_bulk_prefetch');

	for r t_iterand in c_data loop	
		l_records := l_records + 1;
	end loop;

    l_fetches := get_sql_engine_fetches('cursor_iteration_control_bulk_prefetch') - l_fetches_previous;
    
    dbms_output.put_line('plsql_optimize_level = ' || $$plsql_optimize_level || ': ' 
        || l_fetches || ' fetches for ' || l_records || ' records');
end;
/

alter session set plsql_optimize_level = 2;
declare
    l_records number := 0;
    l_fetches_previous number;
    l_fetches number;
cursor c_data is
        select 
            'cursor_iteration_control_bulk_prefetch' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= 500;   

cursor c_data1 is
        select 
            'cursor_iteration_control_bulk_prefetch' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= 500;   

    cv_data sys_refcursor; 
	type t_iterand is record(seed varchar2(50), id number, info varchar2(4000));
begin

	open cv_data for 
        select 
            'cursor_iteration_control_bulk_prefetch' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= 500;   

    l_fetches_previous := get_sql_engine_fetches('cursor_iteration_control_bulk_prefetch');

	for r t_iterand in c_data, c_data1, c_data loop	
		l_records := l_records + 1;
	end loop;

    l_fetches := get_sql_engine_fetches('cursor_iteration_control_bulk_prefetch') - l_fetches_previous;
    
    dbms_output.put_line('plsql_optimize_level = ' || $$plsql_optimize_level || ': ' 
        || l_fetches || ' fetches for ' || l_records || ' records');
end;
/
