set serveroutput on;
set feedback off;

prompt populating collections with empty cursors
declare

    cursor c is
        select *
        from dual
        where 1 = 0;

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
        end if;
    end print_collection_state;
begin
    
    dbms_output.put_line('fetch empty cursor using bulk collect');   
    l_rows := null;
    open c;
    fetch c bulk collect into l_rows;
    print_collection_state(l_rows);
    close c;
    
    dbms_output.put_line('fetch empty cursor using cursor object iteration control');   
    l_rows := null;
    l_rows := t_rows(for r in values of c sequence => r);
    print_collection_state(l_rows);
    
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

/* Script output
populating collections with empty cursors
fetch empty cursor using bulk collect
collection is initialized
collection count = 0
fetch empty cursor using cursor object iteration control
collection is null
*/