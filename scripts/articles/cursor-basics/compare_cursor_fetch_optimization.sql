set feedback off;
set serveroutput on;
--grant select on v_$sqlarea to practicalplsql;

create or replace function get_fetches(l_seed in varchar2) return number
is
l_fetches number;
begin

    select fetches into l_fetches
    from v$sqlarea 
    where 
        instr(sql_text, l_seed) > 0 
        and instr(upper(sql_text), 'CONNECT BY LEVEL <= :B1') > 0
        and instr(upper(sql_text), 'V$SQLAREA') = 0;
    
    return l_fetches;

exception 
    when no_data_found then
        return 0;
end get_fetches;
/

create or replace procedure compare_cursor_method_fetch_counts
is
    l_records number := 500000;
    l_fetches_previous number;
    l_fetches number;
    cursor cur_data is
    select level as id, 'item seed_sql_cursor_fetch_test ' || level as info
    from dual connect by level <= l_records;    
    l_row cur_data%rowtype;
    type t_rows is table of cur_data%rowtype;-- index by pls_integer;
    l_temp_rows t_rows := new t_rows();
    l_row_table t_rows := new t_rows();
    l_start timestamp;    
    procedure reset_test
    is
    begin
        l_start := localtimestamp;
        l_row_table.delete;
        l_fetches_previous := get_fetches('seed_sql_cursor_fetch_test');    
    end reset_test;

    procedure print_test(p_test_type in varchar2)
    is
    begin
        l_fetches := get_fetches('seed_sql_cursor_fetch_test') - l_fetches_previous;
        dbms_output.put_line(p_test_type || ': ' 
            || l_fetches || ' fetches for ' 
            || l_row_table.count || ' records in '
            || to_char(extract(second from (localtimestamp - l_start)),'fm990.999999') || ' seconds.'
            );    
    end print_test;
begin

    dbms_output.put('Oracle Version ' || dbms_db_version.version);

    dbms_output.put_line(' plsql_optimize_level ' ||
$if $$plsql_optimize_level = 0 $then
'= 0'
$elsif $$plsql_optimize_level = 1 $then
'= 1'
$elsif $$plsql_optimize_level = 2 $then
'= 2'
$elsif $$plsql_optimize_level >= 3 $then
'>= 3'
$else
' is unexpected'
$end
);
    reset_test;

    open cur_data;
    loop
        fetch cur_data into l_row;
        exit when cur_data%notfound;
        l_row_table.extend;
        l_row_table(l_row_table.last) := l_row;
    end loop;
    close cur_data;

    print_test('Open, Fetch, Close');
    
    reset_test;

    for r in cur_data loop
        l_row_table.extend;
        l_row_table(l_row_table.last) := l_row;
    end loop;

    print_test('Cursor For Loop');
    
    reset_test;

    open cur_data;
    fetch cur_data bulk collect into l_row_table;
    close cur_data;

    print_test('Bulk Collect');

    reset_test;
    l_temp_rows := new t_rows();
    open cur_data;
    loop
        fetch cur_data bulk collect into l_temp_rows limit 100;
        exit when l_temp_rows.count = 0;
        --using multiset union makes timing bad
        --l_row_table := l_row_table multiset union l_temp_rows;
        for i in 1..l_temp_rows.count loop
            l_row_table.extend();
            l_row_table(l_row_table.last) := l_temp_rows(i);
        end loop;
    end loop;
    close cur_data;

    print_test('Bulk Collect (Limit 100)');


$if dbms_db_version.version >= 21 $then

    reset_test;

    l_row_table := t_rows(for r in cur_data sequence => r);

    print_test('Cursor Iteration Control');

$else
    dbms_output.put_line('Cursor Iteration Control Is Not Supported In Version ' || dbms_db_version.version);
$end

end compare_cursor_method_fetch_counts;
/

ALTER PROCEDURE compare_cursor_method_fetch_counts COMPILE plsql_optimize_level = 0;
begin
    compare_cursor_method_fetch_counts;
end;
/


ALTER PROCEDURE compare_cursor_method_fetch_counts COMPILE plsql_optimize_level = 1;
begin
    compare_cursor_method_fetch_counts;
end;
/

ALTER PROCEDURE compare_cursor_method_fetch_counts COMPILE plsql_optimize_level = 2;
begin
    compare_cursor_method_fetch_counts;
end;
/

ALTER PROCEDURE compare_cursor_method_fetch_counts COMPILE plsql_optimize_level = 3;
begin
    compare_cursor_method_fetch_counts;
end;
/


--reset plsql_optimize_level to default level of 2
alter session set plsql_optimize_level = 2;
/*
plsql_optimize_level = 0: 1001 fetches for 1000 records
plsql_optimize_level = 1: 1001 fetches for 1000 records
plsql_optimize_level = 2: 11 fetches for 1000 records
plsql_optimize_level = 3: 11 fetches for 1000 records
*/