--this script requires procedure.print_timing.p
set serveroutput on;
--set default optimizer level
alter session set plsql_optimize_level = 2;

prompt Cursor For Loop Timing Comparison
declare
    l_records number := 500000;
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
    loop
        fetch cur_data bulk collect into l_row_table limit 100;
        exit when l_row_table.count = 0;
    end loop;
    close cur_data;
    print_timing(l_start, l_records, 'bulk collect limit 100');

    l_start := localtimestamp;
    for r in cur_data loop
        null;
    end loop;
    print_timing(l_start, l_records, 'cursor for loop');

end;
/

/*
Cursor For Loop Timing Comparison
1.108 seconds for 500000 rows: open, fetch, close
0.212 seconds for 500000 rows: bulk collect limit 100
0.218 seconds for 500000 rows: cursor for loop
*/