--this script requires function.get_sql_engine_fetches.f and select rights on v_$sqlarea
set serveroutput on;

prompt Bulk Bind Limit Fetch Comparison
declare
    l_records number := 500000;
    l_limit number;
    l_fetches_previous number;
    l_fetches number;
    cursor cur_data is
        select 
            'bulk_bind_limit_fetches' as seed, 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= l_records;   
    type t_rows is table of cur_data%rowtype index by pls_integer;
    l_row cur_data%rowtype;
    l_row_table t_rows;
begin
    l_fetches_previous := get_sql_engine_fetches('bulk_bind_limit_fetches');
    open cur_data;
    loop
        fetch cur_data into l_row;
        exit when cur_data%notfound;
    end loop;
    close cur_data;
    
    l_fetches := get_sql_engine_fetches('bulk_bind_limit_fetches') - l_fetches_previous;
    dbms_output.put_line('fetching row by row: ' 
        || l_fetches || ' fetches for ' || l_records || ' records');

    l_fetches_previous := get_sql_engine_fetches('bulk_bind_limit_fetches');
    open cur_data;
    fetch cur_data bulk collect into l_row_table;
    close cur_data;
    l_fetches := get_sql_engine_fetches('bulk_bind_limit_fetches') - l_fetches_previous;
    dbms_output.put_line('bulk collect no limit: ' 
        || l_fetches || ' fetches for ' || l_records || ' records');

    l_fetches_previous := get_sql_engine_fetches('bulk_bind_limit_fetches');
    l_limit := 100;
    open cur_data;
    loop
        fetch cur_data bulk collect into l_row_table limit l_limit;
        exit when l_row_table.count = 0;
    end loop;
    close cur_data;
    l_fetches := get_sql_engine_fetches('bulk_bind_limit_fetches') - l_fetches_previous;
    dbms_output.put_line('bulk collect limit ' || l_limit || ': ' 
        || l_fetches || ' fetches for ' || l_records || ' records');

    l_fetches_previous := get_sql_engine_fetches('bulk_bind_limit_fetches');
    l_limit := 1000;
    open cur_data;
    loop
        fetch cur_data bulk collect into l_row_table limit l_limit;
        exit when l_row_table.count = 0;
    end loop;
    close cur_data;
    l_fetches := get_sql_engine_fetches('bulk_bind_limit_fetches') - l_fetches_previous;
    dbms_output.put_line('bulk collect limit ' || l_limit || ': ' 
        || l_fetches || ' fetches for ' || l_records || ' records');

    l_fetches_previous := get_sql_engine_fetches('bulk_bind_limit_fetches');
    l_limit := 10000;
    open cur_data;
    loop
        fetch cur_data bulk collect into l_row_table limit l_limit;
        exit when l_row_table.count = 0;
    end loop;
    close cur_data;
    l_fetches := get_sql_engine_fetches('bulk_bind_limit_fetches') - l_fetches_previous;
    dbms_output.put_line('bulk collect limit ' || l_limit || ': ' 
        || l_fetches || ' fetches for ' || l_records || ' records');

end;
/

/*
Bulk Bind Limit Fetch Comparison
fetching row by row: 500001 fetches for 500000 records
bulk collect no limit: 1 fetches for 500000 records
bulk collect limit 100: 5001 fetches for 500000 records
bulk collect limit 1000: 501 fetches for 500000 records
bulk collect limit 10000: 51 fetches for 500000 records
*/