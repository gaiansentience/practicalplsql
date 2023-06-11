--this script uses objects from examples\simple-employees
set serveroutput on;

Prompt Method: Cursor For Loop without declared cursor variable
begin
    for r_emp in (
        select e.name, e.job
        from employees e
        order by e.job, e.name    
    ) loop
        print_employee(r_emp.name, r_emp.job);
    end loop;
end;
/

/* Script Output:
Method: Cursor For Loop without declared cursor variable
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