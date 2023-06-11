--this script uses objects from examples\simple-employees
set serveroutput on;

prompt fetch parameterized cursor, must close before reopening
declare
    cursor c_emp(p_job in varchar2) is
        select e.name, e.job
        from employees e
        where e.job = p_job;
    r_emp c_emp%rowtype;
begin
    print_boolean_attribute(c_emp%isopen,'c_emp%isopen');
    open c_emp('SALES_MGR');
    print_boolean_attribute(c_emp%isopen,'c_emp%isopen');
    fetch c_emp into r_emp;
    print_employee(r_emp.name, r_emp.job);
    
    dbms_output.put_line('Reopen cursor with a different parameter');
    print_boolean_attribute(c_emp%isopen,'c_emp%isopen');
    open c_emp('SALES_EXEC');    
exception
    when others then
        dbms_output.put_line(sqlerrm);
        print_boolean_attribute(c_emp%isopen,'c_emp%isopen');
end;
/

/* Script Output:
fetch parameterized cursor, must close before reopening
(c_emp%isopen is false)
(c_emp%isopen is true)
Ann SALES_MGR
Reopen cursor with a different parameter
(c_emp%isopen is true)
ORA-06511: PL/SQL: cursor already open
(c_emp%isopen is true)
*/