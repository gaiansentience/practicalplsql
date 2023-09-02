--this script uses objects from examples\simple-employees
set feedback off;
set serveroutput on;

prompt Using A Cursor For Loop To Populate a Nested Table
declare
    cursor c is
        select name, job
        from employees;

    type t_table is table of c%rowtype;
    l_rows t_table := t_table();
begin
    for r in c loop
        l_rows.extend();
        l_rows(l_rows.last) := r;
    end loop;
    
    dbms_output.put_line('Collection has ' || l_rows.count || ' rows');
    for i in indices of l_rows loop
        dbms_output.put_line(l_rows(i).name || ' ' || l_rows(i).job);
    end loop;
end;
/

/* Script Output:
Using A Cursor For Loop To Populate a Nested Table
Collection has 11 rows
Gina SALES_EXEC
Ann SALES_MGR
Tobias SALES_MGR
John SALES_REP
Jane SALES_REP
Julie SALES_REP
Alex SALES_REP
Sarah SALES_REP
Thomas SALES_SUPPORT
George SALES_SUPPORT
Martin SALES_SUPPORT
*/