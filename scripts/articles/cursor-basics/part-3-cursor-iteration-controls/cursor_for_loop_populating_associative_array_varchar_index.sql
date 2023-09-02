--this script uses objects from examples\simple-employees
set feedback off;
set serveroutput on;

prompt Using A Cursor For Loop To Populate an Associative Array with Varchar2 Index
declare
    cursor c is
        select name, job
        from employees;

    type t_table is table of c%rowtype index by employees.name%type;
    l_rows t_table;
begin
    for r in c loop
        l_rows(r.name) := r;
    end loop;
    
    dbms_output.put_line('Collection has ' || l_rows.count || ' rows');
    for i in indices of l_rows loop
        dbms_output.put_line(l_rows(i).name || ' ' || l_rows(i).job);
    end loop;
end;
/

/* Script Output:
Using A Cursor For Loop To Populate an Associative Array with Varchar2 Index
Collection has 11 rows
Alex SALES_REP
Ann SALES_MGR
George SALES_SUPPORT
Gina SALES_EXEC
Jane SALES_REP
John SALES_REP
Julie SALES_REP
Martin SALES_SUPPORT
Sarah SALES_REP
Thomas SALES_SUPPORT
Tobias SALES_MGR
*/