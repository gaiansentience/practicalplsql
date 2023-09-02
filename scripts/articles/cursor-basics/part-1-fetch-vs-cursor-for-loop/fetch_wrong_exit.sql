--this script uses objects from examples\simple-employees
set serveroutput on;

prompt fetch using loop, wrong exit placement
declare
    cursor c_emp is
        select e.name, e.job
        from employees e
        order by e.job, e.name
        fetch first 3 rows only;
    r_emp c_emp%rowtype;
begin
    open c_emp;
    loop
        fetch c_emp into r_emp;
        print_employee(r_emp.name);
        exit when c_emp%notfound;
    end loop;
end;
/
/* Script Output:
fetch using loop, wrong exit placement
Gina
Ann
Tobias
Tobias
*/