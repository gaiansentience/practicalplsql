--this script uses objects from examples\simple-employees
set serveroutput on;

Prompt Method: Cursor Iteration Control with a strongly typed ref cursor and dynamic sql fails
declare
    type t_emp_rec is record(name varchar2(50), job varchar2(20));
    type t_emp_cur is ref cursor return t_emp_rec;
    c_emps t_emp_cur;
begin
    open c_emps for
        'select e.name, e.job
        from employees e
        fetch first 3 rows only';

    for r_emp in c_emps loop
        print_employee(r_emp.name, r_emp.job);
    end loop;
    
    print_boolean_attribute(c_emps%isopen,'c_emps%isopen');
end;
/

/* Script Output:
Method: Cursor Iteration Control with a strongly typed ref cursor and dynamic sql fails
PLS-00455: cursor 'C_EMPS' cannot be used in dynamic SQL OPEN statement
*/