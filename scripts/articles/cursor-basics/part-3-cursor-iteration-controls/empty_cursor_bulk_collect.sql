set serveroutput on;
set feedback off;

prompt populating collection with empty cursor: bulk collect
declare

    cursor c (p_rows in number) is
        select id, info
        from
            (
        select level as id, 'item ' || level as info
        from dual 
        connect by level <= p_rows
            )
        where id <= p_rows;

    type t_rows is table of c%rowtype;

    l_rows t_rows;
    i number := 0;
    
    procedure print_collection_state(p_rows in t_rows)
    is
    begin
        if p_rows is null then
            dbms_output.put_line('collection is null');
        else
            dbms_output.put_line('collection is initialized');
            if p_rows is empty then
                dbms_output.put_line('collection is empty');
            end if;
            dbms_output.put_line('collection count = ' || p_rows.count);
            for i in indices of p_rows loop
                dbms_output.put_line(i || ' => ' || p_rows(i).info);
            end loop;
        end if;
    end print_collection_state;
begin
    
    dbms_output.put_line('fetch 3 rows');
    l_rows := null;
    open c(3);
    fetch c bulk collect into l_rows;
    print_collection_state(l_rows);
    close c;

    dbms_output.put_line('fetch 0 rows');    
    l_rows := null;
    open c(0);
    fetch c bulk collect into l_rows;
    print_collection_state(l_rows);
    close c;
    
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

/* Script output
populating collection with empty cursor: bulk collect
fetch 3 rows
collection is initialized
collection count = 3
1 => item 1
2 => item 2
3 => item 3
fetch 0 rows
collection is initialized
collection is empty
collection count = 0
*/