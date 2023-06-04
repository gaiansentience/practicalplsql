set feedback off;
set serveroutput on;
declare
    cursor c is
    select 'item ' || level as item_name
    from dual connect by level <= 3;
    l_rec c%rowtype;
begin
    open c;
    loop
        fetch c into l_rec;
        dbms_output.put_line('processing ' || l_rec.item_name);
        
        exit when c%notfound;   --processes last record twice
    end loop;
    close c;
end;
/
--processing item 1
--processing item 2
--processing item 3
--processing item 3
