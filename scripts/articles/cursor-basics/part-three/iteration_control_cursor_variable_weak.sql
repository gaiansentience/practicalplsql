--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Cursor Iteration Control: Cursor Variable weakly typed
declare
    type t_iterand_type is record(
        name varchar2(50), job varchar2(20));
    cv_weak sys_refcursor;
begin

    open cv_weak for
        select e.name, e.job
        from employees e
        fetch first 3 rows only;

    for r_iterand t_iterand_type in cv_weak loop
        print_employee(r_iterand.name, r_iterand.job);
    end loop;
    
    print_boolean_attribute(cv_weak%isopen, 'cv_weak%isopen');
    close cv_weak;

end;
/

/* Script Output:
Cursor Iteration Control: Cursor Variable weakly typed
Gina SALES_EXEC
Ann SALES_MGR
Tobias SALES_MGR
(cv_weak%isopen is true)
*/