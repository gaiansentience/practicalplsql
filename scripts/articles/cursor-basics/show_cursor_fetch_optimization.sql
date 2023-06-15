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
        and instr(upper(sql_text), 'DECLARE') = 0 
        and instr(upper(sql_text), 'V$SQLAREA') = 0;
    
    return l_fetches;
    
end get_fetches;
/

alter session set plsql_optimize_level = 0;
declare
    l_records number := 1000;
    l_fetches_previous number;
    l_fetches number;
    cursor cur_data is
    select level as id, 'item seed_sql_cursor_fetch_test ' || level as info
    from dual connect by level <= l_records;    
    type t_rows is table of cur_data%rowtype index by pls_integer;
    l_row_table t_rows;
begin

    l_fetches_previous := get_fetches('seed_sql_cursor_fetch_test');

    l_row_table := t_rows(for r in cur_data sequence => r);

    l_fetches := get_fetches('seed_sql_cursor_fetch_test') - l_fetches_previous;
    
    dbms_output.put_line('plsql_optimize_level = 0: ' || l_fetches || ' fetches for ' || l_records || ' records');
end;
/

alter session set plsql_optimize_level = 1;
declare
    l_records number := 1000;
    l_fetches_previous number;
    l_fetches number;
    cursor cur_data is
    select level as id, 'item seed_sql_cursor_fetch_test ' || level as info
    from dual connect by level <= l_records;
    type t_rows is table of cur_data%rowtype index by pls_integer;
    l_row_table t_rows;
begin
    l_fetches_previous := get_fetches('seed_sql_cursor_fetch_test');

    l_row_table := t_rows(for r in cur_data sequence => r);

    l_fetches := get_fetches('seed_sql_cursor_fetch_test') - l_fetches_previous;
    
    dbms_output.put_line('plsql_optimize_level = 1: ' || l_fetches || ' fetches for ' || l_records || ' records');
end;
/

alter session set plsql_optimize_level = 2;
declare
    l_records number := 1000;
    l_fetches_previous number;
    l_fetches number;
    cursor cur_data is
    select level as id, 'item seed_sql_cursor_fetch_test ' || level as info
    from dual connect by level <= l_records;    
    type t_rows is table of cur_data%rowtype index by pls_integer;
    l_row_table t_rows;
begin

    l_fetches_previous := get_fetches('seed_sql_cursor_fetch_test');

    l_row_table := t_rows(for r in cur_data sequence => r);

    l_fetches := get_fetches('seed_sql_cursor_fetch_test') - l_fetches_previous;
    
    dbms_output.put_line('plsql_optimize_level = 2: ' || l_fetches || ' fetches for ' || l_records || ' records');
end;
/

alter session set plsql_optimize_level = 3;
declare
    l_records number := 1000;
    l_fetches_previous number;
    l_fetches number;
    cursor cur_data is
    select level as id, 'item seed_sql_cursor_fetch_test ' || level as info
    from dual connect by level <= l_records;   
    type t_rows is table of cur_data%rowtype index by pls_integer;
    l_row_table t_rows;
begin

    l_fetches_previous := get_fetches('seed_sql_cursor_fetch_test');

    l_row_table := t_rows(for r in cur_data sequence => r);

    l_fetches := get_fetches('seed_sql_cursor_fetch_test') - l_fetches_previous;
    
    dbms_output.put_line('plsql_optimize_level = 3: ' || l_fetches || ' fetches for ' || l_records || ' records');
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