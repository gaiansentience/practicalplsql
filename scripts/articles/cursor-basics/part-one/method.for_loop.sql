--this script uses objects from examples\simple-employees
set serveroutput on;

Prompt Method: Cursor For Loop
declare
    cursor c_emps is
        select e.name, e.job
        from employees e
        order by e.job, e.name;
begin
    for r in c_emps loop
        print_employee(r.name, r.job);
    end loop;
end;
/

/* Script Output:
Method: Cursor For Loop
Gina SALES_EXEC
Ann SALES_MGR
Tobias SALES_MGR
Alex SALES_REP
Jane SALES_REP
John SALES_REP
Julie SALES_REP
Sarah SALES_REP
George SALES_SUPPORT
Martin SALES_SUPPORT
Thomas SALES_SUPPORT
*/