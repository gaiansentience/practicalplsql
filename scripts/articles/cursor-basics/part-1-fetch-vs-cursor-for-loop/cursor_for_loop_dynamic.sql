--this script uses objects from examples\simple-employees
set serveroutput on;

Prompt Cursor For Loop Fails With Dynamic SQL
declare
    cursor c_emps is
        'select e.name, e.job
        from employees e';
begin
    for r_emp in c_emps loop
        print_employee(r_emp.name, r_emp.job);
    end loop;
end;
/

/* Script Output:
Cursor For Loop Fails With Dynamic SQL
PLS-00103: Encountered the symbol "select e.name, e.job...
*/