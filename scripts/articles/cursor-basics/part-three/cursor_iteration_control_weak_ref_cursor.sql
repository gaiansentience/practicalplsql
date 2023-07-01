--this script uses objects from examples\simple-employees
set serveroutput on;

Prompt Method: Cursor Iteration Control with a weakly typed ref cursor defines the iterator
declare
    type t_emp_rec is record(name varchar2(50), job varchar2(20));
    c_emps sys_refcursor;
begin
    open c_emps for
        select e.name, e.job
        from employees e
        fetch first 3 rows only;

    for r_emp t_emp_rec in c_emps loop
        print_employee(r_emp.name, r_emp.job);
    end loop;
    print_boolean_attribute(c_emps%isopen,'c_emps%isopen');
end;
/

/* Script Output:
Method: Cursor Iteration Control with a weakly typed ref cursor defines the iterator
Gina SALES_EXEC
Ann SALES_MGR
Tobias SALES_MGR
(c_emps%isopen is true)
*/