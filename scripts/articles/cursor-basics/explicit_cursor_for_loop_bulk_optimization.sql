set feedback off;
set serveroutput on;
--grant select on v_$sqlarea to script user
--update seed_sql_text literal for each execution to get new fetch counts
alter session set plsql_optimize_level = 0;
declare
    l_records number := 1000;
    l_fetches number;
    cursor cur_data is
    select level as id, 'item seed_sql_text0zzza ' || level as info
    from dual connect by level <= l_records;    
begin
    for r in cur_data loop
        null;
    end loop;

    select fetches into l_fetches
    from v$sqlarea 
    where 
        instr(sql_text, 'seed_sql_text0zzza') > 0 
        and instr(upper(sql_text), 'DECLARE') = 0 
        and instr(upper(sql_text), 'V$SQLAREA') = 0;
    
    dbms_output.put_line('plsql_optimize_level = 0: ' || l_fetches || ' fetches for ' || l_records || ' records');
end;
/

alter session set plsql_optimize_level = 1;
declare
    l_records number := 1000;
    l_fetches number;
    cursor cur_data is
    select level as id, 'item seed_sql_text1zzza ' || level as info
    from dual connect by level <= l_records;
begin
    for r in cur_data loop
        null;
    end loop;

    select fetches into l_fetches
    from v$sqlarea 
    where 
        instr(sql_text, 'seed_sql_text1zzza') > 0 
        and instr(upper(sql_text), 'DECLARE') = 0 
        and instr(upper(sql_text), 'V$SQLAREA') = 0;
    
    dbms_output.put_line('plsql_optimize_level = 1: ' || l_fetches || ' fetches for ' || l_records || ' records');
end;
/

alter session set plsql_optimize_level = 2;
declare
    l_records number := 1000;
    l_fetches number;
    cursor cur_data is
    select level as id, 'item seed_sql_text2zzza ' || level as info
    from dual connect by level <= l_records;    
begin
    for r in cur_data loop
        null;
    end loop;

    select fetches into l_fetches
    from v$sqlarea 
    where 
        instr(sql_text, 'seed_sql_text2zzza') > 0 
        and instr(upper(sql_text), 'DECLARE') = 0 
        and instr(upper(sql_text), 'V$SQLAREA') = 0;
    
    dbms_output.put_line('plsql_optimize_level = 2: ' || l_fetches || ' fetches for ' || l_records || ' records');
end;
/

alter session set plsql_optimize_level = 3;
declare
    l_records number := 1000;
    l_fetches number;
    cursor cur_data is
    select level as id, 'item seed_sql_text3zzza ' || level as info
    from dual connect by level <= l_records;    
begin
    for r in cur_data loop
        null;
    end loop;

    select fetches into l_fetches
    from v$sqlarea 
    where 
        instr(sql_text, 'seed_sql_text3zzza') > 0 
        and instr(upper(sql_text), 'DECLARE') = 0 
        and instr(upper(sql_text), 'V$SQLAREA') = 0;
    
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