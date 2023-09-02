--this script uses objects from examples\simple-employees
set serveroutput on;

prompt fetch using loop, correct exit placement
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
        exit when c_emp%notfound;
        print_employee(r_emp.name);
    end loop;
    close c_emp;
end;
/
/* Script Output:
fetch using loop, correct exit placement
Gina
Ann
Tobias
*/