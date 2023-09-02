--this script uses objects from examples\simple-employees
set serveroutput on;

Prompt Fetching into separate variables
declare
    cursor c_emps is
        select e.name, e.job
        from employees e
        order by e.job, e.name;
    l_name employees.name%type;
    l_job employees.job%type;
begin
    open c_emps;
    loop
        fetch c_emps into l_name, l_job;
        exit when c_emps%notfound;
        print_employee(l_name, l_job);
    end loop;
end;
/

/* Script Output:
Fetching into separate variables
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
