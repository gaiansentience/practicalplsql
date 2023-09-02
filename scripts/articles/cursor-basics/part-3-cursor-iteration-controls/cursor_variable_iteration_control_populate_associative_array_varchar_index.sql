--this script uses objects from examples\simple-employees
set feedback off;
set serveroutput on;

prompt Using Cursor Variable Iteration Control To Populate An Associative Array with Varchar Index
declare
    cv sys_refcursor;
    type t_rec is record (name employees.name%type, job employees.job%type);
    type t_table is table of t_rec index by employees.name%type;
    l_rows t_table;
begin
    open cv for 
        select name, job
        from employees;
    
    l_rows := t_table(for r t_rec in cv index r.name => r);
    
    dbms_output.put_line('After constructing array, cursor variable is still open');
    print_boolean_attribute(cv%isopen, 'cv%isopen');
    close cv;
    
    dbms_output.put_line('Collection has ' || l_rows.count || ' rows');
    for i in indices of l_rows loop
        dbms_output.put_line(l_rows(i).name || ' ' || l_rows(i).job);
    end loop;    
end;
/

/* Script Output:
Using Cursor Variable Iteration Control To Populate An Associative Array with Varchar Index
After constructing array, cursor variable is still open
(cv%isopen is true)
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