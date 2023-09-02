--this script requires procedure.print_timing_and_fetches.p from the simple-employees example
--the get_sql_engine_fetches function requires select rights on v_$sqlarea
set feedback off;
set serveroutput on;
alter session set plsql_optimize_level = 2;

prompt Cursor Iteration Performance: Oracle version comparison
begin
    dbms_output.put_line('Begin Tests: Oracle Version ' || dbms_db_version.version);
end;
/

--open fetch close
declare
    l_method varchar2(50) := 'open, fetch, close';
    l_start timestamp := localtimestamp;
    l_records number := 500001;
    l_fetches_previous number := get_sql_engine_fetches('cursor_iteration_performance');
    l_fetches number;
    type t_rec is record(
        seed varchar2(50),
        id   number,
        info varchar2(20));
    l_rec t_rec;
    type t_rows is table of t_rec;
    l_rows t_rows := t_rows();
                    
    cv_1 sys_refcursor; 
    cv_2 sys_refcursor;

    l_sql varchar2(1000) := q'[    
        select 
            'cursor_iteration_performance' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= ]' || l_records;
begin

	open cv_1 for l_sql;
    loop
        fetch cv_1 into l_rec;
        exit when cv_1%notfound;
            l_rows.extend();
            l_rows(l_rows.last) := l_rec;
    end loop;
    close cv_1;
            
	open cv_2 for l_sql;
    loop
        fetch cv_2 into l_rec;
        exit when cv_2%notfound;
            l_rows.extend();
            l_rows(l_rows.last) := l_rec;
    end loop;
    close cv_2;

    l_fetches := get_sql_engine_fetches('cursor_iteration_performance') - l_fetches_previous;
    print_timing_and_fetches(l_start, l_fetches, l_rows.count, l_method);

exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

--bulk collect limit
declare
    l_method varchar2(50) := 'bulk collect limit 100';
    l_start timestamp := localtimestamp;
    l_records number := 500001;
    l_fetches_previous number := get_sql_engine_fetches('cursor_iteration_performance');
    l_fetches number;
    type t_rec is record(
        seed varchar2(50),
        id   number,
        info varchar2(20));
    type t_rows is table of t_rec;
    l_rows_partial t_rows := t_rows();
    l_rows t_rows := t_rows();
                    
    cv_1 sys_refcursor; 
    cv_2 sys_refcursor;

    l_sql varchar2(1000) := q'[    
        select 
            'cursor_iteration_performance' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= ]' || l_records;
begin

	open cv_1 for l_sql;
    loop
        fetch cv_1 bulk collect into l_rows_partial limit 100;
        exit when l_rows_partial.count = 0;
        for i in indices of l_rows_partial loop
            l_rows.extend();
            l_rows(l_rows.last) := l_rows_partial(i);
        end loop;        
    end loop;
    close cv_1;
            
	open cv_2 for l_sql;
    loop
        fetch cv_2 bulk collect into l_rows_partial limit 100;
        exit when l_rows_partial.count = 0;
        for i in indices of l_rows_partial loop
            l_rows.extend();
            l_rows(l_rows.last) := l_rows_partial(i);
        end loop;        
    end loop;
    close cv_2;

    l_fetches := get_sql_engine_fetches('cursor_iteration_performance') - l_fetches_previous;
    print_timing_and_fetches(l_start, l_fetches, l_rows.count, l_method);

exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

--cursor for loop
declare
    l_method varchar2(50) := 'cursor for loops';
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

    for r in c_1 loop
        l_rows.extend();
        l_rows(l_rows.last) := r;
    end loop;    
    for r in c_2 loop
        l_rows.extend();
        l_rows(l_rows.last) := r;
    end loop;
        
    l_fetches := get_sql_engine_fetches('cursor_iteration_performance') - l_fetches_previous;
    print_timing_and_fetches(l_start, l_fetches, l_rows.count, l_method);
    
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

--cursor object iteration control
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

--sql iteration control
declare
    l_method varchar2(50) := 'sql iteration controls';
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
begin

    l_rows := t_rows(for r t_rec in (
        select 
            'cursor_iteration_performance' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= l_records
        ), (
        select 
            'cursor_iteration_performance' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= l_records          
        ) sequence => r);

    l_fetches := get_sql_engine_fetches('cursor_iteration_performance') - l_fetches_previous;
    print_timing_and_fetches(l_start, l_fetches, l_rows.count, l_method);
    
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

