set feedback off;
set serveroutput on;
declare
    type rec_t is record(id number, info varchar2(100));
    cursor cur_data return rec_t is
    select level as id, 'item ' || level as info
    from dual connect by level <= 5;
    l_rec rec_t;
begin
    open cur_data;
    loop
        fetch cur_data into l_rec;
        dbms_output.put_line('processing ' || l_rec.info);
        exit when cur_data%notfound;   --processes last record twice
    end loop;
    close cur_data;
end;
/
/*
processing item 1
processing item 2
processing item 3
processing item 4
processing item 5
processing item 5
*/