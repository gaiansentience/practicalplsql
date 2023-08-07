--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Cursor Iteration Control: Cursor Variable strongly typed
declare
    type t_emp_rec is record(
        name varchar2(50), job varchar2(20));
    type t_strong_cursor_variable is ref cursor return t_emp_rec;
    cv_strong t_strong_cursor_variable;
begin

    open cv_strong for
        select e.name, e.job
        from employees e
        fetch first 3 rows only;

    for r_iterand in cv_strong loop
        print_employee(r_iterand.name, r_iterand.job);
    end loop;
    
    print_boolean_attribute(cv_strong%isopen, 'cv_strong%isopen');    
    close cv_strong;

end;
/

/* Script Output:
Cursor Iteration Control: Cursor Variable strongly typed
Gina SALES_EXEC
Ann SALES_MGR
Tobias SALES_MGR
(cv_strong%isopen is true)
*/