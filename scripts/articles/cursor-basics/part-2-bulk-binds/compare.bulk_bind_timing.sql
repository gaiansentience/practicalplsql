--this script requires procedure.print_timing.p
set serveroutput on;

prompt Bulk Bind Timing Comparison
declare
    l_records number := 10000;
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
    
    print_timing(l_start, l_records, 'bulk collect');

end;
/

/*
Bulk Bind Timing Comparison
0.019 seconds for 10000 rows: open, fetch, close
0.006 seconds for 10000 rows: bulk collect
*/