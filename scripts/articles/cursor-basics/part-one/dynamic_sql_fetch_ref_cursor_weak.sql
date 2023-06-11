--this script uses objects from examples\simple-employees
set serveroutput on;

prompt use weakly typed ref cursor with dynamic sql
set serveroutput on;
declare
    type t_emp_rec is record (
        name employees.name%type, 
        job employees.job%type);
    c_emp sys_refcursor;
    r_emp t_emp_rec;
begin
    open c_emp for 
        'select e.name, e.job
        from employees e
        order by e.job, e.name';
    loop
        fetch c_emp into r_emp;
        exit when c_emp%notfound;
        print_employee(r_emp.name, r_emp.job);
    end loop;
    close c_emp;
end;
/

/* Script Output:
use weakly typed ref cursor with dynamic sql
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