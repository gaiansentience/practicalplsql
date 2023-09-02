--this script uses objects from examples\simple-employees
set serveroutput on;

Prompt Using a rowtype anchor for iteration variable
declare
    cursor c_emps is
        select e.name, e.job
        from employees e
        order by e.job, e.name;
    r_emp c_emps%rowtype;
begin
    open c_emps;
    loop
        fetch c_emps into r_emp;
        exit when c_emps%notfound;
        print_employee(r_emp.name, r_emp.job);
    end loop;
end;
/

/* Script Output:
Using a rowtype anchor for iteration variable
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
