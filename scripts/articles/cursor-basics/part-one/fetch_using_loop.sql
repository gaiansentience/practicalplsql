--this script uses objects from examples\simple-employees
set serveroutput on;

prompt fetch using loop
declare
    cursor c_emp is
        select e.name, e.job
        from employees e
        order by e.job, e.name
        fetch first 3 rows only;
    r_emp c_emp%rowtype;
begin
    open c_emp;
    for i in 1..4 loop
        fetch c_emp into r_emp;
        print_employee(r_emp.name);
    end loop;
end;
/
/* Script Output:
fetch using loop
Gina
Ann
Tobias
Tobias
*/