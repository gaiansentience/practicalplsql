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
        exit when cur_data%notfound;
        dbms_output.put_line('processing ' || l_rec.info);
    end loop;
    close cur_data;

exception
    when others then
        if cur_data%isopen then
            close cur_data;
        end if;
        raise;
end;
/