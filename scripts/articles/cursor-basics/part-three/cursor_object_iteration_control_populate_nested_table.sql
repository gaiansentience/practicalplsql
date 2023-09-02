--this script uses objects from examples\simple-employees
set feedback off;
set serveroutput on;

prompt Using Cursor Object Iteration Control To Populate A Nested Table
declare
    cursor c is
        select name, job
        from employees;

    type t_table is table of c%rowtype;
    l_rows t_table;
begin
    l_rows := t_table(for r in c sequence => r);
    
    dbms_output.put_line('Collection has ' || l_rows.count || ' rows');
    for i in indices of l_rows loop
        dbms_output.put_line(l_rows(i).name || ' ' || l_rows(i).job);
    end loop;
end;
/

/* Script Output:
Using Cursor Object Iteration Control To Populate A Nested Table
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