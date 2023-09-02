--this script uses objects from examples\simple-employees
set serveroutput on;
set feedback off;

Prompt Method: Cursor For Loop with explicit cursor
declare
    cursor c_emps is
        select e.name, e.job
        from employees e
        fetch first 3 rows only;    
begin

    for r_emp in c_emps loop
        print_employee(r_emp.name, r_emp.job);
    end loop;
    
end;
/

/* Script Output:
Method: Cursor For Loop with explicit cursor
Gina SALES_EXEC
Ann SALES_MGR
Tobias SALES_MGR
*/