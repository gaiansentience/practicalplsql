--this script requires procedure.print_timing.p
set serveroutput on;

prompt Bulk Bind Limit Timing Comparison
declare
    l_records number := 500000;
    l_limit number;
    l_start timestamp;
    cursor cur_data is
        select 
            level as id, 
            'item ' || level as info
        from dual 
        connect by level <= l_records;   
    type t_rows is table of cur_data%rowtype index by pls_integer;
    l_row cur_data%rowtype;
    l_row_table t_rows;
begin
    l_start := localtimestamp;
    open cur_data;
    loop
        fetch cur_data into l_row;
        exit when cur_data%notfound;
    end loop;
    close cur_data;
    print_timing(l_start, l_records, 'open, fetch, close');
        
    l_start := localtimestamp;
    open cur_data;
    fetch cur_data bulk collect into l_row_table;
    close cur_data;
    print_timing(l_start, l_records, 'bulk collect no limit');

    l_start := localtimestamp;
    l_limit := 100;
    open cur_data;
    loop
        fetch cur_data bulk collect into l_row_table limit l_limit;
        exit when l_row_table.count = 0;
    end loop;
    close cur_data;
    print_timing(l_start, l_records, 'bulk collect limit ' || l_limit);

    l_start := localtimestamp;
    l_limit := 1000;
    open cur_data;
    loop
        fetch cur_data bulk collect into l_row_table limit l_limit;
        exit when l_row_table.count = 0;
    end loop;
    close cur_data;
    print_timing(l_start, l_records, 'bulk collect limit ' || l_limit);

    l_start := localtimestamp;
    l_limit := 10000;
    open cur_data;
    loop
        fetch cur_data bulk collect into l_row_table limit l_limit;
        exit when l_row_table.count = 0;
    end loop;
    close cur_data;
    print_timing(l_start, l_records, 'bulk collect limit ' || l_limit);

end;
/

/*
Bulk Bind Limit Timing Comparison
1.125 seconds for 500000 rows: open, fetch, close
0.32 seconds for 500000 rows: bulk collect no limit
0.219 seconds for 500000 rows: bulk collect limit 100
0.204 seconds for 500000 rows: bulk collect limit 1000
0.211 seconds for 500000 rows: bulk collect limit 10000
*/