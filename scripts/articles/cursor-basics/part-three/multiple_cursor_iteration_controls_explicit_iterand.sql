--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Multiple Cursor Iteration Controls with explicit iterand
declare
    type t_iterand_type is record(
        name varchar2(50), job varchar2(20));

    cv_weak sys_refcursor;
    l_sql varchar2(100);
begin

    open cv_weak for 
        select e.name, e.job
        from employees e
        where e.job = 'SALES_SUPPORT';

    l_sql :=  
        'select e.name, e.job
        from employees e
        where e.job = :bind_variable ';
    
    for r_iterand t_iterand_type in 
        cv_weak
        , (
            execute immediate l_sql using 'SALES_EXEC'
    ) loop
        print_employee(r_iterand.name, r_iterand.job);
    end loop;
    
end;
/

/* Script Output:
Multiple Cursor Iteration Controls with explicit iterand
Thomas SALES_SUPPORT
George SALES_SUPPORT
Martin SALES_SUPPORT
Gina SALES_EXEC
*/