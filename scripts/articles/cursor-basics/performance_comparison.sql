set feedback off;
set serveroutput on;
alter session set plsql_optimize_level = 2;
declare
    c_hundred constant number := 100;
    c_thousand constant number := 1000;
    c_million constant number := 1000000;
    c_total_records constant number := c_million;
    l_bulk_limit number := c_hundred;
    
    l_start timestamp := localtimestamp;
    type t_timings is table of varchar2(1000) index by varchar2(100);
    l_timings t_timings;
    
    procedure print_timing(p_message in varchar2)
    is
        l_duration varchar2(100) := to_char(localtimestamp - l_start);
    begin
        l_timings (l_duration || p_message) := rpad(p_message, 60, '.') || l_duration || ' for ' || c_total_records || ' records';
        l_start := localtimestamp;
    end print_timing;
begin

    --test explicit cursor approaches
    declare
        cursor c is
        select level as id, 'item ' || level  as info
        from dual connect by level <= c_total_records;
        l_row c%rowtype;
        type t_rows is table of c%rowtype index by pls_integer;
        l_row_table t_rows;
    begin
        -------------------------------------
        open c;
        loop
            fetch c into l_row;
            exit when c%notfound;
            null;
        end loop;
        close c;
        print_timing('explicit cursor open, fetch, close');
        -------------------------------------    
        for r in c loop
            null;
        end loop;
        print_timing('explicit cursor for loop');
        -------------------------------------    
        open c;
        fetch c bulk collect into l_row_table;
        close c;
        for i in 1..l_row_table.count loop
            null;
        end loop;
        print_timing('explicit cursor bulk bind all*');
        -------------------------------------
        l_bulk_limit := c_hundred;
        open c;
        loop
            fetch c bulk collect into l_row_table limit l_bulk_limit;
            exit when l_row_table.count = 0;
            for i in 1..l_row_table.count loop
                null;
            end loop;
        end loop;
        close c;
        print_timing('explicit cursor bulk bind limit ' || l_bulk_limit);
        -------------------------------------  
        l_bulk_limit := c_thousand;
        open c;
        loop
            fetch c bulk collect into l_row_table limit l_bulk_limit;
            exit when l_row_table.count = 0;
            for i in 1..l_row_table.count loop
                null;
            end loop;
        end loop;
        close c;
        print_timing('explicit cursor bulk bind limit** ' || l_bulk_limit);
        -------------------------------------    
        l_bulk_limit := c_thousand * 10;
        open c;
        loop
            fetch c bulk collect into l_row_table limit l_bulk_limit;
            exit when l_row_table.count = 0;
            for i in 1..l_row_table.count loop
                null;
            end loop;
        end loop;
        close c;
        print_timing('explicit cursor bulk bind limit** ' || l_bulk_limit);
        -------------------------------------
        l_row_table := t_rows(for r in c sequence => r);
        for i in 1..l_row_table.count loop
            null;
        end loop;
        print_timing('21c cursor iterator control');
    
    end;

    --test cursor variable approaches
    declare
        type t_rec is record(id number, info varchar2(100));
        type t_rec_tab is table of t_rec index by pls_integer;
        l_rec t_rec;
        l_rec_table t_rec_tab;
        type strong_cursor_variable is ref cursor return t_rec;
        cv_strong strong_cursor_variable;
        cv_weak sys_refcursor;
    begin
        -------------------------------------    
        open cv_strong for 
        select level as id, 'item ' || level  as info
        from dual connect by level <= c_total_records;
        loop
            fetch cv_strong into l_rec;
            exit when cv_strong%notfound;
            null;
        end loop;
        close cv_strong;
        print_timing('strong cursor variable open, fetch, close');
        -------------------------------------    
        open cv_strong for 
        select level as id, 'item ' || level  as info
        from dual connect by level <= c_total_records;    
        fetch cv_strong bulk collect into l_rec_table;
        close cv_strong;
        for i in 1..l_rec_table.count loop
            null;
        end loop;
        print_timing('strong cursor variable bulk bind all*');
        -------------------------------------    
        l_bulk_limit := c_hundred;
        open cv_strong for 
        select level as id, 'item ' || level  as info
        from dual connect by level <= c_total_records;    
        loop
            fetch cv_strong bulk collect into l_rec_table limit l_bulk_limit;
            exit when l_rec_table.count = 0;
            for i in 1..l_rec_table.count loop
                null;
            end loop;
        end loop;
        close cv_strong;
        print_timing('strong cursor variable bulk bind limit ' || l_bulk_limit);
        -------------------------------------
        open cv_weak for 
        select level as id, 'item ' || level  as info
        from dual connect by level <= c_total_records;
        loop
            fetch cv_weak into l_rec;
            exit when cv_weak%notfound;
            null;
        end loop;
        close cv_weak;
        print_timing('weak cursor variable open, fetch, close');
        -------------------------------------
        open cv_weak for 
        select level as id, 'item ' || level  as info
        from dual connect by level <= c_total_records;
        fetch cv_weak bulk collect into l_rec_table;
        close cv_weak;    
        for i in 1..l_rec_table.count loop
            null;
        end loop;
        print_timing('weak cursor variable bulk bind all*');
        -------------------------------------
        l_bulk_limit := c_hundred;
        open cv_weak for 
        select level as id, 'item ' || level  as info
        from dual connect by level <= c_total_records;
        loop
            fetch cv_weak bulk collect into l_rec_table limit l_bulk_limit;
            exit when l_rec_table.count = 0;
            for i in 1..l_rec_table.count loop
                null;
            end loop;
        end loop;
        close cv_weak;
        print_timing('weak cursor variable bulk bind limit ' || l_bulk_limit);
        -------------------------------------
        l_bulk_limit := c_hundred;
        open cv_weak for 
        q'[select level as id, 'item ' || level  as info
        from dual connect by level <= ]' || c_total_records;
        loop
            fetch cv_weak into l_rec;
            exit when cv_weak%notfound;
        end loop;
        close cv_weak;
        print_timing('dynamic sql open, fetch, close');    
        -------------------------------------
        l_bulk_limit := c_hundred;
        open cv_weak for 
        q'[select level as id, 'item ' || level  as info
        from dual connect by level <= ]' || c_total_records;
        loop
            fetch cv_weak bulk collect into l_rec_table limit l_bulk_limit;
            exit when l_rec_table.count = 0;
            for i in 1..l_rec_table.count loop
                null;
            end loop;
        end loop;
        close cv_weak;
        print_timing('dynamic sql bulk bind limit ' || l_bulk_limit);    
    end;

    dbms_output.put_line('results are ordered from fastest to slowest');
    dbms_output.put_line('results will vary with multiple test runs');
    dbms_output.put_line('*bulk bind without limit can use excessive PGA memory');
    dbms_output.put_line('**bulk bind with large limit can use excessive PGA memory');

    for i in indices of l_timings loop
        dbms_output.put_line(l_timings(i));
    end loop;

