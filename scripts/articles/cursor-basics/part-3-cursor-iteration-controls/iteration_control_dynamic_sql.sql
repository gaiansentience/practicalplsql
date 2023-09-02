--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Cursor Iteration Control: Dynamic Sql with typed iterand
declare
    type t_iterand_type is record(
        name varchar2(50), job varchar2(20));
    l_sql varchar2(1000);
begin

    l_sql :=
        'select e.name, e.job
        from employees e
        fetch first 3 rows only';
    
    for r_iterand t_iterand_type in (execute immediate l_sql) loop
        print_employee(r_iterand.name, r_iterand.job);
    end loop;
    
end;
/

/* Script Output:
Cursor Iteration Control: Dynamic Sql with typed iterand
Gina SALES_EXEC
Ann SALES_MGR
Tobias SALES_MGR
*/