set feedback off;
set serveroutput on;
declare
    cursor cur_data is
    select level as id, 'item ' || level as info
    from dual connect by level <= 5;
    type t_record_table is table of cur_data%rowtype index by pls_integer;
    l_recs t_record_table;
begin
    open cur_data;
    loop
        fetch cur_data bulk collect into l_recs limit 3;
        exit when cur_data%notfound;  --wrong exit condition, doesn't always process the final fetch
        for i in 1..l_recs.count loop
            dbms_output.put_line('processing ' || l_recs(i).info);
        end loop;
    end loop;
    close cur_data;    
end;
/
/*
processing item 1
processing item 2
processing item 3
*/