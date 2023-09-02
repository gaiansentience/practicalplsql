--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Cursor Iteration Control: Multiple Sql Statements
begin

    for r_iterand in (
        select e.name, e.job
        from employees e
        where e.job = 'SALES_REP'    
        ), (
        select e.name, e.job
        from employees e
        where e.job = 'SALES_MGR'
        ) loop
        print_employee(r_iterand.name, r_iterand.job);
    end loop;
    
end;
/

/* Script Output:
Cursor Iteration Control: Multiple Sql Statements
John SALES_REP
Jane SALES_REP
Julie SALES_REP
Alex SALES_REP
Sarah SALES_REP
Ann SALES_MGR
Tobias SALES_MGR
*/