--this script uses objects from examples\simple-employees
set serveroutput on;

prompt trying to open a cursor that is already open
declare
    cursor c_emp is
        select e.name, e.job
        from employees e;
    r_emp c_emp%rowtype;
begin
    dbms_output.put('before opening the cursor');
    print_boolean_attribute(c_emp%isopen,'c_emp%isopen');
    open c_emp;
    dbms_output.put('after opening the cursor');
    print_boolean_attribute(c_emp%isopen,'c_emp%isopen');
    dbms_output.put_line('open the cursor again');
    open c_emp;
exception
    when others then
        dbms_output.put_line(sqlerrm);
        print_boolean_attribute(c_emp%isopen, 'c_emp%isopen');
        if c_emp%isopen then
            close c_emp;
        end if;
end;
/

/* Script Output:
trying to open a cursor that is already open
before opening the cursor(c_emp%isopen is false)
after opening the cursor(c_emp%isopen is true)
open the cursor again
ORA-06511: PL/SQL: cursor already open
(c_emp%isopen is true)
*/