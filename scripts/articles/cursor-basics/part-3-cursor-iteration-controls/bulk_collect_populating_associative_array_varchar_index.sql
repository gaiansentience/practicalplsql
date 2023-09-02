--this script uses objects from examples\simple-employees
set feedback off;
set serveroutput on;

prompt Using Bulk Collect To Populate An Associative Array with a varchar index from a cursor
declare
    cursor c is
        select name, job
        from employees;

    type t_table is table of c%rowtype index by employees.name%type;
    l_rows t_table;
    type t_table_int is table of c%rowtype index by pls_integer;
    l_rows_int t_table_int;
begin
    open c;
    fetch c bulk collect into l_rows_int;
    close c;
    
    for i in 1..l_rows_int.count loop
        l_rows(l_rows_int(i).name) := l_rows_int(i);
    end loop;
    
    dbms_output.put_line('Collection has ' || l_rows.count || ' rows');
    for i in indices of l_rows loop
        dbms_output.put_line(l_rows(i).name || ' ' || l_rows(i).job);
    end loop;
end;
/

/* Script Output:
Using Bulk Collect To Populate An Associative Array with a varchar index from a cursor
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