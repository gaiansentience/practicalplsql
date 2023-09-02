--this script uses objects from examples\simple-employees
set feedback off;
set serveroutput on;

prompt Using Cursor Object Iteration Control To Populate An Associative Array with Varchar Index
declare
    cursor c is
        select name, job
        from employees;

    type t_table is table of c%rowtype index by employees.name%type;
    l_rows t_table;
begin
    l_rows := t_table(for r in c index r.name => r);
    
    dbms_output.put_line('Collection has ' || l_rows.count || ' rows');
    for i in indices of l_rows loop
        dbms_output.put_line(l_rows(i).name || ' ' || l_rows(i).job);
    end loop;    
end;
/

/* Script Output:
Using Cursor Object Iteration Control To Populate An Associative Array with Varchar Index
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