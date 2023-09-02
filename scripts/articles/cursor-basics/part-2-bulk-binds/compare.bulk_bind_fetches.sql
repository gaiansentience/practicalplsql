--this script requires function.get_sql_engine_fetches.f and select rights on v_$sqlarea
set serveroutput on;

prompt Bulk Bind Fetch Comparison
declare
    l_records number := 10000;
    l_fetches_previous number;
    l_fetches number;
    cursor cur_data is
        select 
            'bulk_bind_fetch_comparison' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= l_records;   
    type t_rows is table of cur_data%rowtype index by pls_integer;
    l_row cur_data%rowtype;
    l_row_table t_rows;
begin

    l_fetches_previous := get_sql_engine_fetches('bulk_bind_fetch_comparison');

    open cur_data;
    loop
        fetch cur_data into l_row;
        exit when cur_data%notfound;
    end loop;
    close cur_data;
    
    l_fetches := get_sql_engine_fetches('bulk_bind_fetch_comparison') - l_fetches_previous;
    
    dbms_output.put_line('open, fetch, close: ' 
        || l_fetches || ' fetches for ' || l_records || ' records');
        
    l_fetches_previous := get_sql_engine_fetches('bulk_bind_fetch_comparison');

    open cur_data;
    fetch cur_data bulk collect into l_row_table;
    close cur_data;
    
    l_fetches := get_sql_engine_fetches('bulk_bind_fetch_comparison') - l_fetches_previous;
    
    dbms_output.put_line('bulk collect: ' 
        || l_fetches || ' fetches for ' || l_records || ' records');

end;
/

/*
Bulk Bind Fetch Comparison
open, fetch, close: 10001 fetches for 10000 records
bulk collect: 1 fetches for 10000 records
*/