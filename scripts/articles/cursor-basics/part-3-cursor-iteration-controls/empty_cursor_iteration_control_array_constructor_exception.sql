set serveroutput on;
set feedback off;

prompt empty cursor with iteration control returns null collection
declare
    cursor c is
        select *
        from dual
        where 1 = 0;

    type t_rows is table of c%rowtype;
    l_rows t_rows;
begin        
    l_rows := t_rows(for r in values of c sequence => r);
    dbms_output.put_line('fetched ' || l_rows.count || ' rows');
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;
/

/* Script output
empty cursor with iteration control returns null collection
ORA-06531: Reference to uninitialized collection
*/