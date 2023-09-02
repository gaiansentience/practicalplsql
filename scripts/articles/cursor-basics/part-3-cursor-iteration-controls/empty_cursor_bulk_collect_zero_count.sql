set serveroutput on;
set feedback off;

prompt empty cursor bulk collect returns empty collection
declare
    cursor c is
        select *
        from dual
        where 1 = 0;

    type t_rows is table of c%rowtype;
    l_rows t_rows;
begin        
    open c;
    fetch c bulk collect into l_rows;
    close c;
    dbms_output.put_line('fetched ' || l_rows.count || ' rows');
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

/* Script output
empty cursor bulk collect returns empty collection
fetched 0 rows
*/