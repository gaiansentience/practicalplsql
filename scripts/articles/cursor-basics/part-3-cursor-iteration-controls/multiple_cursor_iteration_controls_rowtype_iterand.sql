--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Multiple Cursor Iteration Controls with rowtype iterand
declare
    cursor c_rep is
        select e.name, e.job
        from employees e
        where e.job = 'SALES_REP';

    cursor c_mgr is
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR';
        
    l_sql varchar2(100);
begin

    l_sql :=  
        'select e.name, e.job
        from employees e
        where e.job = :bind_variable ';
    
    for r_iterand c_rep%rowtype in 
        c_rep
        , (
            execute immediate l_sql using 'SALES_EXEC'
        )
        , c_mgr
         loop
        print_employee(r_iterand.name, r_iterand.job);
    end loop;
    
end;
/

/* Script Output:
Multiple Cursor Iteration Controls with rowtype iterand
John SALES_REP
Jane SALES_REP
Julie SALES_REP
Alex SALES_REP
Sarah SALES_REP
Gina SALES_EXEC
Ann SALES_MGR
Tobias SALES_MGR
*/