end;
/

/*
results are ordered from fastest to slowest
results will vary with multiple test runs
*bulk bind without limit can use excessive PGA memory
**bulk bind with large limit can use excessive PGA memory
weak cursor variable bulk bind all*.........................+000000000 00:00:00.379000000 for 1000000 records
weak cursor variable bulk bind limit 100....................+000000000 00:00:00.392000000 for 1000000 records
explicit cursor bulk bind limit** 10000.....................+000000000 00:00:00.395000000 for 1000000 records
strong cursor variable bulk bind limit 100..................+000000000 00:00:00.395000000 for 1000000 records
dynamic sql bulk bind limit 100.............................+000000000 00:00:00.403000000 for 1000000 records
explicit cursor for loop....................................+000000000 00:00:00.404000000 for 1000000 records
explicit cursor bulk bind limit 100.........................+000000000 00:00:00.421000000 for 1000000 records
explicit cursor bulk bind limit** 1000......................+000000000 00:00:00.429000000 for 1000000 records
strong cursor variable bulk bind all*.......................+000000000 00:00:00.583000000 for 1000000 records
explicit cursor bulk bind all*..............................+000000000 00:00:00.619000000 for 1000000 records
21c cursor iterator control.................................+000000000 00:00:00.712000000 for 1000000 records
strong cursor variable open, fetch, close...................+000000000 00:00:01.653000000 for 1000000 records
weak cursor variable open, fetch, close.....................+000000000 00:00:01.658000000 for 1000000 records
dynamic sql open, fetch, close..............................+000000000 00:00:01.746000000 for 1000000 records
explicit cursor open, fetch, close..........................+000000000 00:00:02.053000000 for 1000000 records
*/