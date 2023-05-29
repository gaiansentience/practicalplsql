set serveroutput on;
declare
    type rec_t is record(id number, info varchar2(100));
    cur_data sys_refcursor;
    l_rec rec_t;
begin
    open cur_data for 
    select level as id, 'item ' || level as info
    from dual connect by level <= 5;
    loop
        fetch cur_data into l_rec;
        exit when cur_data%notfound;
        dbms_output.put_line('processing ' || l_rec.info);
    end loop;
    close cur_data;
end;
/