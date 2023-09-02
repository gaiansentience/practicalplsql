--this script uses objects from examples\simple-employees
set feedback off;
set serveroutput on;

prompt Using Bulk Collect To Populate An Associative Array from a cursor
declare
    cursor c is
        select name, job
        from employees;

    type t_table is table of c%rowtype index by pls_integer;
    l_rows t_table;
begin
    open c;
    fetch c bulk collect into l_rows;
    close c;
    
    dbms_output.put_line('Collection has ' || l_rows.count || ' rows');
    for i in indices of l_rows loop
        dbms_output.put_line(l_rows(i).name || ' ' || l_rows(i).job);
    end loop;
end;
/

/* Script Output:
Using Bulk Collect To Populate An Associative Array from a cursor
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