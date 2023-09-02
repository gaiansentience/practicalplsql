--this script uses objects from examples\simple-employees
set feedback off;
set serveroutput on;

prompt Using Multiple Cursor Object Iteration Controls To Populate An Associative Array with Varchar Index
declare
    cursor c_rep is
        select name, job
        from employees
        where job = 'SALES_REP';

    cursor c_mgr is
        select name, job
        from employees
        where job = 'SALES_MGR';

    type t_table is table of c_rep%rowtype index by employees.name%type;
    l_rows t_table;
begin
    l_rows := t_table(for r in c_rep, c_mgr index r.name => r);
    
    dbms_output.put_line('Collection has ' || l_rows.count || ' rows');
    for i in indices of l_rows loop
        dbms_output.put_line(l_rows(i).name || ' ' || l_rows(i).job);
    end loop;
end;
/

/* Script Output:
Using Multiple Cursor Object Iteration Controls To Populate An Associative Array with Varchar Index
Collection has 7 rows
Alex SALES_REP
Ann SALES_MGR
Jane SALES_REP
John SALES_REP
Julie SALES_REP
Sarah SALES_REP
Tobias SALES_MGR
*/