--this script requires procedure.print_timing_and_fetches.p from the simple-employees example
--the get_sql_engine_fetches function requires select rights on v_$sqlarea
set feedback off;
set serveroutput on;
alter session set plsql_optimize_level = 2;

prompt Cursor Iteration Performance: Pl/SQL Optimize Level comparison

create or replace procedure test_iteration_controls(p_records in number default 5000001)
is
    l_method varchar2(50);
    l_start timestamp := localtimestamp;
    l_records number := p_records;
    l_fetches_previous number; 
    l_fetches number;
    type t_rec is record(
        seed varchar2(50),
        id   number,
        info varchar2(20));
    l_rec t_rec;
    type t_rows is table of t_rec;
    l_rows t_rows := t_rows();
    l_rows_partial t_rows := t_rows();
    
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
                    
    cv_1 sys_refcursor; 
    cv_2 sys_refcursor;

    l_sql varchar2(1000) := q'[    
        select 
            'cursor_iteration_performance' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= ]' || l_records;
    procedure initialize_test(p_method in varchar2)
    is
    begin
        l_method := p_method;
        l_start := localtimestamp;
        l_fetches_previous := get_sql_engine_fetches('cursor_iteration_performance');
        l_rows := t_rows();    
    end initialize_test;
    procedure print_test
    is
    begin
        l_fetches := get_sql_engine_fetches('cursor_iteration_performance') - l_fetches_previous;
        print_timing_and_fetches(l_start, l_fetches, l_rows.count, l_method, p_single_line => true);
    end print_test;
begin
    dbms_output.put_line('Begin Test: Oracle Version ' || dbms_db_version.version);
    dbms_output.put_line('plsql_optimize_level = ' || $$plsql_optimize_level);
    initialize_test('open, fetch, close');
    
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

    print_test;

    initialize_test('bulk collect limit 100');

	open cv_1 for l_sql;
    loop
        fetch cv_1 bulk collect into l_rows_partial limit 100;
        exit when l_rows_partial.count = 0;
$if dbms_db_version.version < 23 $then  
        --dbms_output.put_line('[for i in indices of] wont compile in a procedure in versions less than 23');
        for i in 1..l_rows_partial.count loop
$else
        for i in indices of l_rows_partial loop
$end

            l_rows.extend();
            l_rows(l_rows.last) := l_rows_partial(i);
        end loop;        
    end loop;
    close cv_1;
            
	open cv_2 for l_sql;
    loop
        fetch cv_2 bulk collect into l_rows_partial limit 100;
        exit when l_rows_partial.count = 0;
$if dbms_db_version.version < 23 $then  
        --dbms_output.put_line('[for i in indices of] wont compile in a procedure in versions less than 23');
        for i in 1..l_rows_partial.count loop
$else
        for i in indices of l_rows_partial loop
$end
            l_rows.extend();
            l_rows(l_rows.last) := l_rows_partial(i);
        end loop;        
    end loop;
    close cv_2;

    print_test;

    initialize_test('cursor for loops');
        
    for r in c_1 loop
        l_rows.extend();
        l_rows(l_rows.last) := r;
    end loop;    
    for r in c_2 loop
        l_rows.extend();
        l_rows(l_rows.last) := r;
    end loop;
        
    print_test;
    
$if dbms_db_version.version < 21 $then
    dbms_output.put_line('cannot test cursor iteration controls before version 21');
$else

    initialize_test('cursor object iteration controls');

    l_rows := t_rows(for r t_rec in c_1, c_2 sequence => r);

    print_test;

    initialize_test('sql iteration controls');

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

    print_test;
    
    initialize_test('cursor variable iteration controls');

	open cv_1 for l_sql;
	open cv_2 for l_sql;
    l_rows := t_rows(for r t_rec in cv_1, cv_2 sequence => r);
    close cv_1;
    close cv_2;
    
    print_test;
    
    initialize_test('dynamic sql iteration controls');

    l_rows := t_rows(for r t_rec in (
        execute immediate l_sql), (
        execute immediate l_sql) sequence => r);
        
    print_test;

    initialize_test('mixed cursor iteration controls');

    open cv_2 for l_sql;
    l_rows := t_rows(for r t_rec in c_1, cv_2 sequence => r);
    close cv_2;

    print_test;

