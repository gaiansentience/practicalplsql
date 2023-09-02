--this script uses objects from examples\simple-employees
set serveroutput on;

prompt fetch from strongly typed ref cursor
declare
    type t_emp_rec is record (
        name employees.name%type, 
        job employees.job%type);
    type t_emp_cur is ref cursor return t_emp_rec;
    c_emp t_emp_cur;    
    r_emp t_emp_rec;
begin
    open c_emp for 
        select e.name, e.job
        from employees e
        order by e.job, e.name;
    loop
        fetch c_emp into r_emp;
        exit when c_emp%notfound;
        print_employee(r_emp.name, r_emp.job);
    end loop;
    close c_emp;
end;
/

/* Script Output:
fetch from strongly typed ref cursor
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