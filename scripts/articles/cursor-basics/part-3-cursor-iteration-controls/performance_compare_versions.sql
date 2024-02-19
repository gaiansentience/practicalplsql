--this script requires procedure.print_timing_and_fetches.p from the simple-employees example
--the get_sql_engine_fetches function requires select rights on v_$sqlarea
set feedback off;
set serveroutput on;
alter session set plsql_optimize_level = 2;

prompt Cursor Iteration Performance: Oracle Version comparison

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

alter procedure test_iteration_controls compile plsql_optimize_level=2;
begin
    test_iteration_controls(500001);
end;
/


drop procedure test_iteration_controls;

/* Notes:
Oracle Version 12: VirtualBox Appliance BigDataLite 4 vcpu and 8 gb ram
Oracle Version 19: VirtualBox Appliance DeveloperDays 4 vcpu and 8 gb ram
Oracle Version 21XE: OracleXE On Windows 11
Oracle Version 21: VirtualBox EE Windows 11 Pro Guest 4 vcpu and 8 gb ram
Oracle Version 23: VirtualBox Appliance 23Free 4 vcpu and 8 gb ram
/* Script Output:

Cursor Iteration Performance: Oracle Version comparison
Begin Test: Oracle Version 12
plsql_optimize_level = 2
open, fetch, close......................fetches: rows: 1000002   seconds: 3.036016
bulk collect limit 100..................fetches: 10002    rows: 1000002   seconds: 0.775403
cursor for loops........................fetches: 10002    rows: 1000002   seconds: 0.834709
cannot test cursor iteration controls before version 21
End Test: Oracle Version 12

Cursor Iteration Performance: Oracle Version comparison
Begin Test: Oracle Version 19
plsql_optimize_level = 2
open, fetch, close......................fetches: 1000004  rows: 1000002   seconds: 3.269117
bulk collect limit 100..................fetches: 10002    rows: 1000002   seconds: 1.105685
cursor for loops........................fetches: 10002    rows: 1000002   seconds: 1.114238
cannot test cursor iteration controls before version 21
End Test: Oracle Version 19

Cursor Iteration Performance: Oracle Version comparison
Begin Test: Oracle Version 21
plsql_optimize_level = 2
open, fetch, close......................fetches: 1000004  rows: 1000002   seconds: 3.775
bulk collect limit 100..................fetches: 10002    rows: 1000002   seconds: 1.111
cursor for loops........................fetches: 10002    rows: 1000002   seconds: 0.95
cursor object iteration controls........fetches: 10002    rows: 1000002   seconds: 1.692
sql iteration controls..................fetches: 10002    rows: 1000002   seconds: 1.576
cursor variable iteration controls......fetches: 1000004  rows: 1000002   seconds: 3.554
dynamic sql iteration controls..........fetches: 1000004  rows: 1000002   seconds: 3.68
mixed cursor iteration controls.........fetches: 505003   rows: 1000002   seconds: 2.783
End Test: Oracle Version 21

Cursor Iteration Performance: Oracle Version comparison
Begin Test: Oracle Version 23
plsql_optimize_level = 2
open, fetch, close......................fetches: 1000004  rows: 1000002   seconds: 3.090513
bulk collect limit 100..................fetches: 10002    rows: 1000002   seconds: 1.070907
cursor for loops........................fetches: 10002    rows: 1000002   seconds: 1.055284
cursor object iteration controls........fetches: 10002    rows: 1000002   seconds: 1.186763
sql iteration controls..................fetches: 10002    rows: 1000002   seconds: 1.196649
cursor variable iteration controls......fetches: 1000004  rows: 1000002   seconds: 3.181013
dynamic sql iteration controls..........fetches: 1000004  rows: 1000002   seconds: 3.115884
mixed cursor iteration controls.........fetches: 505003   rows: 1000002   seconds: 2.150977
End Test: Oracle Version 23

Cursor Iteration Performance: Oracle Version comparison
Begin Test: Oracle Version 21 EE On VirtualBox Windows11Pro
plsql_optimize_level = 2
open, fetch, close......................fetches: 1000004  rows: 1000002   seconds: 1.984
bulk collect limit 100..................fetches: 10002    rows: 1000002   seconds: 0.706
cursor for loops........................fetches: 10002    rows: 1000002   seconds: 0.676
cursor object iteration controls........fetches: 10002    rows: 1000002   seconds: 0.743
sql iteration controls..................fetches: 10002    rows: 1000002   seconds: 0.757
cursor variable iteration controls......fetches: 1000004  rows: 1000002   seconds: 2.02
dynamic sql iteration controls..........fetches: 1000004  rows: 1000002   seconds: 2.477
mixed cursor iteration controls.........fetches: 505003   rows: 1000002   seconds: 2.003
End Test: Oracle Version 21


*/