$end

    dbms_output.put_line('End Test: Oracle Version ' || dbms_db_version.version);
    
exception
    when others then
        dbms_output.put_line(sqlerrm);
end test_iteration_controls;
/

alter procedure test_iteration_controls compile plsql_optimize_level=0;
begin
    test_iteration_controls(50001);
end;
/

alter procedure test_iteration_controls compile plsql_optimize_level=1;
begin
    test_iteration_controls(50001);
end;
/

alter procedure test_iteration_controls compile plsql_optimize_level=2;
begin
    test_iteration_controls(50001);
end;
/

alter procedure test_iteration_controls compile plsql_optimize_level=3;
begin
    test_iteration_controls(50001);
end;
/

drop procedure test_iteration_controls;

/* Script Output:

Cursor Iteration Performance: Pl/SQL Optimize Level comparison
Begin Test: Oracle Version 12
plsql_optimize_level = 0
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.299947
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.088038
cursor for loops........................fetches: 100004   rows: 100002    seconds: 0.302173
cannot test cursor iteration controls before version 21
End Test: Oracle Version 12

Begin Test: Oracle Version 12
plsql_optimize_level = 1
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.300081
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.083684
cursor for loops........................fetches: 100004   rows: 100002    seconds: 0.301665
cannot test cursor iteration controls before version 21
End Test: Oracle Version 12

Begin Test: Oracle Version 12
plsql_optimize_level = 2
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.302681
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.08364
cursor for loops........................fetches: 1002     rows: 100002    seconds: 0.085243
cannot test cursor iteration controls before version 21
End Test: Oracle Version 12

Begin Test: Oracle Version 12
plsql_optimize_level = 3
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.314832
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.0876
cursor for loops........................fetches: 1002     rows: 100002    seconds: 0.084599
cannot test cursor iteration controls before version 21
End Test: Oracle Version 12


Cursor Iteration Performance: Pl/SQL Optimize Level comparison
Begin Test: Oracle Version 19
plsql_optimize_level = 0
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.388182
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.163994
cursor for loops........................fetches: 100004   rows: 100002    seconds: 0.385515
cannot test cursor iteration controls before version 21
End Test: Oracle Version 19

Begin Test: Oracle Version 19
plsql_optimize_level = 1
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.386812
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.153751
cursor for loops........................fetches: 100004   rows: 100002    seconds: 0.39425
cannot test cursor iteration controls before version 21
End Test: Oracle Version 19

Begin Test: Oracle Version 19
plsql_optimize_level = 2
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.385119
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.154964
cursor for loops........................fetches: 1002     rows: 100002    seconds: 0.16238
cannot test cursor iteration controls before version 21
End Test: Oracle Version 19

Begin Test: Oracle Version 19
plsql_optimize_level = 3
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.36072
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.151222
cursor for loops........................fetches: 1002     rows: 100002    seconds: 0.151542
cannot test cursor iteration controls before version 21
End Test: Oracle Version 19

Cursor Iteration Performance: Pl/SQL Optimize Level comparison
Begin Test: Oracle Version 21
plsql_optimize_level = 0
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.367
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.143
cursor for loops........................fetches: 100004   rows: 100002    seconds: 0.36
cursor object iteration controls........fetches: 100004   rows: 100002    seconds: 0.387
sql iteration controls..................fetches: 100004   rows: 100002    seconds: 0.379
cursor variable iteration controls......fetches: 100004   rows: 100002    seconds: 0.376
dynamic sql iteration controls..........fetches: 100004   rows: 100002    seconds: 0.386
mixed cursor iteration controls.........fetches: 100004   rows: 100002    seconds: 0.427
End Test: Oracle Version 21

Begin Test: Oracle Version 21
plsql_optimize_level = 1
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.35
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.136
cursor for loops........................fetches: 100004   rows: 100002    seconds: 0.355
cursor object iteration controls........fetches: 100004   rows: 100002    seconds: 0.377
sql iteration controls..................fetches: 100004   rows: 100002    seconds: 0.382
cursor variable iteration controls......fetches: 100004   rows: 100002    seconds: 0.378
dynamic sql iteration controls..........fetches: 100004   rows: 100002    seconds: 0.395
mixed cursor iteration controls.........fetches: 100004   rows: 100002    seconds: 0.419
End Test: Oracle Version 21

Begin Test: Oracle Version 21
plsql_optimize_level = 2
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.367
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.145
cursor for loops........................fetches: 1002     rows: 100002    seconds: 0.141
cursor object iteration controls........fetches: 1002     rows: 100002    seconds: 0.152
sql iteration controls..................fetches: 1002     rows: 100002    seconds: 0.154
cursor variable iteration controls......fetches: 100004   rows: 100002    seconds: 0.373
dynamic sql iteration controls..........fetches: 100004   rows: 100002    seconds: 0.387
mixed cursor iteration controls.........fetches: 50503    rows: 100002    seconds: 0.3
End Test: Oracle Version 21

Begin Test: Oracle Version 21
plsql_optimize_level = 3
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.355
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.141
cursor for loops........................fetches: 1002     rows: 100002    seconds: 0.137
cursor object iteration controls........fetches: 1002     rows: 100002    seconds: 0.152
sql iteration controls..................fetches: 1002     rows: 100002    seconds: 0.155
cursor variable iteration controls......fetches: 100004   rows: 100002    seconds: 0.37
dynamic sql iteration controls..........fetches: 100004   rows: 100002    seconds: 0.367
mixed cursor iteration controls.........fetches: 50503    rows: 100002    seconds: 0.279
End Test: Oracle Version 21

Cursor Iteration Performance: Pl/SQL Optimize Level comparison
Begin Test: Oracle Version 23
plsql_optimize_level = 0
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.289226
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.135516
cursor for loops........................fetches: 100004   rows: 100002    seconds: 0.307073
cursor object iteration controls........fetches: 100004   rows: 100002    seconds: 0.326728
sql iteration controls..................fetches: 100004   rows: 100002    seconds: 0.328073
cursor variable iteration controls......fetches: 100004   rows: 100002    seconds: 0.301753
dynamic sql iteration controls..........fetches: 100004   rows: 100002    seconds: 0.298303
mixed cursor iteration controls.........fetches: 100004   rows: 100002    seconds: 0.35312
End Test: Oracle Version 23

Begin Test: Oracle Version 23
plsql_optimize_level = 1
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.342284
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.156463
cursor for loops........................fetches: 100004   rows: 100002    seconds: 0.365617
cursor object iteration controls........fetches: 100004   rows: 100002    seconds: 0.397602
sql iteration controls..................fetches: 100004   rows: 100002    seconds: 0.387442
cursor variable iteration controls......fetches: 100004   rows: 100002    seconds: 0.36215
dynamic sql iteration controls..........fetches: 100004   rows: 100002    seconds: 0.357534
mixed cursor iteration controls.........fetches: 100004   rows: 100002    seconds: 0.37423
End Test: Oracle Version 23

Begin Test: Oracle Version 23
plsql_optimize_level = 2
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.360342
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.159009
cursor for loops........................fetches: 1002     rows: 100002    seconds: 0.159466
cursor object iteration controls........fetches: 1002     rows: 100002    seconds: 0.163934
sql iteration controls..................fetches: 1002     rows: 100002    seconds: 0.165495
cursor variable iteration controls......fetches: 100004   rows: 100002    seconds: 0.359171
dynamic sql iteration controls..........fetches: 100004   rows: 100002    seconds: 0.352883
mixed cursor iteration controls.........fetches: 50503    rows: 100002    seconds: 0.266935
End Test: Oracle Version 23

Begin Test: Oracle Version 23
plsql_optimize_level = 3
open, fetch, close......................fetches: 100004   rows: 100002    seconds: 0.294253
bulk collect limit 100..................fetches: 1002     rows: 100002    seconds: 0.12856
cursor for loops........................fetches: 1002     rows: 100002    seconds: 0.128915
cursor object iteration controls........fetches: 1002     rows: 100002    seconds: 0.142553
sql iteration controls..................fetches: 1002     rows: 100002    seconds: 0.135351
cursor variable iteration controls......fetches: 100004   rows: 100002    seconds: 0.315857
dynamic sql iteration controls..........fetches: 100004   rows: 100002    seconds: 0.312957
mixed cursor iteration controls.........fetches: 50503    rows: 100002    seconds: 0.230644
End Test: Oracle Version 23

*/