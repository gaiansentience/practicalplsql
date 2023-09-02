--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Multiple Cursor Iteration Controls with implicit iterand
declare
    cursor c_rep is
        select e.name, e.job
        from employees e
        where e.job = 'SALES_REP';
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
    
    for r_iterand in 
        c_rep
        , (
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR'
        )
        , cv_weak
        , (
            execute immediate l_sql using 'SALES_EXEC'
    ) loop
        print_employee(r_iterand.name, r_iterand.job);
    end loop;
    
end;
/

/* Script Output:
Multiple Cursor Iteration Controls with implicit iterand
John SALES_REP
Jane SALES_REP
Julie SALES_REP
Alex SALES_REP
Sarah SALES_REP
Ann SALES_MGR
Tobias SALES_MGR
Thomas SALES_SUPPORT
George SALES_SUPPORT
Martin SALES_SUPPORT
Gina SALES_EXEC
*/