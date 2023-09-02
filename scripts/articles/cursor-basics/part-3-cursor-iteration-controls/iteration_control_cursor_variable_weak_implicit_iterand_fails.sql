--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Cursor Iteration Control: Cursor Variable weakly typed Needs Iterand Type
declare
    cv_weak sys_refcursor;
begin

    open cv_weak for
        select e.name, e.job
        from employees e
        fetch first 3 rows only;

    for r_iterand in cv_weak loop
        print_employee(r_iterand.name, r_iterand.job);
    end loop;
    
    close cv_weak;

end;
/

/* Script Output:
Error report -
ORA-06550: line 10, column 18:
PLS-00859: No iterand type was specified for a weak Cursor Variable iteration control.
*/