--cursor variable iteration controls
declare
    l_method varchar2(50) := 'cursor variable iteration controls';
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
                    
    cv_1 sys_refcursor; 
    cv_2 sys_refcursor;
    l_sql varchar2(1000) := q'[    
        select 
            'cursor_iteration_performance' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= ]' || l_records;
begin

	open cv_1 for l_sql;
	open cv_2 for l_sql;
    l_rows := t_rows(for r t_rec in cv_1, cv_2 sequence => r);
    close cv_1;
    close cv_2;
    
    l_fetches := get_sql_engine_fetches('cursor_iteration_performance') - l_fetches_previous;
    print_timing_and_fetches(l_start, l_fetches, l_rows.count, l_method);
    
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

--dynamic sql iteration control
declare
    l_method varchar2(50) := 'dynamic sql iteration controls';
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
                    
    l_sql varchar2(1000) := q'[    
        select 
            'cursor_iteration_performance' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= ]' || l_records;
begin

    l_rows := t_rows(for r t_rec in (
        execute immediate l_sql), (
        execute immediate l_sql) sequence => r);
        
    l_fetches := get_sql_engine_fetches('cursor_iteration_performance') - l_fetches_previous;
    print_timing_and_fetches(l_start, l_fetches, l_rows.count, l_method);

exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/


--mixed cursor iteration controls
declare
    l_method varchar2(50) := 'mixed cursor iteration controls';
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
                    
    cv_2 sys_refcursor;
    
    l_sql varchar2(1000) := q'[    
        select 
            'cursor_iteration_performance' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= ]' || l_records;
begin

    open cv_2 for l_sql;
    l_rows := t_rows(for r t_rec in c_1, cv_2 sequence => r);
    close cv_2;

    l_fetches := get_sql_engine_fetches('cursor_iteration_performance') - l_fetches_previous;
    print_timing_and_fetches(l_start, l_fetches, l_rows.count, l_method);
    
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

begin
    dbms_output.put_line('End Tests: Oracle Version ' || dbms_db_version.version);
end;
/

/* Script Output
Cursor Iteration Performance: Oracle version comparison
Begin Tests: Oracle Version 21

    open, fetch, close
    1000004 fetches for 1000002 rows
    2.796 seconds for 1000002 rows
    
    bulk collect limit 100
    10002 fetches for 1000002 rows
    0.995 seconds for 1000002 rows
    
    cursor for loops
    10002 fetches for 1000002 rows
    1.001 seconds for 1000002 rows
    
    cursor object iteration controls
    10002 fetches for 1000002 rows
    1.116 seconds for 1000002 rows
    
    sql iteration controls
    10002 fetches for 1000002 rows
    1.081 seconds for 1000002 rows
    
    cursor variable iteration controls
    1000004 fetches for 1000002 rows
    2.835 seconds for 1000002 rows
    
    dynamic sql iteration controls
    1000004 fetches for 1000002 rows
    2.842 seconds for 1000002 rows
    
    mixed cursor iteration controls
    505003 fetches for 1000002 rows
    1.957 seconds for 1000002 rows

End Tests: Oracle Version 21

Cursor Iteration Performance: Oracle version comparison
Begin Tests: Oracle Version 23

    open, fetch, close
    1000004 fetches for 1000002 rows
    2.939073 seconds for 1000002 rows
    
    bulk collect limit 100
    10002 fetches for 1000002 rows
    1.084428 seconds for 1000002 rows
    
    cursor for loops
    10002 fetches for 1000002 rows
    1.058568 seconds for 1000002 rows
    
    cursor object iteration controls
    10002 fetches for 1000002 rows
    1.655592 seconds for 1000002 rows
    
    sql iteration controls
    10002 fetches for 1000002 rows
    1.193919 seconds for 1000002 rows
    
    cursor variable iteration controls
    1000004 fetches for 1000002 rows
    2.85319 seconds for 1000002 rows
    
    dynamic sql iteration controls
    1000004 fetches for 1000002 rows
    2.822723 seconds for 1000002 rows
    
    mixed cursor iteration controls
    505003 fetches for 1000002 rows
    2.044369 seconds for 1000002 rows

End Tests: Oracle Version 23


*/


