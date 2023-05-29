set serveroutput on;
declare
    cursor cur_data is
    select level as id, 'item ' || level as info
    from dual 
    connect by level <= 5;
    l_rec cur_data%rowtype;
begin
    open cur_data;
    loop
        fetch cur_data into l_rec;
        exit when cur_data%notfound;
        dbms_output.put_line('processing ' || l_rec.info);
    end loop;
    close cur_data;
end;
/