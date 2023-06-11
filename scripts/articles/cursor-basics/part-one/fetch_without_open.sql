--this script uses objects from examples\simple-employees
set serveroutput on;

prompt Fetch without open
declare
    cursor c_emp is
        select e.name, e.job
        from employees e;
    r_emp c_emp%rowtype;
begin
    fetch c_emp into r_emp;
exception
    when others then
        dbms_output.put(sqlerrm);
        print_boolean_attribute(c_emp%isopen, 'c_emp%isopen');
end;
/

/* Script Output:
ORA-01001: invalid cursor(c_emp%isopen is false)
*/