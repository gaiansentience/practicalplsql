--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Cursor Iteration Control: Dynamic Sql with implicitly typed iterand fails
declare
    l_sql varchar2(1000);
begin

    l_sql :=
        'select e.name, e.job
        from employees e
        fetch first 3 rows only';
    
    for r_iterand in (execute immediate l_sql) loop
        print_employee(r_iterand.name, r_iterand.job);
    end loop;
    
end;
/

/* Script Output:
PLS-00858: No iterand type was specified for an EXECUTE IMMEDIATE iteration control.
*/