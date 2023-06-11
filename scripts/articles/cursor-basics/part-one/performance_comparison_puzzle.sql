--this script has no dependencies
set serveroutput on;
alter session set plsql_optimize_level = 0;
prompt performance challenge:  open, fetch, close vs. cursor for loop
declare
    c_records constant number := 500000;
    l_records number;
    l_start timestamp;

    cursor c_fetch is
        select 'item ' || level as info
        from dual 
        connect by level <= c_records;
    r_fetch c_fetch%rowtype;  

    cursor c_for is
        select 'item ' || level as info
        from dual 
        connect by level <= c_records;

    procedure print_timing(
        p_start in timestamp, 
        p_records in number, 
        p_message in varchar2)
    is
    begin
        dbms_output.put_line(
            to_char(
                extract(second from (localtimestamp - p_start))
            , 'fm0.999999')
            || ' seconds for ' || p_records || ' rows: ' || p_message);
    end print_timing;
begin 

    l_start := localtimestamp;
    l_records := 0;
    
    open c_fetch;
    loop
        fetch c_fetch into r_fetch;
        exit when c_fetch%notfound;
        l_records := l_records + 1;
    end loop;
    print_timing(l_start, l_records, 'Open, Fetch, Close');
    
    l_start := localtimestamp;
    l_records := 0;
    
    for r_for in c_for loop
        l_records := l_records + 1;
    end loop;
    print_timing(l_start, l_records, 'Cursor For Loop');

end;
/
alter session set plsql_optimize_level = 2;

/* Script Output:
performance challenge:  open, fetch, close vs. cursor for loop
1.185532 seconds for 500000 rows: Open, Fetch, Close
1.208598 seconds for 500000 rows: Cursor For Loop
*/