--this script uses objects from examples\simple-employees
set serveroutput on;

prompt repeating fetch calls
declare
    cursor c_emp is
        select e.name, e.job
        from employees e
        order by e.job, e.name
        fetch first 2 rows only;
    r_emp c_emp%rowtype;
begin
    open c_emp;

    fetch c_emp into r_emp;
    print_employee(r_emp.name, r_emp.job);

    fetch c_emp into r_emp;
    print_employee(r_emp.name, r_emp.job);
end;
/
/* Script Output:
repeating fetch calls
Gina SALES_EXEC
Ann SALES_MGR
*/