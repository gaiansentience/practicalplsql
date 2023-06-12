--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;
prompt performance challenge: fetch, cursor for loop, bulk bind, bulk bind limit, cursor iteration controls
prompt set plsql_optimize_level = 2;
alter session set plsql_optimize_level = 2;
declare
    c_records constant number := 500000;
    l_limit pls_integer;
    l_records pls_integer;
    l_start timestamp;
    
    type t_item_rec is record(id number, info varchar2(50));
    type t_item_tab is table of t_item_rec index by pls_integer;
    r_item t_item_rec;
    l_items t_item_tab;
    
    cursor c_items is
        select level as id, 'item ' || level as info
        from dual 
        connect by level <= c_records;

    procedure reset
    is
    begin
        l_items.delete;
        l_start := localtimestamp;
        l_records := 0;    
    end reset;
begin
    dbms_output.put_line('Oracle version ' || dbms_db_version.version);

    reset;    
    open c_items;
    loop
        fetch c_items into r_item;
        exit when c_items%notfound;
        l_items(l_items.count + 1) := r_item;
    end loop;
    close c_items;
    l_records := l_items.count;
    print_timing(l_start, l_records, 'Open, Fetch, Close');

    reset;
    for r in c_items loop
        l_items(l_items.count + 1) := r;
    end loop;
    l_records := l_items.count;
    print_timing(l_start, l_records, 'Cursor For Loop');
    
    
    reset;
    open c_items;
    fetch c_items bulk collect into l_items;
    close c_items;
    l_records := l_items.count;
    print_timing(l_start, l_records, 'Bulk Collect');
    
    
    reset;
    l_limit := 100;
    open c_items;
    loop
        fetch c_items bulk collect into l_items limit l_limit;
        exit when l_items.count = 0;
        l_records := l_records + l_items.count;
    end loop;
    close c_items;
    print_timing(l_start, l_records, 'Bulk Collect: Limit ' || l_limit);
    
    reset;
    l_limit := 1000;
    open c_items;
    loop
        fetch c_items bulk collect into l_items limit l_limit;
        exit when l_items.count = 0;
        l_records := l_records + l_items.count;
    end loop;
    close c_items;
    print_timing(l_start, l_records, 'Bulk Collect: Limit ' || l_limit);
    
$if dbms_db_version.version >= 21 $then    
    reset;
    l_items := t_item_tab(for r in c_items sequence => r);
    l_records := l_items.count;
    print_timing(l_start, l_records, 'Cursor Iteration Control');
$else
    dbms_output.put_line('Oracle version does not support cursor iteration control');
$end
end;
/
alter session set plsql_optimize_level = 2;

/* Script Output:
performance challenge: fetch, cursor for loop, bulk bind, bulk bind limit, cursor iteration controls
set plsql_optimize_level = 2
Oracle version 19
1.490219 seconds for 500000 rows: Open, Fetch, Close
0.393407 seconds for 500000 rows: Cursor For Loop
0.309177 seconds for 500000 rows: Bulk Collect
0.252112 seconds for 500000 rows: Bulk Collect: Limit 100
0.245394 seconds for 500000 rows: Bulk Collect: Limit 1000
Oracle version does not support cursor iteration control

performance challenge: fetch, cursor for loop, bulk bind, bulk bind limit, cursor iteration controls
set plsql_optimize_level = 2
Oracle version 21
1.387 seconds for 500000 rows: Open, Fetch, Close
0.322 seconds for 500000 rows: Cursor For Loop
0.262 seconds for 500000 rows: Bulk Collect
0.213 seconds for 500000 rows: Bulk Collect: Limit 100
0.203 seconds for 500000 rows: Bulk Collect: Limit 1000
0.442 seconds for 500000 rows: Cursor Iteration Control

performance challenge: fetch, cursor for loop, bulk bind, bulk bind limit, cursor iteration controls
set plsql_optimize_level = 2
Oracle version 23
0.810258 seconds for 500000 rows: Open, Fetch, Close
0.227343 seconds for 500000 rows: Cursor For Loop
0.164057 seconds for 500000 rows: Bulk Collect
0.148344 seconds for 500000 rows: Bulk Collect: Limit 100
0.140032 seconds for 500000 rows: Bulk Collect: Limit 1000
0.28901 seconds for 500000 rows: Cursor Iteration Control
*/