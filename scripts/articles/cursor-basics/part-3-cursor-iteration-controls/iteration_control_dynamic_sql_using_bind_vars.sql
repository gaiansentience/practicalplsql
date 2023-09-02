--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Cursor Iteration Control: Dynamic Sql using bind variables
declare
    type t_iterand_type is record(
        name varchar2(50), job varchar2(20));
    l_sql varchar2(1000);
begin

    l_sql :=
        'select e.name, e.job
        from employees e
        where job = :bind_variable ';
    
    for r_iterand t_iterand_type in (
        execute immediate l_sql using 'SALES_MGR'
    ) loop
        print_employee(r_iterand.name, r_iterand.job);
    end loop;
    
end;
/

/* Script Output:
Cursor Iteration Control: Dynamic Sql using bind variables
Ann SALES_MGR
Tobias SALES_MGR
*/