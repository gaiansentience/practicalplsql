--this script uses objects from examples\simple-employees
set serveroutput on;

Prompt Method: Cursor For Loop Fails With Dynamic SQL
declare
    cursor c_emps is
        'select e.name, e.job
        from employees e
        order by e.job, e.name';
begin
    for r_emp t_emp_rec in c_emps loop
        print_employee(r.name, r.job);
    end loop;
end;
/

/* Script Output:
Method: Cursor For Loop Fails With Dynamic SQL
PLS-00103: Encountered the symbol "select e.name, e.job...
*/