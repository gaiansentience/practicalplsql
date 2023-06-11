--this script uses objects from examples\simple-employees
set serveroutput on;

Prompt Method: Open, Fetch, Close
declare
    cursor c_emps is
        select e.name, e.job
        from employees e
        order by e.job, e.name;
    type t_emp_rec is record(
        name varchar2(50), job varchar2(50));
    r_emp t_emp_rec;  
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
Method: Open, Fetch, Close
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
