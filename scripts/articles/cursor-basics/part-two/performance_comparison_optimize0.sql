--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;
prompt performance challenge: fetch, cursor for loop, bulk bind, bulk bind limit, cursor iteration controls
prompt set plsql_optimize_level = 0;
alter session set plsql_optimize_level = 0;
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
set plsql_optimize_level = 0
Oracle version 19
1.417464 seconds for 500000 rows: Open, Fetch, Close
1.198135 seconds for 500000 rows: Cursor For Loop
0.305413 seconds for 500000 rows: Bulk Collect
0.22787 seconds for 500000 rows: Bulk Collect: Limit 100
0.222075 seconds for 500000 rows: Bulk Collect: Limit 1000
Oracle version does not support cursor iteration control

performance challenge: fetch, cursor for loop, bulk bind, bulk bind limit, cursor iteration controls
set plsql_optimize_level = 0
Oracle version 21
1.177 seconds for 500000 rows: Open, Fetch, Close
1.128 seconds for 500000 rows: Cursor For Loop
0.261 seconds for 500000 rows: Bulk Collect
0.211 seconds for 500000 rows: Bulk Collect: Limit 100
0.206 seconds for 500000 rows: Bulk Collect: Limit 1000
1.242 seconds for 500000 rows: Cursor Iteration Control

performance challenge: fetch, cursor for loop, bulk bind, bulk bind limit, cursor iteration controls
set plsql_optimize_level = 0
Oracle version 23
0.81442 seconds for 500000 rows: Open, Fetch, Close
0.648866 seconds for 500000 rows: Cursor For Loop
0.167948 seconds for 500000 rows: Bulk Collect
0.144891 seconds for 500000 rows: Bulk Collect: Limit 100
0.139036 seconds for 500000 rows: Bulk Collect: Limit 1000
0.686536 seconds for 500000 rows: Cursor Iteration Control
*/